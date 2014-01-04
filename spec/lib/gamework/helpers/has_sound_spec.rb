require_relative '../../../spec_helper'
 
describe Gamework::HasSound do
  before(:each) do
    class Radio
      include Gamework::HasSound
      def asset_path(path)
        path
      end
    end
  end

  after(:each) do
    Object.send(:remove_const, :Radio)
  end

  describe "#load_song" do
    it "adds a song to memory" do
      r = Radio.new
      file = File.expand_path("../../../../media/song.wav", __FILE__)
      r.load_song(file)
      r.current_song.should_not be_nil
      r.current_song.is_a?(Gosu::Song).should be_true
    end

    it "only holds a single song instance across classes" do
      class Mock2
        include Gamework::HasSound
      end

      file = File.expand_path("../../../../media/song.wav", __FILE__)
      song = Radio.new.load_song(file)
      Mock2.new.current_song.should eq(song)
    end
  end

end