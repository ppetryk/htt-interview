module MathCalc
  extend ActiveSupport::Concern

  def cylinder_volume(height, radius)
    Math::PI * radius**2 * height
  end
end
