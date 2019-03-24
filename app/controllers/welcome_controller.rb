class WelcomeController < ApplicationController

  def index
    @account = Account.last
    @sum = 119
    @cash = '[{"denomination":1,"amount":100},{"denomination":2,"amount":50},{"denomination":5,"amount":25},{"denomination":1,"amount":20},{"denomination":25,"amount":10},{"denomination":50,"amount":10}]'
  end

end
