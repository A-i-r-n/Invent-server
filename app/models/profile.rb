class Profile < ActiveRecord::Base


  serialize :modules

  validates :label, uniqueness: true

  ADMIN = 'admin'
  PUBLISHER = 'publisher'
  CONTRIBUTOR = 'contributor'

  has_many :user_profiles, dependent: :restrict_with_exception, class_name: 'UserProfile', inverse_of: :profile
  has_many :users, class_name: 'User', through: :user_profiles

  # def modules
  #   self[:modules] || []
  # end
  #
  # def modules=(perms)
  #   perms = perms.map { |p| p.to_sym unless p.blank? }.compact if perms
  #   self[:modules] = perms
  # end
  #
  # def project_modules
  #   modules.map do |mod|
  #     AccessControl.project_module(label, mod)
  #   end.uniq.compact
  # end
end
