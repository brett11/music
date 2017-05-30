class StaticPagesController < ApplicationController
  layout 'static_pages', only: [:home]
  layout 'application', only: [:help, :about]

  def home
  end

  def help
  end

  def about
  end
end
