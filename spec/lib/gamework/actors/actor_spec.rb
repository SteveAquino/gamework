require_relative '../../../spec_helper'
 
describe Gamework::Actor do
  describe ".new" do
    it "creates an Actor from a hash of options" do
      options = {
        size: 30,
        position: [400, 320]
      }
      spritesheet = File.expand_path("../../../../media/spritesheet.png")
      actor = Gamework::Actor.new(spritesheet, options)
      actor.width.should eq(30)
      actor.height.should eq(30)
      actor.x.should eq(400)
      actor.y.should eq(320)
    end
  end


end