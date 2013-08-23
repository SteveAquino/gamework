module Gamework
  class Actor < Gamework::Drawable
    # An Actor can be thought of as the model part of
    # a Model View Controller framework.  Actors
    # represent the objects and characters that make
    # up your game, each with a sprite, animations
    # and collision detection.

    attr_reader :direction, :moving

    def initialize(spritesheet, options={})
      @spritesheet = spritesheet
      if options[:position]
        @x = options[:position][0]
        @y = options[:position][1]
      else
        @x = options[:x] || 0
        @y = options[:y] || 0
      end
      @z         = options[:z]         || 0
      @width     = options[:width]     || options[:size] || 30
      @height    = options[:height]    || options[:size] || 30
      @speed     = options[:speed]     || 3
      @direction = options[:direction] || :down
      @invisible = options[:invisible] || false
      @fixed     = options[:fixed]     || false
      @moving    = false
    end

    def update
      sprite.update
    end

    def draw
      sprite.draw if showing?
    end

    def sprite
      @sprite ||= Sprite.new(@x, @y, @width, @height, @spritesheet)
    end

    def set_position(x, y)
      @x, @y = x, y
    end
    
    def pos?(x, y)
      [@x, @y] == [x, y]
    end

    def resize(width, height)
      @width, @height = width, height
    end

    def turn(direction)
      @direction = direction
      sprite.turn direction
    end

    def step_forward
      move @direction
    end
    
    def stop
      @moving = false
      sprite.stop
    end

    def move(direction)
      turn direction unless @dir_fixed
      
      @moving = true
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
      sprite.move(direction)
    end

    def hide
      @invisible = true
    end

    def show
      @invisible = false
    end

    def showing?
      !!!@invisible
    end

    def collide?(object, direction)
      # Returns true if the actor is facing
      # the object it's touching, preventing
      # him from moving forward.

      return false if object == self
      return false unless touch?(object)
      case direction.intern
        when :up
          object.y < @y
        when :down
          object.y > @y
        when :left
          object.x < @x
        when :right
          object.x > @x
      end
    end
    
    # def move_towards(target)
    #   if target.class.ancestors.include?(GameObject)
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
  end
end