class Fund < ActiveRecord::Base
  belongs_to :user

  def recharge(money)
    update_attribute(:avail,avail+money)
  end

end
