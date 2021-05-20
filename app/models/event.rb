require 'date_validator'
class Event < ApplicationRecord

  validates :start_date, presence: true #date: { after: { Date.today } }
  validates :duration, presence: true #:modulo_five
  validates :title, presence: true, length: { in: 5..140 }
  validates :description, presence: true, length: { in: 20..1000 }
  validates :price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000}
  validates :location, presence: true  
  
  has_many :attendances
  has_many :guests, through: :attendances
  belongs_to :admin, class_name: "User"

  ###############################################################

  private

  def modulo_five
    errors.add("Doit être un multiple de 5.") unless :duration % 5 == 0 
  end

end
