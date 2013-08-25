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
      defaults = {
        x: 0, y: 0,
        width:  options[:size]||30,
        height: options[:size]||30,
        speed:  3,
        direction: :down,
        invisible: false,
        moving:    false,
        fixed:     false
      }
      if (pos = options.delete :position)
        options[:x] = pos[0]
        options[:y] = pos[1]
      end
      set_options(defaults.merge options)
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

    def collide?(object, direction, offset=0)
      # Returns true if the actor is facing
      # the object it's touching, preventing
      # him from moving forward.

      return false if object == self
      offset_x = 0
      offset_y = 0
      case direction.intern
        when :up
          offset_y = -(@height/2)-offset
        when :down
          offset_y = (@height/2)+offset
        when :left
          offset_x = -(@width/2)+offset
        when :right
          offset_x = (@width/2)-offset
      end
      touch?(object, offset_x, offset_y)
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
  end
end