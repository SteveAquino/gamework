require_relative '../../../spec_helper'
 
describe Gamework::SceneBuilder do
  describe "#load" do
    it "reads a yaml file and initializes the scene" do
      scene   = Gamework::Scene.new
      path    = File.expand_path('../../../../media/test.yaml', __FILE__)
      builder = Gamework::SceneBuilder.new(scene, path)
      data    = builder.load

      data["song"].should_not be_nil
      data["tileset"].should_not be_nil
      data["drawable"].should_not be_nil
      data["custom"].should_not be_nil
    end
  end

  describe "#build_song" do
    it "loads a song on the scene instance" do
      scene   = Gamework::Scene.new
      builder = Gamework::SceneBuilder.new(scene, 'file')
      scene.stub(:load_song)
      scene.should_receive(:load_song).with('song.wav', true)
      builder.build_song(songfile: 'song.wav', autoplay: true)
    end
  end

  describe "#build_tileset" do
    it "loads a tileset on the scene instance" do
      scene   = Gamework::Scene.new
      builder = Gamework::SceneBuilder.new(scene, 'file')
      scene.stub(:create_tileset)
      scene.should_receive(:create_tileset).with(30, 'tileset.png', 'map.txt')
      builder.build_tileset(tile_size: 30, spritesheet: 'tileset.png', mapfile: 'map.txt')
    end
  end

  describe "#build_drawable" do
    it "creates a drawable instance with given options" do
      scene   = Gamework::Scene.new
      builder = Gamework::SceneBuilder.new(scene, 'file')
      scene.stub(:create_drawable)
      scene.should_receive(:create_drawable).with({x:10, y:10}, 'drawable')
      builder.build_drawable('drawable', x: 10, y: 10)
    end

    it "saves drawable as an instance variable" do
      scene    = Gamework::Scene.new
      builder  = Gamework::SceneBuilder.new(scene, 'file')
      drawable = Gamework::Drawable.new
      scene.stub(:create_drawable).and_return(drawable)
      builder.build_drawable('drawable', x: 10, y: 10, name: 'cool_guy')
      scene.instance_variable_get("@cool_guy").should eq(drawable)
    end
  end

  describe "#build_scene" do
    it "delegates correct data to scene" do
      scene    = Gamework::Scene.new
      drawable = Gamework::Drawable.new
      path     = File.expand_path('../../../../media/test.yaml', __FILE__)
      builder  = Gamework::SceneBuilder.new(scene, path)
      builder.load
      scene.stub(:load_song)
      scene.stub(:create_tileset)
      scene.stub(:create_drawable).and_return(drawable)
      scene.should_receive(:load_song).with('song.wav', true)
      scene.should_receive(:create_tileset).with(30, 'tileset.png', 'map.txt')
      scene.should_receive(:create_drawable).with({x:10, y:10}, 'drawable')
      scene.should_receive(:create_drawable).with({x:10, y:10}, 'custom')

      builder.build_scene
      scene.instance_variable_get("@player").should eq(drawable)
    end
  end

end