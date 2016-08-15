module Api
  class AccountsController < Api::BaseController

    before_filter :login_required,except: [:login, :signup,:generate_phone_code,:need_captcha]


    def avatar
      @up = upload params[:user][:filename]
      @user = current_user
      if @up.present?
        @user.update(resource:@up)
      end
      render 'user'
    end

    def info
      @user = current_user
      if request.post?
        @user.update_attributes(safe_params)
        if @user.save
          render "user"
        else
          render_json_error_message(e_msg(@user))
        end
      else
        render "user"
      end
    end

    def modify_pwd
      @user = current_user
      case params[:category]
        when "0"
          if @user.password != User.password_hash(params[:current_password])
            return render_json_error_message("当前密码错误")
          end
          if @user.update_password(params[:password])
            render 'user'
          end
        when "1"
          if @user.verify_password != User.password_hash(params[:current_password])
            return render_json_error_message("当前密码错误")
          end
          if @user.update_verify_password(params[:password])
            render 'user'
          end
      end
    end

    def need_captcha
      times = session[:times]||0
      render_json_success_message(3 > times ? 0 : 1)
    end

    def login

      if params[:j_captcha] && !captcha_valid?(params[:j_captcha])
        return render_json_error_message("无效验证吗")
      end

      self.current_user = User.customer.authenticate(params[:login], params[:password])
      if logged_in?
        successful_login
        render 'user'
      else
        @login = params[:login]
        session[:times] ||= 0
        session[:times] += 1
        return render_json_error_message("用户名或密码错误!") #t('accounts.login.error'))
      end
    end

    def signup

      if params[:j_captcha] && !captcha_valid?(params[:j_captcha])
        return render_json_error_message("无效图形验证吗")
      end

      if ! params[:code].eql?(session[:code])
        return render_json_error_message("无效短信验证吗")
      end

      @user = User.new(safe_params)
      @user.profiles << Profile.customer

      @user.name = @user.login
      if @user.save
        self.current_user = @user
        session[:user_id] = @user.id
        render 'user'
      else
        render_json_error_message(e_msg(@user))
      end
    end

    def generate_phone_code

      session[:code] = code = "#{rand(9999)}".rjust(4,'0')
      phone = ''
      if request.post?
        if params[:phone] && params[:phone] =~  /^0{0,1}(13[0-9]|15[7-9]|153|156|18[7-9])[0-9]{8}$/
          phone = params[:phone]
        else
          render_json_error_message("请输入正确的手机号码")
        end
      else
        return if ! login_required
        phone = current_user.phone
      end
      result = Message.new({content:"验证码: #{code}",phone:phone}).send_sms_code("#{code}")

      if result.success?
        render_json_success_message("发送成功")
      else
        render_json_error_message("发送出错")
      end

    end

    def recover_password

      if "#{params[:code]}" != "#{session[:code]}"
        return render_json_error_message("无效验证吗")
      end

      @user = User.default.find_by_phone(params[:phone])

      return render_json_error_message("此用户不存在") if @user.nil?

      return render_json_error_message("两次输入密码不一致") if params[:password] !=params[:confirm]

      if @user.update_password(params[:password])
        render 'user'
      else
        render_json_error_message(e_msg(@user))
      end
    end

    def logout
      flash[:notice] = t('accounts.logout.notice')
      current_user.forget_me
      self.current_user = nil
      session[:user_id] = nil
      cookies.delete :auth_token
      cookies.delete :publify_user_profile
      render_json_success_message("删除成功")
    end

    # private
    #
    # def verify_users
    #   redirect_to(controller: 'accounts', action: 'signup') if User.count == 0
    #   true
    # end
    #
    # def verify_config
    #   redirect_to controller: 'setup', action: 'index' unless this_blog.configured?
    # end
    #
    # def redirect_if_already_logged_in
    #   if session[:user_id] && session[:user_id] == current_user.id
    #     redirect_back_or_default
    #   end
    # end

    def successful_login

      session[:user_id] = current_user.id
      @user = current_user
      if params[:remember_me] == '1'
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = {
            value: current_user.remember_token,
            expires: current_user.remember_token_expires_at,
            httponly: true # Help prevent auth_token theft.
        }
      end
      # add_to_cookies(:publify_user_profile, current_user.profile_label, '/')

      current_user.update_connection_time
      # flash[:success] = t('accounts.login.success')
      # redirect_back_or_default
    end

    def redirect_back_or_default
      redirect_to(session[:return_to] || url_for({ controller: 'dashboard', action: 'index' }))
      session[:return_to] = nil
    end


    def safe_params

      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:user].permit(:login,:password,:email,:name,:sex,:phone,:birthday,:location,:company,:slogan,:job,attachments: [ image: file_params ]
      )

    end

    # def upload
    #   # if !params[:adv].blank?
    #   file = params[:user][:filename]
    #   if file
    #     mime = if file.content_type
    #              file.content_type.chomp
    #            else
    #              'text/plain'
    #            end
    #     flash[:success] = I18n.t('admin.resources.upload.success')
    #     @up = Resource.create(upload: file, mime: mime, created_at: Time.now)
    #   else
    #     nil
    #   end
    #
    #   # return @up
    #   # else
    #   #   flash[:warning] = I18n.t('admin.resources.upload.warning')
    #   # end
    # end
  end
end
