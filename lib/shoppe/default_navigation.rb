require 'shoppe/navigation_manager'

# This file defines all the default navigation managers used in Shoppe. Of course,
# modules can make changes to these by removing them or adding their own. This
# file is loaded on application initialization so if you make changes, you'll need
# to restart the webserver.

#
# This is the default navigation manager for the admin interface.
#
Shoppe::NavigationManager.build(:admin_primary) do
  # add_item :customers,{namespace: :admin}
  # add_item :orders,{namespace: :admin}
  # add_item :products,{namespace: :admin}
  # add_item :product_categories,{namespace: :admin}
  # add_item :delivery_services,{namespace: :admin}
  # add_item :tax_rates,{namespace: :admin}
  add_item :users,{namespace: :admin}
  # add_item :countries,{namespace: :admin}
  add_item :settings,{namespace: :admin}
end

Shoppe::NavigationManager.build(:seller_primary) do
  # add_item :customers,{namespace: :seller}
  add_item :orders,{namespace: :seller}
  add_item :products,{namespace: :seller}
  add_item :product_categories,{namespace: :seller}
  add_item :delivery_services,{namespace: :seller}
  add_item :tax_rates,{namespace: :seller}
  # add_item :users,{namespace: :seller}
  add_item :countries,{namespace: :seller}
  add_item :settings,{namespace: :seller}
end
