require_relative '../../../spec_helper'
 
describe Gamework::MapScene do
  class MockWindow
    def translate(a,b,&block)
      yield if block_given?
    end
  end
  class MockSprite
    attr_reader :drawn
    def draw(a,b,c)
      @drawn = true
    end
  end

  describe "#create_tileset" do
    it "creates a new Tileset instance with given arguments" do
      Gamework::Tileset.any_instance.stub(:make_sprites)
      Gamework::Tileset.any_instance.stub(:make_tiles)
      scene = Gamework::MapScene.new
      scene.create_tileset("test.txt", 32, 32, "test.png")

      scene.tileset.should_not be_nil
    end
  end

  describe "#draw" do
    it "delegates draw to all tiles in the Tileset" do
      sprites = [MockSprite.new,MockSprite.new]
      Gamework::Tileset.any_instance.stub(:make_tiles)
      Gamework::Tileset.any_instance.stub(:make_sprites)
      Gamework::App.stub(:window).and_return { MockWindow.new }
      Gosu::Window.stub(:translate)
      scene = Gamework::MapScene.new
      scene.create_tileset("test.txt", 32, 32, "test.png")
      scene.tileset.instance_variable_set("@tiles", [[0,0],[1,1]])
      scene.tileset.instance_variable_set("@sprites", sprites)

      scene.draw
      sprites.each {|s| s.drawn.should be_true}
    end
  end
end