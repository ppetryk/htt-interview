# Represents a lift station for water/wastewater utilities. Consist of:
# - pump
# - a tank
# - a lead float (at fixed height in tank)
# - an off float (at fixed height in tank)
class LiftStation < ApplicationRecord
  include MathCalc
  belongs_to :pump, class_name: 'Pump'

  def total_tank_volume
    cylinder_volume(height, radius)
  end

  def lead_to_off_volume
    cylinder_volume(lead_to_floor - off_to_floor, radius)
  end
end
