module Gamework
  class Tileset
    attr_reader :tile_width, :tile_height, :tiles, :mapkey,
                :spritesheet, :sprites

    def initialize(tile_width, tile_height, spritesheet, mapkey=nil)
      @tile_width, @tile_height, @spritesheet, @mapkey = tile_width, tile_height, spritesheet, mapkey
    end

    def draw
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
      @tiles = lines.map do |line|
        line.each_char.map {|l| @mapkey.nil? ? l.to_i : @mapkey[l]}
      end
    end

    def get_tile(x,y)
      # Gets the index in the array of sprites that
      # corresponds to a given x,y coordinate

      @tiles[y] and @tiles[y][x]
    end

    def get_sprite(x,y)
      idx = get_tile(x,y)
      @sprites[idx] if idx
    end

    def draw_tile(x,y)
      sprite = get_sprite(x,y)
      if sprite
        sprite.draw(x * @tile_width, y * @tile_height, 0)
      end
    end

    def self.create(mapfile, *args)
      # Allow one method creation and initialization

      tileset = new(*args)
      tileset.make_sprites
      tileset.make_tiles(mapfile)
      return tileset
    end

  end
end