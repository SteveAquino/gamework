module Gamework
	class Tileset
		attr_reader :tile_width, :tile_height, :spritesheet, :mapkey,
								:sprites, :tiles

		def initialize(tile_width, tile_height, spritesheet, mapkey=nil)
			@tile_width, @tile_height, @spritesheet, @mapkey = tile_width, tile_height, spritesheet, mapkey
		end

		def draw
			draw_tiles
		end

		def make_sprites
			# Calls Gosu::Image.load_tiles which splits a
			# given graphic file into @tile_width x @tile_height tiles
			# and returns an array of Gosu::Images

			@sprites = Gosu::Image.load_tiles(Gamework::App.window, @spritesheet, @tile_width, @tile_height, true)
		end

		def make_tiles(mapfile)
			# Converts a textfile into a nested array of
			# integers that correspond to a given index
			# in the array of sprites.

			lines  = File.readlines(mapfile).map { |line| line.chomp }
			height = lines.size
			width  = lines[0].size
			@tiles = Array.new(width) do |x|
				Array.new(height) do |y|
					char = lines[y][x, 1]
					@mapkey.nil? ? char.to_i : @mapkey[char]
				end
			end
		end

		def get_tile(x,y)
			# Gets the index in the array of sprites that
			# corresponds to a given x,y coordinate

			@tiles[x][y]
		end

		def get_sprite(x,y)
			idx = get_tile(x,y)
			@sprites[idx] if idx
		end

		def draw_tile(x,y)
			sprite = get_sprite(x,y)
			if sprite
				z_index = 0
				sprite.draw(x * @tile_width, y * @tile_height, z_index)
			end
		end

		def draw_tiles
			# Very primitive drawing function:
			# Draws all the tiles, some off-screen, some on-screen.

			height = @tiles.size
			width  = @tiles[0].size

			height.times do |y|
				width.times do |x|
					draw_tile(x,y)
				end
			end
		end

	end
end