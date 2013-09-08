require_relative '../../../spec_helper'
 
describe Gamework::Scene do

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

  describe "#add_drawable" do
    it "adds unfixed drawables to the unfixed array" do
      scene    = Gamework::Scene.new
      drawable = Gamework::Drawable.new x: 10, y: 10
      scene.add_drawable drawable
      scene.unfixed.should eq([drawable])
    end

    it "adds fixed drawables to the fixed array" do
      scene    = Gamework::Scene.new
      drawable = Gamework::Drawable.new x: 10, y: 10, fixed: true
      scene.add_drawable drawable
      scene.fixed.should eq([drawable])
    end

    it "can be aliased as <<" do
      scene    = Gamework::Scene.new
      drawable = Gamework::Drawable.new x: 10, y: 10, fixed: true
      scene.should_receive(:add_drawable).with(drawable)
      scene << drawable
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

  describe "#create_drawable" do
    it "calls add_drawable with given arguments" do
      scene = Gamework::Scene.new
      scene.should_receive(:add_drawable)
      scene.create_drawable x: 10, y: 10
    end

    it "builds a drawable of a given type" do
      class CustomDrawable
        def initialize(options); end;
      end
      scene = Gamework::Scene.new
      scene.should_receive(:add_drawable)
      scene.create_drawable({x: 10, y: 10}, 'custom_drawable')
    end
  end

end