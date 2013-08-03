require 'rubygems'
require 'gamework'
require 'pry'

puts "Running Gamework Version #{Gamework::VERSION}"

class MyScene < Gamework::MapScene

  # Set asset directory
  has_assets "spec/media"

  # Register input
  on_button_down 'escape' do
    Gamework::App.exit
  end

  def initialize
    super

    # Load music
    load_song "song.mp3"

    # Draw map
    mapfile     = File.expand_path "../../spec/media/map.txt", __FILE__
    spritesheet = File.expand_path "../../spec/media/tileset.png", __FILE__
    create_tileset(mapfile, 32, 32, spritesheet)

    # Draw player
    spritesheet = File.expand_path "../../spec/media/spritesheet.png", __FILE__
    @sprite = Gamework::Sprite.new(32, 32, 32, 32, spritesheet)
  end

  def draw
    @sprite and @sprite.draw
    super
  end

  def update
    @sprite and @sprite.update
    super
  end

end

Gamework::App.config do |c|
  c.width  = 800
  c.height = 640
  c.title  = "Simple Example"
  # c.debug_mode = true
end

Gamework::App.start do
  Gamework::App.add_scene(MyScene)
end