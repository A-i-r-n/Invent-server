class Share < ActiveRecord::Base
    belongs_to :parent, polymorphic: true
    belongs_to :user

    # with_options if: proc {|v| v.parent_type == 'Product'} ,do
    #     belongs_to :product
    # end
    #
    # with_options if: proc {|v| v.parent_type == 'Vendor'} ,do
    #     belongs_to :vendor
    # end
end
