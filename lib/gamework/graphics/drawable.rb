module Gamework
  class Drawable
    # Represents objects within a scene
    # that need to respond to update and
    # draw on each frame.

    attr_reader :x, :y, :z, :height, :width, :fixed

    def draw; end
    def update; end

    def set_position(x, y)
      @x, @y = x, y
    end
    
    def pos?(x, y)
      [@x, @y] == [x, y]
    end

    def resize(width, height)
      @width, @height = width, height
    end

    def fix
      @fixed = true
    end

    def unfix
      @fixed = false
    end

    def fixed?
      # If this method returns true, the
      # object will be drawn fixed on the
      # screen and move with the camera.
      # The default is to scroll with the
      # map as the camera moves.

      !!@fixed
    end

    def hitbox
      # Returns a nested array of coordinates
      # that corosponds to the boundaries of
      # an object based on its position and
      # size.

      x1 = (@x - @width/2).to_i
      x2 = (@x + @width/2).to_i
      y1 = (@y - @height/2).to_i
      y2 = (@y + @height/2).to_i

      x_coords = (x1..x2).to_a
      y_coords = (y1..y2).to_a
      [x_coords, y_coords]
    end

    def touch?(object, offset_x=0, offset_y=0)
      # Compares the boundaries of two objects
      # and returns true if any overlap.
      # Optionally allows offsetting of the
      # reference object (self).

      hitbox_1, hitbox_2 = hitbox, object.hitbox
      hitbox_1[0] = hitbox_1[0].map {|i| i+offset_x}
      hitbox_1[1] = hitbox_1[1].map {|i| i+offset_y}
      common_x = hitbox_1[0] & hitbox_2[0]
      common_y = hitbox_1[1] & hitbox_2[1]
      common_x.any? && common_y.any?
    end

    private

    def set_options(options, writer=false)
      # Creates instance variables and
      # reader methods from a hash.

      attr_method = writer ? :attr_accessor : :attr_reader
      options.each do |key, value|
        self.class.send attr_method, key
        instance_variable_set "@#{key}", value
      end
    end
  end
end