class Banner < ActiveRecord::Base
  has_one :attachment, as: :parent, dependent: :destroy, class_name: 'Attachment'
end