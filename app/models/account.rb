class Account < ActiveRecord::Base

  has_many :banknotes

  before_create :set_number

  def balance
    banknotes.sum(:denomination)
  end

  def available_banknotes(denomination)
    self.banknotes.where(denomination: denomination)
  end

  def get_cash(sum)
    GetCash.new(account: self.number, sum: sum).call
  end

  def charge(cash)
    LoadCash.new(account: self.number, cash: cash).call
  end

  private

  def set_number
    self.number = generate_number
  end

  def generate_number
    loop do
      number = SecureRandom.hex(3).upcase
      break number unless Account.exists?(number: number)
    end
  end

end



