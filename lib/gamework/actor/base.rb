# Represents objects within a scene
# that need to respond to update and
# draw on each frame.

# Actors can be subclassed
# and intialized with default attributes
# easily by passing a hash of options,
# eg: MyClass.new x: 10, y: 10, speed: 3
#
# Actors can easily be added to a scene's
# render loop using Scene#add_actor.
# This automatically registers an actor
# to recieve regular updates and
# draws from the parent scene.  An actor
# can be removed from the scen by calling
# Actor#delete, which tells the scene
# to remove the object from the collection
# on the next update.

# Actors can be extended with
# more advanced functionality using
# traits.  Traits dynamically include
# modules located in your /traits
# directory with a class name pattern
# of :TraitName:Trait, eg: module FunTrait.
# syntax: trait 'trait_name'
# Include a trait with the following

require "active_support/core_ext/string/inflections"

module Gamework
  module Actor
    class Base
      # The base options that all instances of
      # Actor get by default
      BASE_OPTIONS = {
        x: 0,
        y: 0,
        z: 0,
        width:  1,
        height: 1,
        scale:  1,
        angle:  0,
        fixed:  false
      }

      # Set starting attributes with defaults,
      # load any _initialize hooks
      def initialize(options={})
        announce(options) if Gamework::App.showing?
        create_attributes default_options.merge(options)
        _initialize
      end

      def _initialize; end
      def draw; end
      def update; end
      
      def pos?(x, y)
        [@x, @y] == [x, y]
      end

      def above?(actor)
        self.y < actor.y
      end

      def below?(actor)
        self.y > actor.y
      end

      def left?(actor)
        self.x < actor.x
      end

      def right?(actor)
        self.x > actor.x
      end

      def set_position(x, y)
        @x, @y = x, y
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

      # If this method returns true, the
      # object will be drawn fixed on the
      # screen and move with the camera.
      # The default is to scroll with the
      # map as the camera moves.
      def fixed?
        !!@fixed
      end

      # Mark a actor for deletion from
      # it's parent scene.
      def delete
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

      # Logs the class and given options
      def announce(options={})
        Gamework::App.logger.info "#{self.class}".yellow.bold, "{" + options.map {|k,v| "#{k}: #{v}"}.join(", ") + "}"
      end

      def default_options
        BASE_OPTIONS.merge(self.class._attributes)
      end

      # Creates attributes from a hash
      def create_attributes(options, writer=false)
        options.each do |key, value|
          if writer
            create_writable_attribute(key,value)
          else
            create_readable_attribute(key,value)
          end
        end
      end

      # Creates attr_writer with default value
      def create_readable_attribute(name, value=nil)
        self.class.send :attr_reader, name
        instance_variable_set "@#{name}", value
      end

      # Creates attr_writer with default value
      def create_writeable_attribute(name, value=nil)
        self.class.send :attr_writer, name
        instance_variable_set "@#{name}", value
      end

      # Aliases a method and adds a new
      # method call to the end of the
      # original method
      def self.extend_method(original, added)
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

      # Dynamically load a trait module
      def self.trait(name)
        # Titleize turns :: into /, so we'll
        # convert back and to allow namespaced
        # trait modules

        base = name.to_s.titleize.gsub('/','::').gsub(' ', '')
        module_name = "#{base}Trait".constantize
        include(module_name)

        # Extend _initialize, update, and draw
        method_suffix = name.to_s.split("::").last.downcase
        %w(_initialize update draw).each do |base_method|

          # Appends the module name to the base_method,
          # eg: initialize_movement
          joined_method = "#{base_method}_#{method_suffix}".sub(/\A_/, '')
          if module_name.instance_methods.include?(joined_method.intern)
            # Call the joined_method after the base_method,
            # eg: initialize_movement will be called after
            # initialize is run
            extend_method(base_method, joined_method)
          end
        end
      end

      # Set initial attributes for new instances
      def self.attributes(options)
        @attributes = options
      end

      def self._attributes
        @attributes ||= {}
      end

    end
  end
end
