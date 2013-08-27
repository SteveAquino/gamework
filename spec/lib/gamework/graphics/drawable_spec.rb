require_relative '../../../spec_helper'
 
describe Gamework::Drawable do

  describe "#set_options" do
    it "sets instance variables from a hash of options" do
      drawable = Gamework::Drawable.new
      drawable.send :set_options, {opt: 'hello', tion: 'world'}
      drawable.instance_variable_get("@opt").should eq('hello')
      drawable.instance_variable_get("@tion").should eq('world')
    end
  end

  describe "#hitbox" do
    xit "returns an array of boundaries for collision detection" do
      drawable = Gamework::Drawable.new
      drawable
    end
  end

end