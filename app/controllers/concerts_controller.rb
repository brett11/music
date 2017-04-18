class ConcertsController < ApplicationController


  def show
    @concert = Concert.find(params[:id])
  end

  def index
    @concerts = Concert.paginate(page: params[:page]).where('dateAndTime > ?', DateTime.now).order("dateAndTime ASC")
  end

end
