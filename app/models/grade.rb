class Grade < ActiveRecord::Base
  belongs_to :user
  belongs_to :order

  before_create :change_status

  before_create :grade_for_vendor

  def change_status
    order.update_attribute(:status, 'judged')
  end

  def grade_for_vendor
    order.vendor.try(:judge_for,self)
  end

end
