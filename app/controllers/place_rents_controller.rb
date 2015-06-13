class PlaceRentsController < ApplicationController
  before_action :login_required

  def index
    @place_rents = current_person.place_rents.sort_by(&:starts_at)
  end

  def show
    @place_rents = current_person.place_rents.find_by_identifier(params[:id])
  end

  def new
    @place_rent = PlaceRent.new
    @cars = current_person.cars
    @parking = Parking.find(params[:parking_id])
  end

  def create
    @place_rents = Parking.find(params[:parking_id]).place_rents.build(placerents_params)
    if @place_rents.save
      redirect_to place_rents_path
    else
      render 'new'
    end
  end

  private

    def placerents_params
      params.require(:place_rent).permit(:starts_at, :ends_at, :car_id)
    end
end

