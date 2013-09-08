require "active_support/core_ext/string/inflections"

module Gamework
  class Drawable
    # Represents objects within a scene
    # that need to respond to update and
    # draw on each frame.

    # Drawable objects can be subclassed
    # and intialized with default attributes
    # easily by passing a hash of options,
    # eg: MyClass.new x: 10, y: 10, speed: 3

    # Drawable objects can be extended with
    # more advanced functionality using
    # traits.  Traits dynamically include
    # modules located in your /traits
    # directory with a class name pattern
    # of TraitNameTrait, eg: module FunTrait.
    # Include a trait with the following
    # syntax: trait 'trait_name'

    def initialize(options={})
      # Set starting attributes with defaults,
      # load any _initialize hooks

      create_attributes default_options.merge(options)
      _initialize
    end

    def _initialize; end
    def draw; end
    def update; end

    def set_position(x, y)
      @x, @y = x, y
    end
    
    def pos?(x, y)
      [@x, @y] == [x, y]
    end

    def above?(drawable)
      self.y < drawable.y
    end

    def below?(drawable)
      self.y > drawable.y
    end

    def left?(drawable)
      self.x < drawable.x
    end

    def right?(drawable)
      self.x > drawable.x
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

    def delete
      # Mark a drawable for deletion from
      # it's parent scene.

      @delete = true
    end

    def delete?
      !!@delete
    end

    def touch?(object)
      distance = Gosu::distance(center_x, center_y, object.center_x, object.center_y)
      distance < @width &&
      distance < @height
    end

    def center_x
      @x
    end

    def center_y
      @y
    end

    def top_y
      center_y-rad_y
    end

    def bottom_y
      center_y+rad_y
    end

    def left_x
      center_x-rad_x
    end

    def right_x
      center_x+rad_x
    end

    def rad_x
      @width/2
    end

    def rad_y
      @height/2
    end

    private

    def default_options
      @defaults ||= {
        x: 0,
        y: 0,
        z: 0,
        width:  1,
        height: 1,
        scale:  1,
        angle:  0,
        fixed:  false
      }
    end

    def create_attributes(options, writer=false)
      # Creates attributes from a hash.

      options.each do |key, value|
        if writer
          create_writable_attribute(key,value)
        else
          create_readable_attribute(key,value)
        end
      end
    end

    def create_readable_attribute(name, value=nil)
      # Creates attr_writer with default value

      self.class.send :attr_reader, name
      instance_variable_set "@#{name}", value
    end

    def create_writeable_attribute(name, value=nil)
      # Creates attr_writer with default value

      self.class.send :attr_writer, name
      instance_variable_set "@#{name}", value
    end

    def self.extend_method(original, added)
      # Aliases a method and adds a new
      # method call to the end of the
      # original method

      meta_method = "_#{original}_with_#{added}"
      code = %Q{
        alias_method :#{meta_method}, :#{original}

        def #{original}
          #{meta_method}
          #{added}
        end
      }
      class_eval(code)
    end

    def self.trait(name)
      # Titleize turns :: into /, so we'll
      # convert back and to allow namespaced
      # trait modules

      base = name.to_s.titleize.gsub('/','::').gsub(' ', '')
      module_name = "#{base}Trait".constantize
      include(module_name)

      # Extend initialize, update, and draw
      method = name.split("::").last.downcase
      if module_name.instance_methods.include?("initialize_#{method}".intern)
        extend_method("_initialize", "initialize_#{method}")
      end
      if module_name.instance_methods.include?("update_#{method}".intern)
        extend_method("update", "update_#{method}")
      end
      if module_name.instance_methods.include?("draw_#{method}".intern)
        extend_method("draw", "draw_#{method}")
      end
    end
  end
end