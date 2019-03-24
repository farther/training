class Api::AccountController < ApplicationController
  require 'json'

   before_action :check_account, only: [:balance, :load_cash, :get_cash]

  def new

    account = Account.create
    render json: {account: account.number, balance: account.balance}, status: :ok

  end

  def balance

    render json: {account: account.number, balance: account.balance}, status: :ok

  end

  def load_cash

      request = account.charge(params[:cash])

      if request[:message] == 'success'
        render json: {account: account.number, balance: account.balance}, status: :ok
      else
        render json: {account: account.number, message: request[:message]}, status: :ok
      end

  end

  def get_cash

      request = account.get_cash(params[:sum])

      if request[:message] == 'success' && account.banknotes.where(id: request[:cash]).delete_all
        render json: {account: account.number, money: request[:cash].map {|c| c.title}, balance: account.balance}, status: :ok
      else
        render json: {account: account.number, message: request[:message]}, status: :ok
      end

  end

  private

  def check_account

    if account.blank?
      render json: {account: params[:account_id], message: "Not Found"}, status: :ok
    end

  end


  def account

    @account ||= Account.find_by number: params[:account_id]

  end

end
