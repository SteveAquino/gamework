module Gamework
  module Collection
    def self.included(base)
      # Sets a 'class instance variable', which
      # acts like a class variable that is unique
      # among all various subclasses
      
      base.instance_variable_set "@collection", []
      base.extend ClassMethods
    end

    module ClassMethods
      include Enumerable

      def each(&block)
        @collection ||= []
        @collection.each(&block)
      end

      def create(*args)
        object = new(*args)
        @collection ||= []
        @collection << object
        return object
      end

      def all
        @collection
      end

      def last
        @collection[-1]
      end

      def shift
        @collection.shift
      end

      def clear
        @collection.clear
      end
    end
  end
end

