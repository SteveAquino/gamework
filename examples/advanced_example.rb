require 'rubygems'
require 'gamework'
require 'pry'

puts "Running Gamework Version #{Gamework::VERSION}"

class MyScene < Gamework::MapScene
  has_assets "spec/media"

  on_button_down ['escape', 'q'], 'kb', :end_game

  def initialize
    # Initialize basic Scene class
    super

    # Load music
    load_song "song.mp3"

    # Draw map
    mapfile     = asset_path("map.txt")
    spritesheet = asset_path("tileset.png")
    mapkey  = {'.' => 0, ',' => 1, '#' => 2, 't' => 3, 'x' => 4}
    create_tileset(mapfile, 32, 32, spritesheet, mapkey)

    # Draw player
    spritesheet = asset_path("spritesheet.png")
    @sprite = Gamework::Sprite.new(80, 80, 32, 32, spritesheet)
  end

  def draw
    @sprite and @sprite.draw
    super
  end

  def update
    @sprite and @sprite.update
    super
  end

  def self.end_game
    Gamework::App.exit
  end

end

Gamework::App.config do |c|
  c.width  = 800
  c.height = 640
  c.title  = "Advanced Example"
  # c.debug_mode = true
end

Gamework::App.start do
  Gamework::App.add_scene(MyScene)
end