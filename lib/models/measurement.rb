class Measurement < ActiveRecord::Base
  validates :temperature, presence: true
  validates :humidity, presence: true
end
