# Adds basic four way directional
# movement functionality

module Gamework
  module MovementTrait
    attr_reader :movement_options

    def initialize_movement
      @speed     ||= 3
      @animated  ||= false
      @animating ||= false
      @direction ||= :down
      @solid     ||= true
      @movement_options ||= {}
    end

    def update_movement
      update_auto_movement if @movement_options[:type]
    end

    def turn(direction)
      @direction = direction
    end

    # Turn direction and move a
    # distance of @speed pixels
    def move(direction)
      turn direction unless @dir_fixed
      return(stop) if scene_collision?
      
      @moving = true
      animate
      case direction
      when :up
        @y -= @speed
      when :left
        @x -= @speed
      when :down
        @y += @speed
      when :right
        @x += @speed
      end
    end
    
    def stop
      return if @animated
      @moving = false
      freeze
    end

    def moving?
      !!@moving
    end

    def solid?
      !!@solid
    end

    # Returns a nested array containing
    # coordinates of an object's hitbox
    def hitbox(offset_x=0, offset_y=0)
      start_x  = left_x   + offset_x
      end_x    = right_x  + offset_x
      start_y  = top_y    + offset_y
      end_y    = bottom_y + offset_y
      hitbox_a = [(start_x..end_x).to_a, (start_y..end_y).to_a]
    end

    # Returns true if self is facing the
    # object it's touching, preventing
    # it from moving forward.
    def collide?(object)
      return false if object == self

      hitbox_a = case @direction
      when :down
        hitbox(0, rad_y)
      when :up
        hitbox(0, -rad_y)
      when :right
        hitbox(rad_x, 0)
      when :left
        hitbox(-rad_x, 0)
      end
      hitbox_b = object.hitbox

      # Return true if the hitboxes overlap
      (hitbox_a[0] & hitbox_b[0]).any? &&
      (hitbox_a[1] & hitbox_b[1]).any?
    end

    # Checks all objects on a scene to
    # see if there is a collision
    def scene_collision?
      return false unless solid?
      scene = Gamework::App.current_scene
      return false if scene.nil?

      scene.solid_objects.any? {|object| collide?(object)}
    end

    # Creates threads for new movements
    # to update in parallel to other
    # processes
    def update_auto_movement
      return if @movement_options[:moving]
      distance = @movement_options[:distance] || @width
      delay    = @movement_options[:delay]    || 1
      if @movement_options[:type].to_s == 'random'
        Thread.new { random_movement(distance, delay) }
      end
    end

    # Move between 0 to 2 steps in a
    # random direction with a given delay
    def random_movement(distance, delay)
      @movement_options[:moving] = true
      # Random direction
      dir = %w(up down left right)[rand(4)]
      # Move between 0 and 2 steps
      steps = rand(3)
      steps.times do
        turn(dir.intern)
        step(distance)
      end
      sleep delay
      @movement_options[:moving] = false
    end
    
    # def move_towards(target)
    #   if target.class.ancestors.include?(Gamework::Drawable)
    #     coords = [target.x, target.y]
    #   else
    #     coords = target
    #   end
      
    #   return if (@x == coords[0] && @y == coords[1])
      
    #   # check difference in x and y with self
    # end
    
    # def move_away_from(target)
    #   # should mirror move_towards(target)
    # end

    # Moves a given distance over 1
    # second based on the actor's speed
    def step(distance)
      i = 0
      t = 1/(distance.to_f/@speed.to_f)
      while i < distance
        move @direction
        sleep t
        i += @speed
      end
      stop
    end

  end
end