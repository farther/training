class Banknote < ActiveRecord::Base

  belongs_to :account

  DENOMINATION_SCOPE = [1,2,5,10,25,50]

  validates :account, presence: true
  validates :denomination, presence: true, numericality: {greater_than_or_equal_to:  1}, on: :create
  validates :denomination, inclusion: { in: DENOMINATION_SCOPE,
                                        message: "%{value} is not a valid denomination" }


  before_create :add_data

  private

  def add_data
    self.description = 'bank of USA'
    self.title = "#{self.denomination}$"
  end

end
