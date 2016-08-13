class UserProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :profile, class_name: 'Profile'

  validates_presence_of :user, :profile
end
