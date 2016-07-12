module Api
  class AccountsController < Api::BaseController

    def avatar
      @up = upload params[:user][:filename]
      @user = current_user
      if @up.present?
        @user.update(resource:@up)
      end
      respond_to do |format|
        format.json {render "user"}
      end
    end
    def info
      @user = current_user
      respond_to do |format|
        format.json {render "user"}
      end
    end

    def update_info
      @user = current_user
      @user.update_attributes(params.require(:user).permit!)

      respond_to do |format|
        if @user.save
          format.json { render "user" }
        else
          format.json { render json:{code:-1,msg:{error:"#{@user.errors.full_message[0]}"}}}
        end
      end
    end

    def modify_pwd
      case params[:category]
        when "0"
          if current_user.password != User.password_hash(params[:current_password])
            return(render json:{code: 1,msg:{errors:"当前密码错误"}})
          end
          if current_user.update_password(params[:password])
            respond_to do |format|
              format.json {render json:{code:0,data:"更新成功"}}
            end
          end
        when "1"
          if current_user.verify_password != User.password_hash(params[:current_password])
            return(render json:{code: 1,msg:{errors:"当前密码错误"}})
          end
          if current_user.update_verify_password(params[:password])
            respond_to do |format|
              format.json {render json:{code:0,data:"更新成功"}}
            end
          end
      end
    end

    def captcha
      render json:{code: 0,data: 3 > session[:times]||0 ? 0 : 1}
    end

    def login
      if params[:j_captcha]
        if !captcha_valid? params[:j_captcha]
          return(render json: { :code=>1,msg:{error:"无效验证吗"}})
        end
      end

      self.current_user = User.customer.authenticate(params[:login], params[:password])
      if logged_in?
        successful_login
        respond_to do |format|
          format.json { render 'user' }
        end
      else
        @login = params[:login]
        session[:times] ||= 0
        session[:times] += 1
        return(render json: {:code=>1,msg:{error:"用户名或密码错误!"}}) #t('accounts.login.error'))
      end
    end

    def signup

      if params[:j_captcha]
        if !captcha_valid? params[:j_captcha]
          return(render json: { :code=>1,msg:{error:"无效验证吗"}})
        end
      end

      if "#{params[:code]}" != "#{session[:code]}"
        return(render json: { :code=>1,msg:{error:"无效验证吗"}})
      end

      @user = User.new((params[:user].permit! if params[:user]))

      # @user.generate_password!
      # session[:tmppass] = @user.password
      @user.name = @user.login
      if @user.save
        self.current_user = @user
        session[:user_id] = @user.id
        respond_to do |format|
          format.json {render 'user'}
        end
      else
        render json:{code: 1, msg:{error:"#{@user.errors.full_messages[0]}"}}
      end
    end

    def generate_phone_code

      return if params[:phone].nil? && !login_required

      session[:code] = code = rand(9999)

      user = current_user||
          User.new(id:1,phone:params[:phone])

      result = Sm.new({content:"验证码: #{code}",user:user}).send_sms

      respond_to do |format|
        format.json {
          if result.success?
            render json: { code: 0,data:{msg:result} }
          else
            render json: {code: 1,msg:{errors:"发送出错"}}
          end
        }
      end
    end

    def recover_password

      if "#{params[:code]}" != "#{session[:code]}"
        return(render json: { :code=>1,msg:{error:"无效验证吗"}})
      end

      @user = User.default.find_by_phone(params[:phone])

      return(render json: {code: 1,msg:{errors:"此用户不存在"}}) if @user.nil?

      return(render json: {code: 1,msg:{errors:"两次输入密码不一致"}}) if params[:password] !=params[:confirm]

      respond_to do |format|
        if @user.update_password(params[:password])
          format.json {render 'user'}
        else
          format.json {render json:{code: 1,msg:{errors:"#{@user.errors.full_messages[0]}"}}}
        end

      end


      # return unless request.post?
      # @user = User.where('login = ? or email = ?', params[:user][:login], params[:user][:login]).first
      #
      # if @user
      #   @user.generate_password!
      #   @user.save
      #   flash[:notice] = t('accounts.recover_password.notice')
      #   redirect_to login_accounts_url
      # else
      #   flash[:error] = t('accounts.recover_password.error')
      # end
    end

    def logout
      flash[:notice] = t('accounts.logout.notice')
      current_user.forget_me
      self.current_user = nil
      session[:user_id] = nil
      cookies.delete :auth_token
      cookies.delete :publify_user_profile
      respond_to do |format|
        format.json { render json:{code: 0,data:"删除成功"} }
      end
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
      redirect_to(session[:return_to] || { controller: 'admin/dashboard', action: 'index' })
      session[:return_to] = nil
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
