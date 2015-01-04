module Gamework
  module HasAssets

    # Builds a path to an asset, optionally
    # nested under given arugments, and using
    # Gamework::App.asset_directory
    def asset_path(file, *args)
      [Gamework::App.asset_directory, args.reverse, file]
        .flatten.compact.join('/')
    end

    # Include methods on instances and classes
    def self.included(base)
      base.send :extend, Gamework::HasAssets
    end
  end
end
