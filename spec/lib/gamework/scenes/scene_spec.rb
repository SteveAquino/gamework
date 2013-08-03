require_relative '../../../spec_helper'
 
describe Gamework::Scene do

  describe ".update" do
    it "delegates #update to the first Scene in the collection" do
      Gamework::Scene.clear
      scene = Gamework::Scene.create
      scene.should_receive(:update)
      Gamework::Scene.update
    end

    it "destroys the scene on the next update" do
      Gamework::Scene.clear
      scene = Gamework::Scene.create
      scene.end_scene
      expect { Gamework::Scene.update }.to change { Gamework::Scene.count }.by(-1)
    end
  end

  describe ".draw" do
    it "delegates #draw to the first Scene in the collection" do
      Gamework::Scene.clear
      scene = Gamework::Scene.create
      scene.should_receive(:draw)
      Gamework::Scene.draw
    end
  end

  describe "#end_scene" do
    it "marks the Scene for deletion" do
      scene = Gamework::Scene.create
      scene.end_scene
      scene.ended?.should be_true
    end
  end

end