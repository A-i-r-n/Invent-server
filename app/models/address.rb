class Address < ActiveRecord::Base

    # An array of all the available types for an address
    TYPES = %w(billing delivery).freeze

    # Set the table name
    # self.table_name = 'shoppe_addresses'

    # The customer which this address should be linked to
    #
    # @return [Shoppe::Customer]
    belongs_to :customer, class_name: 'Customer'

    # The order which this address should be linked to
    #
    # @return [Shoppe::Order]
    belongs_to :order, class_name: 'Order'

    # The country which this address should be linked to
    #
    # @return [Shoppe::Country]
    belongs_to :country, class_name: 'Country'

    # Validations
    validates :address_type, presence: true, inclusion: { in: TYPES }
    validates :address1, presence: true
    validates :address3, presence: true
    validates :address4, presence: true
    validates :postcode, presence: true
    validates :country, presence: true
    validates :area_id, presence: true

    # All addresses ordered by their id asending
    scope :ordered, -> { order(id: :desc) }
    scope :default, -> { where(default: true) }
    scope :billing, -> { where(address_type: 'billing') }
    scope :delivery, -> { where(address_type: 'delivery') }

    attr_accessor :pid,:cid,:sid

    before_validation do
        self.area_id = ([pid, cid, sid] - [nil,""]).last
    end

    after_find :set_area_id

    def set_area_id
        area = self.area_id ?  Area.find(self.area_id) : nil
        i = 0
        p = area
        arr = []
        while i < 3
            break if p.nil?
            arr << p.id
            p = p.parent
            i+=1
        end
        arr =  arr.reverse
        (3 - arr.count).times { arr << nil if arr.count < 3 }
        self.pid,self.cid,self.sid = arr
    end

    def province
        @p ||= Area.find(self.pid)
    end

    def city
        @c ||= Area.find(self.cid)
    end

    def street
        @s ||= Area.find(self.sid)
    end


    def full_name
        areas = Area.where(id:[self.pid, self.cid,self.sid])
        str = ''
        areas.each do |area|
            str << "#{area.name} "
        end
        str
    end

    def full_address
        [address1, address2, address3, address4, postcode, country.try(:name)].join(', ')
    end
end
