class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :set_locale

  private

  def set_locale
    I18n.locale = :ja
  end
end
