module Gamework
  module HasAssets
    @@asset_directory = 'assets'

    def asset_directory
      @@asset_directory
    end

    def asset_directory=(path)
      @@asset_directory = path
    end

    def asset_path(file=nil, *args)
      # Allows you to passing multiple arguments to build a file path
      # relative to the asset_directory.

      base_path = [asset_directory, args.reverse].compact.join('/')
      File.expand_path(file, base_path)
    end

  end
end