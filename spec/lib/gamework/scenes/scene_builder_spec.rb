require_relative '../../../spec_helper'
 
describe Gamework::SceneBuilder do
  describe "#load" do
    it "reads a yaml file and initializes the scene" do
      scene   = Gamework::Scene.new
      path    = File.expand_path('../../../../media/test.yaml', __FILE__)
      builder = Gamework::SceneBuilder.new(scene, path)
      data    = builder.load

      data["song"].should_not be_nil
      data["actors"].should_not be_nil
      data["tileset"].should_not be_nil
    end
  end

  describe "#build_song" do
    it "loads a song on the scene instance" do
      scene   = Gamework::Scene.new
      path    = File.expand_path('../../../../media/test.yaml', __FILE__)
      builder = Gamework::SceneBuilder.new(scene, path)
      builder.load
      scene.stub(:load_song)

      scene.should_receive(:load_song)
      builder.build_song
    end
  end

  describe "#build_actors" do
    it "creates actors for a given list of actors" do
      data    = {'x' => 10, 'y' => 10, 'width' => 30, 'height' => 30, 'spritesheet' => "spritesheet.png"}
      scene   = Gamework::Scene.new
      path    = File.expand_path('../../../../media/test.yaml', __FILE__)
      builder = Gamework::SceneBuilder.new(scene, path)
      builder.load
      scene.stub(:create_actors)

      scene.should_receive(:create_actor).with(:player, data)
      builder.build_actors
    end
  end
end