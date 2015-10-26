class DashboardController < RestrictedController
  def index
    @articles = current_user.articles
  end

  def profile; end
end
