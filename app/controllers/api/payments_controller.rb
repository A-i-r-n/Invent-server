module Api
  class PaymentsController < Api::BaseController
    # before_filter { @order = Order.find(params[:order_id]) }
    before_filter { params[:id] && @payment = Payment.find(params[:id]) }

    def create
      @orders = []
      @order_messages = []
      Payment.transaction do
        safe_params[:items].map{ |key,payment_safe_params|
          payment_params = payment_safe_params[:payment]
          payment = Payment.new(payment_params)
          if ! payment.save
            @order_messages << payment.errors.full_messages.to_sentence
          end
          @orders << payment
        }
      end
      if ! @order_messages.empty?
        render_json_error_message(@order_messages.to_sentence)
      else
        render 'payments'
      end
    end

    def destroy
      @payment.destroy
      render_json_success_message(t('shoppe.payments.destroy_notice'))
    end

    def secure_pay
      case params[:method]
        when 'pay'
          resp = JSON.parse(request.body.read)
          result = resp['result_pay']
          puts "#{resp.inspect}-------------"
          if result.downcase == 'SUCCESS'.downcase
            Payment.where(no: resp['no_order']).amount_paid
          end
        when 'recharge'
      end
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

    def safe_params
      params[:payments].permit(
          items: [
              payment: [
                  :amount, :method, :reference, :order_id, :no
              ]
          ]
      )
    end
  end
end
