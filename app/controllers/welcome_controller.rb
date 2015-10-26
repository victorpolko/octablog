class WelcomeController < ApplicationController
  def index
    session[:locale] ||=
      if request.env['HTTP_ACCEPT_LANGUAGE'].try { |lang| lang.downcase.include?('ru') }
        'ru'
      else
        I18n.default_locale
      end

    @search = Article.search(params[:q])
    @articles = @search.result.order(rating: :desc).limit(10)

    respond_to do |format|
      format.html do
        gon.articles = @articles
      end

      format.json
    end
  end

  def feedback
    flash[:notice] = I18n.t('notifications.notices.feedback_sent')
    redirect_to session[:last_get_position]
  end

  def change_locale
    locale = params[:locale]
    session[:locale] = locale

    I18n.locale = locale

    redirect_to session[:last_get_position]
  end
end
