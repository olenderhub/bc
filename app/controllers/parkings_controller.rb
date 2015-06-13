class ParkingsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :car_not_found

  def index
      @parkings = Parking.search(params).paginate(:page => params[:page], :per_page => 4)
  end

  def show
    @parking = Parking.find(params[:id])
  end

  def new
    @parking = Parking.new
    @parking.build_address
  end

  def create
    @parking = Parking.new(parking_params)
    if @parking.save
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @parking = Parking.find(params[:id])
  end

  def update
    @parking = Parking.find(params[:id])
    if @parking.update(parking_params)
      redirect_to @parking
    else
      render 'edit'
    end
  end

  def destroy
    @parking = Parking.find(params[:id])
    @parking.destroy
    redirect_to parkings_path
  end

  private

  def parking_params
    params.require(:parking).permit(:places, :kind, :hour_price, :day_price, address_attributes: [:city, :street, :zip_code])
  end

  def car_not_found
    flash[:alert] = t(:car_not_found, scope: ['activerecord.parking'])
    redirect_to parkings_path
  end
end

