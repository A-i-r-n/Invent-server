class LotteryOrder < ActiveRecord::Base

  STATUSES = %w(active inactive).freeze

  belongs_to :lottery
  belongs_to :user

  has_many :payments,as: :item, dependent: :destroy, class_name: 'Payment'

  before_update :generate_code

  def generate_code
    if amount_paid > 0
      self.code = "#{10000001 + lottery.participants}"
      self.periods = lottery.periods
      lottery.check_next_periods
    end
  end

end
