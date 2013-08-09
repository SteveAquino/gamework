module Gamework
  class Actor

    attr_reader :x, :y, :z, :width, :height,
                :direction, :moving, :animating,
                :sprite

    def initialize(x, y, width, height, spritesheet)
      @x, @y, @width, @height = x, y, width, height
      @z = 0
      @speed = 3
      @direction = :down
      @animating = @moving = @dir_fixed = false
      @sprite = Sprite.new(x, y, width, height, spritesheet)
    end

    def update
      @sprite.update
    end

    def draw
      @sprite.draw
    end

    def set_position(x, y)
      @x, @y = x, y
    end
    
    def pos?(x, y)
      [@x, @y] == [x, y]
    end

    def turn(direction)
      @direction = direction
      @sprite.turn direction
    end

    def step_forward
      move @direction
    end
    
    def stop
      @moving = false
      @sprite.stop
    end

    def move(direction)
      turn direction unless @dir_fixed
      # return if obstructed?(direction)
      
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
      @sprite.move(direction)
    end

    # def animate(&block)
    #   builder = AnimationBuilder.new
    #   yield(builder)
    #   changed and notify_observers(animation: builder.create)
    # end
    
    # def start_animating
    #   @animating = true
    # end
    
    # def stop_animating
    #   @animating = false
    # end

    # def animating?
    #   @animating
    # end
    
    # def collision_box(offset_x=0, offset_y=0)
    #   # Draws a rectangle from top left corner
    #   # around an object to represent it's
    #   # boundary for collision detection

    #   x = @x - (@width  / 2) + offset_x
    #   y = @y - (@height / 2) + offset_y
      
    #   box = { :a => [], :b => [], :c => [], :d => [] }
      
    #   box[:a] = [x, y]
    #   box[:b] = [x + @width, y]
    #   box[:c] = [x, y + @height]
    #   box[:d] = [x + @width, y + @height]
      
    #   return box
    # end

    # def draw_collision_box(c)
    #   # For testing, draws a rectangle around the
    #   # object to show where the 'edges' are for
    #   # collision detection

    #   $game.draw_quad(collision_box[:a][0], collision_box[:a][1], c, collision_box[:b][0], collision_box[:b][1], c,
    #                   collision_box[:c][0], collision_box[:c][1], c, collision_box[:d][0], collision_box[:d][1], c, ZOrder::UI) 
    # end
    
    # def touch?(target)
    #   # Checks to see if the target is a GameObject,
    #   # otherwise assumes it is a hash
      
    #   if target.class.ancestors.include?(GameObject)
    #     box = target.collision_box
    #   else
    #     box = target
    #   end
      
    #   if box[:a][0] > self.collision_box[:b][0]
    #     return false
    #   elsif box[:b][0] < self.collision_box[:a][0]
    #     return false
    #   elsif box[:a][1] > self.collision_box[:c][1]
    #     return false
    #   elsif box[:c][1] < self.collision_box[:a][1]
    #     return false
    #   else
    #     return true
    #   end
    # end

    # def collide?(object, direction)
    #   # Must be a GameObject for collision
    #   return false if object == self
    #   case direction
    #     when :up
    #       box = object.collision_box(0, 2)
    #     when :down
    #       box = object.collision_box(0, -2)
    #       collide = touch?(box)
    #     when :left
    #       box = object.collision_box(2, 0)
    #       collide = touch?(box)
    #     when :right
    #       box = object.collision_box(-2, 0)
    #       collide = touch?(box)
    #   end
    #   return touch?(box)
    # end

    # def obstructed?(direction)
    #   Npc.all.any? {|npc| collide?(npc, direction)  }
    # end
    
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