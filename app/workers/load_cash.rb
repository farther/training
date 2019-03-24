class LoadCash

  attr_accessor :account, :cash

  def initialize(account:, cash:)
    @cash = cash
    @account = Account.find_by number: account
  end

  def call

    cash = JSON.parse(@cash, {:symbolize_names => true}) rescue nil
    return {
        message: {answer: 'Hash error. For example',
                  cash: '[{"denomination":1,"amount":100},{"denomination":2,"amount":50}]'
        }
    } if cash.blank?

    return {message: 'Array error - Array of Hashes mast be inside of []'} unless cash.is_a? Array


    cash.each do |banknote|
      return {message: {answer: "Key denomination is not present in", cash: banknote}} unless banknote[:denomination].present?
      return {message: {answer: "Key amount is not present in", cash: banknote}} unless banknote[:amount].present?
      @money = []
      banknote[:amount].to_i.times do
        @money = account.banknotes.new(denomination: banknote[:denomination].to_i)
        return {message: @money.errors} unless @money.save
      end
    end
    {message: 'success'}
  end

end