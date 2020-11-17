class GetCash
  DENOMINATION_SCOPE = Banknote::DENOMINATION_SCOPE

  attr_accessor :account, :banknotes, :balance, :sum

  def initialize(account:, sum: 0)
  @sum = sum.to_i
  @account = Account.find_by number: account
  @balance = @account.balance
  end

  def call
  return {cash: [], message: "Non-existent account #{account.number}"} unless account.present?
  return {cash: [], message: "Insufficient funds on account #{account.number}"} if balance < sum || balance == 0

  calculate_cash

  end

private

  def calculate_cash
    cash = []
    @transaction_amount = sum
    DENOMINATION_SCOPE.reverse.each do |denomination|

      if @transaction_amount >= denomination
        amount = @transaction_amount / denomination
        banknotes = account.banknotes.where(denomination: denomination)

        if banknotes.size >= amount
          cash += banknotes.first(amount)
          @transaction_amount = @transaction_amount % denomination
        else
          cash += banknotes
          @transaction_amount = @transaction_amount - banknotes.sum(:denomination)

        end
      end
    end
      return {cash: [], message: "No banknotes with this denomination"} if sum - @transaction_amount == 0
      return {cash: [], message: "Available for withdraw only #{sum - @transaction_amount}$"} if @transaction_amount > 0

    {cash: cash, message: 'success'}
  end

end
