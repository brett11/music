class ConcertsController < ApplicationController


  def show
    @concert = Concert.find(params[:id])
  end

  def index
    @concerts = Concert.paginate(page: params[:page]).where('dateandtime > ?', DateTime.now).order("dateandtime ASC")
  end

end
