class Api::V1::PayersController < ApplicationController

  def index
    payers = Payer.all
    render json: payers
  end
end
