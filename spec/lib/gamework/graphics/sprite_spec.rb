require_relative '../../../spec_helper'
 
describe Gamework::Sprite do

  describe "#split_tiles_by_four" do
    it "splits an array into four consecutive subarrays in a hash" do
      Gamework::Sprite.any_instance.stub(:make_sprites)
      sprite = Gamework::Sprite.new(1,2,3,4,5)
      tiles  = (0..40).to_a
      sprite.split_tiles_by_four(tiles)
      sprites = sprite.instance_variable_get("@sprites")
      [:down, :left, :right, :up].each_with_index do |dir, i|
        range    = (i*10)...(i*10+10)
        subarray = range.to_a
        sprites[dir].should eq(subarray)
      end
    end
  end

end