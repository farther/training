require 'rails_helper'

RSpec.describe LoadCash do
  before do
    @account = Account.create
  end

  it 'return json with error message' do
    cash = '[{"denomination":50},{"denomination":5,"amount":4}]'
    block = LoadCash.new(account: @account.number, cash: cash).call
    expect(block[:message][:answer]).to eq 'Key amount is not present in'
    expect(@account.balance).to eq 0

  end

  it 'return json with success message' do
    cash = '[{"denomination":50,"amount":2},{"denomination":5,"amount":4}]'
    block = LoadCash.new(account: @account.number, cash: cash).call
    expect(block[:message]).to eq 'success'
    expect(@account.balance).to eq 120
  end

end
