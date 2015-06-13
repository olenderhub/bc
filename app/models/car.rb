class Car < ActiveRecord::Base
  belongs_to :owner, class_name: "Person"
  belongs_to :photo
  has_many :place_rents

  validates :registration_number, :model, :owner, presence: true

  accepts_nested_attributes_for :photo

  def to_param
    permalink
  end

  def permalink
    "#{self.id}-#{self.model}"
  end
end
