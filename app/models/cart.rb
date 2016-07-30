class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  def product_vendor
    self.product.product_vendor
  end
end
