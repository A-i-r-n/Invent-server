class LotteryOrder < CampaignOrder

  # belongs_to :lottery
  # belongs_to :user

  STATUSES = %w(active inactive).freeze

  has_many :payments,as: :item, dependent: :destroy, class_name: 'Payment'

  before_update :generate_code

  # def generate_code
  #   if amount_paid > 0
  #     self.code = "#{10000001 + lottery.participants}"
  #     self.periods = lottery.periods
  #     lottery.check_next_periods
  #   end
  # end

  def generate_code
    if amount_paid > 0
      self.code = "#{10000001 + campaign.participants}"
      self.periods = campaign.periods
      campaign.check_next_periods
    end
  end

end
