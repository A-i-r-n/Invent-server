  class Payment < ActiveRecord::Base
    # Additional callbacks
    extend ActiveModel::Callbacks
    define_model_callbacks :refund

    belongs_to :item, polymorphic: true

    # The associated order
    #
    # @return [Shoppe::Order]
    # belongs_to :order, class_name: 'Order'

    # An associated payment (only applies to refunds)
    #
    # @return [Shoppe::Payment]
    belongs_to :parent, class_name: 'Payment', foreign_key: 'parent_payment_id'

    # Validations
    validates :amount, numericality: true
    validates :reference, presence: true, allow_blank: true
    validates :method, presence: true,  allow_blank: true

    # Payments can have associated properties
    key_value_store :properties

    # Callbacks
    after_create :cache_amount_paid
    after_destroy :cache_amount_paid
    after_update  :cache_amount_paid
    before_destroy { parent.update_attribute(:amount_refunded, parent.amount_refunded + amount) if parent }

    # Is this payment a refund?
    #
    # @return [Boolean]
    def refund?
      amount < BigDecimal(0)
    end

    # Has this payment had any refunds taken from it?
    #
    # @return [Boolean]
    def refunded?
      amount_refunded > BigDecimal(0)
    end

    # How much of the payment can be refunded
    #
    # @return [BigDecimal]
    def refundable_amount
      refundable? ? (amount - amount_refunded) : BigDecimal(0)
    end

    # Process a refund from this payment.
    #
    # @param amount [String] the amount which should be refunded
    # @return [Boolean]
    def refund!(amount)
      run_callbacks :refund do
        amount = BigDecimal(amount)
        if refundable_amount >= amount
          transaction do
            self.class.create(parent: self, order_id: order_id, amount: 0 - amount, method: method, reference: reference)
            update_attribute(:amount_refunded, amount_refunded + amount)
            true
          end
        else
          fail Shoppe::Errors::RefundFailed, message: I18n.t('.refund_failed', refundable_amount: refundable_amount)
        end
      end
    end

    # Return a transaction URL for viewing further information about this
    # payment.
    #
    # @return [String]
    def transaction_url
      nil
    end

    def amount_paid
      update_attributes(amount: amount.abs)
    end

    private

    def cache_amount_paid
      if amount > 0 && ! confirmed
        case item
          when Fund
            item.recharge(amount)
          else # Order || LotteryOrder
            # item.update_attribute(:amount_paid, item.becomes(LotteryOrder).payments.sum(:amount))
          item.update_attribute(:amount_paid, Payment.where(item_type: item.class,item_id: item.id).sum(:amount)) #item.payments.sum(:amount)
        end
        update_attribute(:confirmed, true)
      end
    end
  end
