  # The Shoppe::Country model stores countries which can be used for delivery & billing
  # addresses for orders.
  #
  # You can use the Shoppe::CountryImporter to import a pre-defined list of countries
  # into your database. This automatically happens when you run the 'shoppe:setup'
  # rake task.
  require 'awesome_nested_set'

  class Area < ActiveRecord::Base

    acts_as_nested_set  dependent: :restrict_with_exception
    # ,after_move: :set_ancestral_permalink
    # # self.table_name = 'shoppe_countries'
    #
    # # All orders which have this country set as their billing country
    # has_many :billed_orders, dependent: :restrict_with_exception, class_name: 'Order', foreign_key: 'billing_country_id'
    #
    # # All orders which have this country set as their delivery country
    # has_many :delivered_orders, dependent: :restrict_with_exception, class_name: 'Order', foreign_key: 'delivery_country_id'
    #
    # # All countries ordered by their name asending
    # scope :ordered, -> { order(name: :asc) }

    belongs_to :parent, class_name: "Area",foreign_key: "parent_id"

    # Validations
    validates :name, presence: true

    scope :root,->{
      where(parent_id: nil)
    }

    scope :children,->(pid){
      case
        when pid
          where(parent_id: pid)
        else
          []
      end
    }


  end
