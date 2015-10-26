class Users::ProfileController < RestrictedController
  before_action :fetch_profile

  def edit
  end

  def update
    if @profile.update(profile_params)
      flash[:notice] = 'Profile was successfully updated.'
      redirect_to profile_path
    else
      render 'dashboard/profile'
    end
  end

  def update_password
    if @profile.update_with_password(password_update_params)
      sign_out @profile
      sign_in :user, @profile

      flash[:notice] = 'Password changed.'
      redirect_to profile_path
    else
      if params[:profile][:password].blank?
        @profile.errors[:password] << I18n.t('activerecord.errors.messages.empty')
      else
        @profile.password = params[:profile][:password]
      end

      render 'dashboard/profile'
    end
  end


  # JSON
  # Update avatar without page reloading
  # @return [JSON] New avatar url
  def update_avatar
    respond_to do |format|
      format.js do
        begin
          @profile.avatar = params.require(:profile).permit(:avatar)[:avatar]

          if @profile.save
            render json: { url: @profile.avatar.url(:medium) }
          else
            render json: { klass: t('activerecord.attributes.user.avatar'), error: @profile.errors.messages }, status: 422
          end

        rescue Paperclip::AdapterRegistry::NoHandlerError
          render json: { }, status: 422
        end
      end
    end
  end

  private

  def fetch_profile
    @profile = User.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :email)
  end

  def password_update_params
    params.require(:profile).permit(:password, :current_password, :password_confirmation)
  end
end
