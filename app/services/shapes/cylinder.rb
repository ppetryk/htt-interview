module Shapes
  # Math manipulations on cylinder based on passed height and radius
  class Cylinder
    def initialize(radius, height)
      @radius = radius
      @height = height
    end

    def volume
      Math::PI * @radius**2 * @height
    end
  end
end
