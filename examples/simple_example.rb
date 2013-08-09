require 'rubygems'
require 'gamework'
require 'pry'

puts "Running Gamework Version #{Gamework::VERSION}"

class MyScene < Gamework::MapScene

  # Set asset directory
  has_assets "spec/media"

  # Listen for input
  on_button_down 'escape', 'kb', :end_scene
  on_button_toggle ['up', 'down', 'left', 'right'], 'kb', :move_player, :stop_player

  def initialize
    # Initialize basic MapScene class
    super

    # Load music
    load_song "song.mp3"

    # Draw map
    mapfile     = asset_path("map.txt")
    spritesheet = asset_path("tileset.png")
    create_tileset(mapfile, 32, 32, spritesheet)

    # Create player
    spritesheet = asset_path("spritesheet.png")
    @player = Gamework::Actor.new(30, 30, 30, 30, spritesheet)
  end

  def draw
    @player and @player.draw
    super
  end

  def update
    update_input
    @player and @player.update
    update_camera(@player)
  end

  def end_game(b=nil)
    Gamework::App.exit
  end

  def move_player(dir)
    @player.move(dir.intern)
  end

  def stop_player(dir=nil)
    @player.stop
  end

end

Gamework::App.config do |c|
  c.width  = 800
  c.height = 640
  c.title  = "Simple Example"
  # c.debug_mode = true
end

Gamework::App.start do
  Gamework::App << MyScene
end