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
        width:  30,
        height: 30,
        speed:  3,
        scale:  1,
        direction: :down,
        invisible: false,
        moving:    false,
        animated:  false,
        fixed:     false,
        movement:  {}
      }
      if (pos = options.delete :position)
        options[:x] = pos[0]
        options[:y] = pos[1]
      end
      if (size = options.delete :size)
        options[:width] = size
        options[:height] = size
      end
      set_options(defaults.merge options)
    end

    def update
      sprite.update
      update_auto_movement
    end

    def draw
      sprite.draw if showing?
    end

    def sprite
      # Lazy load the actor sprite

      @sprite ||= Sprite.new(@x, @y, @width, @height, @spritesheet, @animated)
    end

    def turn(direction)
      @direction = direction
      sprite.turn direction
    end
    
    def stop
      @moving = false
      sprite.freeze
    end

    def move(direction)
      turn direction unless @dir_fixed
      return(stop) if scene_collision(Gamework::App.current_scene)
      
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
      sprite.set_position(@x,@y)
      sprite.animate
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

    def scene_collision(scene)
      return false unless scene && scene.actors
      scene.actors.any? {|name, actor| collide?(actor, @direction)}
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

    def update_auto_movement
      # Creates threads for new movements
      # to update in parallel to other
      # processes

      return if @movement[:moving]
      distance = @movement[:distance] || @width
      delay    = @movement[:delay]    || 1
      if @movement[:type].to_s == 'random'
        Thread.new { random_movement(distance, delay) }
      end
    end

    def random_movement(distance, delay)
      # TODO: Check for collision first

      @movement[:moving] = true
      # Random direction
      dir = %w(up down left right)[rand(4)]
      
      # Move between 0 and 2 steps
      steps = rand(3)
      steps.times do
        turn(dir.intern)
        step(distance)
      end
      sleep delay
      @movement[:moving] = false
    end

    def step(distance)
      # Moves a given distance over 1
      # second based on the actor's speed

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