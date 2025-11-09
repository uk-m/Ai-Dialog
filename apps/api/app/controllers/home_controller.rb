class HomeController < ApplicationController
  def index
    @version = ENV.fetch("GIT_SHA", "dev")
  end
end
