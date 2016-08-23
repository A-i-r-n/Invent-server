class MallItemOrder < CampaignOrder

  STATUSES = %w(active inactive).freeze

  # belongs_to :mall_item
  # belongs_to :user

  has_many :payments,as: :item, dependent: :destroy, class_name: 'Payment'

  include :ConfigManager

  serialize :settings , Hash

  setting :probability , :float, 0.1
  setting :reduce,:integer,1

  before_create :is_lucky

  def is_lucky
    if amount_paid > 0
      if @luck ||= lucky?(0)
        MallItemRecord.create(user: user,campaign: campaign)
      end
      @luck
    else
      false
    end
  end

  def jluck
    @luck ? '1' : '0'
  end

  def lucky?(expected)
    nsec = Time.now.nsec
    token =  rand(nsec) % (1/tool(nsec)).to_i
    expected = expected % (1/tool(nsec)).to_i
    if token == expected
      true
    else
      false
    end
  end

  def tool(expire_time)
    factor = Time.now.nsec / expire_time
    probability * (factor ** reduce)
  end

end
