require_relative '../../../spec_helper'
 
describe Gamework::Drawable do

  describe "#hitbox" do
    it "returns an array of boundaries for collision detection" do
      drawable = Gamework::Drawable.new
      drawable
    end
  end

  describe "#set_options" do
    it "sets instance variables from a hash of options" do
      drawable = Gamework::Drawable.new
      drawable.send :set_options, {opt: 'hello', tion: 'world'}
      drawable.opt.should eq('hello')
      drawable.tion.should eq('world')
    end

    it "optionally creates writer methods" do
      drawable = Gamework::Drawable.new
      drawable.send :set_options, {test: 'before'}, true
      drawable.test = 'after'
      drawable.test.should eq('after')
    end
  end

end