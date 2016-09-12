class Message < ActiveRecord::Base

  belongs_to :user

  SMS_CODE = :sms_code
  PUSH_ORDER = :push

  PRODUCT = (Rails.env == "production")

  scope :push_order,->(user){
    where(message_type: PUSH_ORDER,user: user).order(created_at: :desc)
  }

  def initialize(attributes = nil, options = {})
    super(attributes,options)
    self.user = User.find_by_phone(phone)
    # @client = JPush::JPushClient.new(APP_KEY, MASTER_SECRET)
  end

  def send_sms_code(code)
    # {"alibaba_aliqin_fc_sms_num_send_response":{"result":{"err_code":"0","model":"102499326363^1103190124047","success":true},"request_id":"ishl6zv86n11"}}
    # {"error_response":{"code":15,"msg":"Remote service error","sub_code":"isv.BUSINESS_LIMIT_CONTROL","sub_msg":"触发业务流控","request_id":"isgq0j7nbm80"}}
    self.message_type = SMS_CODE
    save
    @result = Alidayu::Sms.send_code_for_code(params[:phone], { code: code}, '') if PRODUCT
    self
  end

  # def push_sms(audience = "all")
  #
  #  tag = case audience
  #     when 'tag'
  #       # JPush::Audience.build(_alias:[self.mobile])
  #       JPush::Audience.build(tag: Array["#{self.mobile}"])
  #     else 'all'
  #       JPush::Audience.all
  #   end
  #
  #   payload =JPush::PushPayload.build(platform: JPush::Platform.all,
  #                                     audience: tag,
  #                                     notification: JPush::Notification.new(alert: self.content),
  #                                     options:JPush::Options.build(
  #                                          :time_to_live=> 86400,
  #                                          :apns_production=> PRODUCT)
  #
  #   )
  #
  #   self.category = JPUSH
  #
  #   save
  #   @result = @client.sendPush(payload)
  #   self
  # end

  def success?
      if self.message_type =~ /^push.*/
        !PRODUCT ? true : @result.isok
      else
        resp = @result && @result.alibaba_aliqin_fc_sms_num_send_response
        !PRODUCT ? true : resp && resp.result && resp.result.success
    end
  end

end
