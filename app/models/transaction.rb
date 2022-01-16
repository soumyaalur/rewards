class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :payer

  class << self
    def create_transaction!(user_id, params)
      raise "Params cannot be empty" if params.empty?

      Transaction.create!(transaction_params!(user_id, params))
    end

    def transaction_params!(user_id, params)
      payer = Payer.find_by!(name: params[:payer])
      user = User.find(user_id)
      {
        payer: payer,
        user: user,
        points: params[:points],
        transaction_time: params[:timestamp]
      }
    end

    def balance(user_id)
      user = User.find(user_id)
      Transaction.includes(:payer).where(user_id: user.id).group("payers.name").sum(:points)
    end

    def spend!(user_id, params)
      raise "Params cannot be empty" if params.empty?

      user = User.find(user_id)
      rem_points = params[:points].to_i
      
      all_transactions = Transaction.includes(:payer).where(user: user).where.not(points: 0).order(:transaction_time)
      payers_total = Hash.new {|h, k| h[k] = 0}
      available_points = 0
      all_transactions.each do|transaction|
        payers_total[transaction.payer_id] += transaction.points
        available_points += transaction.points
      end

      raise "No enough points available" if available_points < rem_points

      deduct_points(all_transactions, payers_total, rem_points)
    end

    def deduct_points(transactions, payers_total, rem_points)
      deductions = Hash.new { |h, k| h[k] = 0 }
      transactions.each do|transaction|
        break if rem_points == 0
        next if payers_total[transaction.payer_id] == 0

        curr_points = [transaction.points, rem_points].min
        curr_balance = payers_total[transaction.payer_id]
        payer_new_balance = curr_balance - curr_points
        
        if payer_new_balance >= 0
          transaction.points -= curr_points
          rem_points -= curr_points
          payers_total[transaction.payer_id] -= curr_points
          deductions[transaction.payer.name] -= curr_points
          transaction.save!
          next
        end
        
        if transaction.points > curr_balance
          transaction.points -= curr_balance
          rem_points -= curr_balance
          deductions[transaction.payer.name] -= curr_balance
          payers_total[transaction.payer_id] = 0
          transaction.save!
        end
      end
      deductions
    end
  end
end
