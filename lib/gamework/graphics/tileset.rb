module Gamework
	class Tileset
		attr_reader :width, :height, :spritesheet, :mapkey

		def initialize(width, height, spritesheet, mapkey=nil)
			@width, @height, @spritesheet, @mapkey = width, height, spritesheet, mapkey
			@tiles = load_tileset
		end

		def load_tileset
			# Load width x height tiles
			# Padding overlap in all four directions (?)

			Gosu::Image.load_tiles(Gamework::App.window, @spritesheet, @width, @height, true)
		end

		def create_tiles(mapfile)
			# Given a textfile, converts various characters
			# into corresponding graphics from the tilesheet
			# and inserts them into a nested width x height
			# array

			# The default is to simply convert each character
		  # to an integer

		  # If the optional mapkey attribute is set, this
		  # method converts the character into an integer
		  # representing an index in the tileset array

			lines   = File.readlines(mapfile).map { |line| line.chomp }
			height  = lines.size
			width   = lines[0].size
			@tiles  = Array.new(width) do |x|
				Array.new(height) do |y|
					char = lines[y][x, 1]

					if @mapkey.nil?
						char.to_i
					else
						@mapkey[char]
					end
				end
			end
		end

	end
end

# Mapkey to get test.txt to work:
# %w(.,#tx).inject({}) {|map, key| map[key] = key }