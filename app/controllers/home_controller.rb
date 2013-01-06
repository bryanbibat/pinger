class HomeController < ApplicationController
  def index
    @websites = Website.all
  end

  def cron
    Website.check_all
    render text: "OK"
  end
end
