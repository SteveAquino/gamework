module Gamework
  module HasInput
    def self.included(base)
      base.extend ClassMethods
    end

    def button_down(id)
      block = self.class.input_mapping[id]
      block and block.call
    end

    module ClassMethods
      def on_button_down(id, source='keyboard', &block)
        key = gosu_button_id(id, source)
        input_mapping[key] = -> {yield}
      end

      def on_button_up(id, &block)
      end

      def input_mapping
        @input_mapping ||= {}
      end

      def gosu_button_id(id, source)
        # Maps a string to a Gosu::Button constant

        source.gsub!('keyboard', 'kb')
        source.gsub!('gamepad', 'gp')
        source.gsub!('mouse', 'ms')
        constant_name = "#{source.capitalize}#{id.capitalize}"
        Gosu::Button.const_get(constant_name)
      end
    end
  end
end