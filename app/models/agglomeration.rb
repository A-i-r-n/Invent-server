class Agglomeration < Campaign

  belongs_to :vendor
  belongs_to :product_category,foreign_key: 'category_id'

  scope :active,->{
    where(status: 'active')
  }

  after_create :new_role

  def new_role
    if ! vendor.role.include?('agglomeration')
      vendor.role << 'agglomeration'
      vendor.save
    end
  end

  def unactive?
    self.participants += 1
    if self.participants >= self.max_participants #团购完成
      self.status = 'active'
    end
    save
  end
end
