class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def omniauth
    data = auth_data(env)

    # User from db with provider omniauth -> Just sign him in
    if user = Authentication.find_by(provider: data[:provider], uid: data[:uid]).try(:user)
      user.update(last_sign_in_via: data[:provider])
      sign_in_and_redirect user, event: :authentication

    # User from db by email -> create authentication with data from this provider
    elsif user = User.find_by(email: data[:email])
      user.authentications.create(provider: data[:provider], uid: data[:uid], url: data[:url], token: data[:token])
      user.merge_account!(data)
      user.update(last_sign_in_via: data[:provider])
      sign_in_and_redirect user, event: :authentication

    # New user
    else
      first_name, last_name =
        if data[:last_name].blank?
          data[:first_name].split(' ')
        else
          [
            data[:first_name],
            data[:last_name],
          ]
        end

      @user = User.new(
        first_name: first_name,
        last_name: last_name,
        email: data[:email],
        avatar: data[:avatar],
        password: Devise.friendly_token[0,20],
        last_sign_in_via: data[:provider]
      )

      if data[:provider] == 'twitter' || @user.email.blank?
        session['devise.omniauth_data'] = data
        flash.now[:notice] = t('notifications.notices.enter_email')

        render 'users/registrations/twitter_email'

      elsif @user.save
        @user.authentications.create(provider: data[:provider], uid: data[:uid], url: data[:url], token: data[:token])
        sign_in_and_redirect @user, event: :authentication

      else
        session['devise.omniauth_data'] = data
        flash.now[:alert] = t('notifications.alerts.check_data')

        render 'users/registrations/new'
      end
    end

  end

  User.omniauth_providers.each do |provider|
    alias_method provider, :omniauth
  end

  # Twitter registration
  def twitter_create
    data = session['devise.omniauth_data'].with_indifferent_access
    data['email'] = params.require(:user).permit(:email)[:email]

    first_name, last_name =
      if data[:last_name].blank?
        data[:first_name].split(' ')
      else
        [
          data[:first_name],
          data[:last_name],
        ]
      end

    @user = User.new(
      first_name:       first_name,
      last_name:        last_name,
      email:            data['email'],
      avatar:           data['avatar'],
      password:         Devise.friendly_token[0, 20],
      last_sign_in_via: data['provider']
    )

    if @user.save
      @user.authentications.create(provider: data['provider'], uid: data['uid'], url: data['url'], token: data['token'])
      sign_in_and_redirect @user, event: :authentication

    else
      render 'users/registrations/twitter_email'
    end
  end


  private

  def auth_data(env)
    auth = env['omniauth.auth']

    {
      provider:   auth.provider.to_s,
      uid:        auth.uid.to_s,
      email:      auth.info.email.to_s,
      first_name: (auth.info.first_name || auth.info.name).to_s,
      last_name:  (auth.info.last_name || auth.info.nickname).to_s,
      avatar:     HTTParty.get(auth.info.image.to_s).request.last_uri.to_s, # Facebook gives picture with unsafe redirect
      gender:     auth.extra.raw_info.gender.to_s,
      locale:     auth.extra.raw_info.locale.try(:to_s) == 'ru_RU' ? 'ru' : (auth.extra.raw_info.lang.try(:to_s) == 'ru' ? 'ru' : 'en'),
      token:      auth.credentials.token.to_s,
      url:        auth.info.urls.try { |hash| hash[auth.provider.match(/\A[a-z]*/).to_s.classify].to_s }
    }
  end
end
