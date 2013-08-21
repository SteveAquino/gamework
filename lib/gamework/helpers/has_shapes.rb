module Gamework
  module HasShapes
    # Creates a simple interface for creating
    # shapes

    def draw_shapes
      @shapes.all {|s| s.draw}
    end

    def draw_triangle(options)
      shape = Shape.new(:triangle, options)
      @shapes << shape
    end

  end
end