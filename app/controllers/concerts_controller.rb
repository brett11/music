class ConcertsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]

  def show
    @concert = Concert.find(params[:id])
  end

  def index
    @concerts = Concert.paginate(page: params[:page]).where('dateandtime > ?', DateTime.now).order("dateandtime ASC")
    store_location
  end

end
