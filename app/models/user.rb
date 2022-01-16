class User < ApplicationRecord
  has_many :transactions

  def as_json(args)
    super(args)
    {
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email,
    }
  end
end
