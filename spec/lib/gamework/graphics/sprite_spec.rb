require_relative '../../../spec_helper'
 
describe Gamework::Sprite do
  describe "#make_sprites" do

    it "creates a hash of Gosu::Image instances" do
      path   = File.expand_path "../../../../media/spritesheet.png", __FILE__
      window = Gamework::Window.new(1,1)
      Gamework::App.stub(:window).and_return(window)
      Gosu::Image.any_instance.stub(:initialize)
      sprite  = Gamework::Sprite.new(0, 0, 30, 30, path)
      sprites = sprite.instance_variable_get("@sprites")
      sprites.length.should eq(4)
      [:up, :down, :left, :right].each do |dir|
        sprites[dir].length.should eq(11)
        sprites[dir].each {|t| t.is_a?(Gosu::Image).should be_true }
      end
    end
  
  end
end