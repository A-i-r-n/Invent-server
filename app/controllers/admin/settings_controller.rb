module Admin
  class SettingsController < Admin::BaseController
    before_filter { @active_nav = :settings }

    def update
      if Shoppe.settings.demo_mode?
        fail Shoppe::Error, t('shoppe.settings.demo_mode_error')
      end

      Setting.update_from_hash(params[:settings].permit!)
      redirect_to [:admin,:settings], notice: t('shoppe.settings.update_notice')
    end
  end
end