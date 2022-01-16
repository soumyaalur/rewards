class Api::V1::TransactionsController < ApplicationController
  
  def index 
    transactions = Transactions.all
    render json: transactions
  end

  def add_transaction
    Transaction.create_transaction!(params[:user_id], add_transaction_params)
    render json: {message: 'Transaction was added sucessfully'}, status: :created
  rescue => e
    Rails.logger.error(e.message)
    render error: {error: 'Error in adding the the transaction'}, status: 400
  end

  def balance
    balance = Transaction.balance(params[:user_id])
    render json: balance, status: 200
  rescue => e
    Rails.logger.error(e.message)
    render error: {error: 'Something went wrong'}, status: 400
  end

  def spend
    deductions = Transaction.spend!(params[:user_id], spend_params)
    render json: deductions_response(deductions), status: 200
  rescue => e
    Rails.logger.error(e.message)
    Rails.logger.error(e.backtrace)
    render error: {error: 'Something went wrong'}, status: 400
  end

  private

  def add_transaction_params
    params.permit(:payer, :points, :timestamp, :user_id)
  end

  def spend_params
    params.permit(:points)
  end

  def deductions_response(deductions)
    deductions.map do|payer, points|
      next if points === 0

      { payer:  payer, points: points}
    end.compact
  end
end
