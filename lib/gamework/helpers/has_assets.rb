module Gamework
  module HasAssets

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_assets(path='assets')
        @@asset_directory = path
        include InstanceMethods
      end

      def asset_directory
        @@asset_directory
      end
    end

    module InstanceMethods
      def asset_path(file=nil, *args)
        # Allows you to passing multiple arguments to build a file path
        # relative to the asset_directory.

        base_path = [asset_directory, args.reverse].compact.join('/')
        File.expand_path(file.to_s, base_path)
      end

      def asset_directory
        self.class.asset_directory
      end
    end

  end
end