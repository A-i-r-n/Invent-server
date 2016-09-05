class Agglomeration < Campaign

  belongs_to :vendor
  belongs_to :product_category,foreign_key: 'category_id'

  scope :active,->{
    where(status: 'active')
  }

  def unactive?
    self.participants += 1
    if self.participants >= self.max_participants #团购完成
      self.status = 'active'
    end
    save
  end
end
