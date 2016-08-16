module Api
  class PaymentsController < Api::BaseController
    # before_filter { @order = Order.find(params[:order_id]) }
    before_filter { params[:id] && @payment = Payment.find(params[:id]) }

    def create
      @payments = []
      @payment_messages = []
      Payment.transaction do
        safe_params[:items].map{ |key,payment_safe_params|
          payment_params = payment_safe_params[:payment]
          payment = Payment.new(payment_params)
          if ! payment.save
            @payment_messages << payment.errors.full_messages.to_sentence
          end
          @payments << payment
        }
      end

      if ! @payment_messages.empty?
        render_json_error_message(@payment_messages.to_sentence)
      else
        render 'payments'
      end
    end

    def destroy
      @payment.destroy
      render_json_success_message(t('shoppe.payments.destroy_notice'))
    end

    def secure_pay
      resp = JSON.parse(request.body.read)
      result = resp['result_pay']
      Payment.where(no: resp['no_order']).amount_paid if result.downcase == 'SUCCESS'.downcase
      render json:{ret_code: "0000",ret_msg:"交易成功"}
    end

    def refund
      if request.post?
        @payment.refund!(params[:amount])
        redirect_to [:admin,@order], flash: { notice: t('shoppe.payments.refund_notice') }
      else
        render layout: false
      end
    rescue Shoppe::Errors::RefundFailed => e
      render_json_error_message(e.message)
    end

    private
    def safe_params
      params[:payments].permit(
          items: [
              payment: [
                  :amount, :method, :reference, :item_id,:item_type, :no
              ]
          ]
      )
    end
  end
end
