class LotteryRecord < CampaignRecord
  # belongs_to :user
  # belongs_to :lottery

  def self.generate_hit(periods,max_participants,lottery)
    now = Time.now
    which = "#{now.hour}#{now.min}#{now.sec}#{now.usec}".to_f % max_participants
    hit = "#{10000001 + which.to_i}"
    order = LotteryOrder.find_by(code:hit,periods: periods)
    if order
      create(code: hit,periods: periods,user:  order.user,campaign: lottery)
    end
  end
end