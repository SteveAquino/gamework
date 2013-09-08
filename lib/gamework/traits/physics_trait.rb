module Gamework
  module PhysicsTrait
    # Provides basic 2 dimensional physics
    # with simple velocity and mass
    # equations

    def initialize_physics
      @vel_x ||= 0
      @vel_y ||= 0
      @speed ||= 0.5
      @mass  ||= 5
    end
  
    def update_physics
      # Moves as an object in
      # 'space' at a given velocity

      @x += @vel_x
      @y += @vel_y
      
      @vel_x *= drag
      @vel_y *= drag
    end

    def drag
      # Amount that velocity is
      # multiplied by on each
      # update to slow an object

      1 - (@mass/100.0)
    end

    def rotate(degrees)
      # Increase the angle by
      # a given degree

      @angle += degrees
    end

    def set_angle(degrees)
      # Set the angle explicitly

      @angle = degrees
    end
  
    def accelerate
      # Accelerates in two dimensions at
      # @speed/px per frame

      @vel_x += Gosu::offset_x(@angle, @speed)
      @vel_y += Gosu::offset_y(@angle, @speed)
    end
  
    def decelerate
      # Same as accelerate only reduces velocity
      # instead of increasing it

      @vel_x += Gosu::offset_x(@angle, -@speed)/2
      @vel_y += Gosu::offset_y(@angle, -@speed)/2
    end
  end
end