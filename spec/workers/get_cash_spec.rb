require 'rails_helper'

RSpec.describe GetCash, type: :helper do

  it 'return json with error message' do
    account = Account.create
    block = GetCash.new(account: account.number, sum: 119).call
    expect(block).to include({cash: [], message: "Insufficient funds on account #{account.number}"})
  end

  it 'return json with success message' do
    account = Account.create
    account.charge('[{"denomination":50,"amount":2},{"denomination":5,"amount":4}]')
    block = GetCash.new(account: account.number, sum: 120).call
    expect(block[:message]).to eq 'success'
    expect(block[:cash].map{|b| b.denomination}.sum).to eq 120

  end

end
