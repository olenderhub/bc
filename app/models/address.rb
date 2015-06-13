class Address < ActiveRecord::Base
  has_one :parking
  validates :city, presence: true
  validates :street, presence: true
  validates :zip_code, presence: true, :format => { :with => /\d{2}-\d{3}/ }
end
