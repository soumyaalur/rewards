class Payer < ApplicationRecord
  has_many :transactions

  def as_json(args)
    super(args)
    {
      id: id,
      name: name,
    }
  end
end
