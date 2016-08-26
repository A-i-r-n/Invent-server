class Grade < ActiveRecord::Base
  belongs_to :user

  belongs_to :item, polymorphic: true

  with_options if: proc{|o| o.parent_id.blank? } do |g|
    g.after_save :change_status
    g.after_save :grade_for
  end

  def change_status
    item.update_attribute(:status, 'judged')
  end

  def grade_for
    item.vendor.try(:judge_for,self)
    item.products.map{|p| p.try(:judge_for,self) }
  end

end
