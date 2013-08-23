module Gamework
  class Drawable
    # Represents objects within a scene
    # that need to respond to update and
    # draw on each frame.

    attr_reader :x, :y, :z, :height, :width, :fixed

    def draw; end
    def update; end

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

      x = ((@x - @width/2).to_i..(@x + @width/2.to_i)).to_a
      y = ((@y - @height/2).to_i..(@y + @height/2).to_i).to_a
      [x,y]
    end

    def touch?(object)
      # Compares the boundaries of two objects
      # and returns true if any overlap.

      hitbox_1, hitbox_2 = hitbox, object.hitbox
      common_x = hitbox_1[0] & hitbox_2[0]
      common_y = hitbox_1[1] & hitbox_2[1]
      common_x.any? && common_y.any?
    end
  end
end