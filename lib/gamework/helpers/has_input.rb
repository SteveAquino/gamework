module Gamework
  module HasInput
    # Creates a simple DSL for mapping use input
    # to custom callbacks and methods.  Once the
    # module has been included, you can register
    # input with several versions of syntax:
    #
    # symbol syntax
    # on_button_down 'escape', 'kb', :my_method_name
    #
    # block syntax
    # on_button_down 'escape', 'kb' do
    #   puts "I'm escaping!"
    # end

    def self.included(base)
      base.extend ClassMethods
    end

    def button_down(id)
      callback = self.class.button_down_mapping[id]
      callback and call_block_or_array(callback)
    end

    def button_up(id)
      callback = self.class.button_up_mapping[id]
      callback and call_block_or_array(callback)
    end

    def button_down?(id)
      Gamework::App.window.button_down?(id)
    end

    def gosu_button_id(id, source)
      # Convenience method for button mapping

      self.class.gosu_button_id(id, source)
    end
    
    def call_block_or_array(block_or_array)
      # Takes a block or an array of arguments
      # for the send call

      if block_or_array.kind_of?(Array)
        # Try sending the button id with
        # the callback.  If the call fails,
        # try sending the callback without
        # arguments

        begin
          send(*block_or_array)
        rescue ArgumentError
          send(block_or_array[0])
        end
      elsif block_or_array.kind_of?(Proc)
        block_or_array.call
      end
    end

    def update_input
      # Checks to see if a button is being pressed
      # at a given moment.  Use this method on an
      # including classes's update method.

      self.class.button_down_mapping.each do |id, callback|
        call_block_or_array(callback) if button_down?(id)
      end
    end

    module ClassMethods
      def on_button_down(ids, source='kb', method_name=nil, &block)
        register_callback(button_down_mapping, ids, source, method_name)
      end

      def on_button_up(ids, source='kb', method_name=nil, &block)
        register_callback(button_up_mapping, ids, source, method_name)
      end

      def on_button_toggle(ids, source='kb', down_method, up_method)
        register_callback(button_down_mapping, ids, source, down_method)
        register_callback(button_up_mapping, ids, source, up_method)
      end

      def register_callback(mapping, ids, source, method_name, &block)
        ids = [ids] unless ids.kind_of?(Array)
        ids.each do |id|
          key = gosu_button_id(id, source)
          if block_given?
            # Map anonymous block
            mapping[key] = block
          elsif method_name
            # Send id to method and store as a Proc
            mapping[key] = [method_name, id]
          end
        end
      end

      def button_down_mapping
        @button_down_mapping ||= {}
      end

      def button_up_mapping
        @button_up_mapping ||= {}
      end

      def gosu_button_id(id, source)
        # Maps a string to a Gosu::Button constant

        constant_name = "#{source.capitalize}#{id.capitalize}"
        Gosu::Button.const_get(constant_name)
      end
    end

  end
end