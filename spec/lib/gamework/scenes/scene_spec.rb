require_relative '../../../spec_helper'
 
describe Gamework::Scene do
  class MockScene < Gamework::Scene
  end

  describe ".build_scene" do
    it "calls #build_scene when initializing a new scene" do
      path  = File.expand_path('../../../../media/test.yaml', __FILE__)
      MockScene.build_scene(path)
      MockScene.any_instance.stub(:build_scene)
      MockScene.any_instance.should_receive(:build_scene)
      scene = MockScene.new.load_assets
    end
  end

  describe "#build_scene" do
    it "populates the scene with data from a yaml file" do
      data  = {'x' => 10, 'y' => 10, 'width' => 30, 'height' => 30, 'spritesheet' => "spritesheet.png"}
      path  = File.expand_path('../../../../media/test.yaml', __FILE__)
      scene = Gamework::Scene.new
      scene.stub(:load_song)
      scene.stub(:create_actor)
      scene.stub(:create_tileset)
      scene.should_receive(:load_song).with('song.png', true)
      scene.should_receive(:create_actor).with(:player, data)
      scene.build_scene(path)
    end
  end

  describe "hook methods" do
    describe "#update" do
      it "calls before_update and after_update" do
        scene = Gamework::Scene.new
        scene.should_receive(:before_update)
        scene.should_receive(:after_update)
        scene.update
      end
    end

    describe "#draw" do
      it "calls before_draw and after_draw" do
        scene = Gamework::Scene.new
        scene.stub(:draw_relative)
        scene.should_receive(:before_draw)
        scene.should_receive(:after_draw)
        scene.draw
      end
    end
  end

  describe "#create_tileset" do
    it "creates a new Tileset instance with given arguments" do
      Gamework::Tileset.any_instance.stub(:make_sprites)
      Gamework::Tileset.any_instance.stub(:make_tiles)
      scene = Gamework::Scene.new
      scene.create_tileset("test.txt", 32, 32, "test.png")

      scene.tileset.should_not be_nil
    end
  end

  describe "#create_actor" do
    it "creates a new Actor instance with given arguments" do
      options = {
        size: 10,
        position: [10, 10],
        spritesheet: File.expand_path("../../../../media/spritesheet.png")
      }
      scene = Gamework::Scene.new
      scene.create_actor(:player, options)

      scene.actors[:player].should_not be_nil
    end
  end

end