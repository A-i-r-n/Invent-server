module Seller
  class SettingsController < Seller::BaseController
    before_filter { @active_nav = :settings }

    def update
      if Shoppe.settings.demo_mode?
        fail Shoppe::Error, t('shoppe.settings.demo_mode_error')
      end

      Setting.update_from_hash(params[:settings].permit!)
      redirect_to [:seller,:settings], notice: t('shoppe.settings.update_notice')
    end
  end
end