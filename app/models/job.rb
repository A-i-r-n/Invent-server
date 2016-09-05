class Job < Campaign

  belongs_to :vendor
  belongs_to :category

  scope :active,->{
    where(status: 'active')
  }

end
