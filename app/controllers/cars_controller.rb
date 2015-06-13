class CarsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :car_not_found
  before_action :login_required

  def index
    @cars = current_person.cars.all
  end

  def show
    @car = current_person.cars.find(params[:id])
    @current_photo = Photo.all.find_by(id: @car.photo_id)
  end

  def new
    @car = current_person.cars.build
    @photo = Photo.new
  end

  def create
    @car = current_person.cars.build(car_params)
    if @car.save
      redirect_to cars_path
    else
      render 'new'
    end
  end

  def edit
    @car = current_person.cars.find(params[:id])
    @current_photo = Photo.all.find_by(id: @car.photo_id)
  end

  def update
    @car = current_person.cars.find(params[:id])
    if @car.update(car_params)
      redirect_to @car
    else
      render 'edit'
    end
  end

  def destroy
    @car = current_person.cars.find(params[:id])
    @car.destroy
    redirect_to cars_path
  end

  private

    def car_params
      params.require(:car).permit(:model, :registration_number, :owner_id, photo_attributes: [:image])
    end

    def car_not_found
      flash[:alert] = "That car does not exist"
      redirect_to cars_path
    end
end
