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

  after(:each) { Object.send(:remove_const, :Radio) }

  describe "#load_song" do
    let(:radio) { Radio.new }
    let(:path)  { File.expand_path("../../../../media/song.wav", __FILE__) }

    it "adds a song to memory" do
      radio.load_song(path)
      expect(radio.current_song.is_a?(Gosu::Song)).to be_true
    end

    it "only holds a single song instance across classes" do
      class Mock2
        include Gamework::HasSound
      end

      song = radio.load_song(path)
      expect(Mock2.new.current_song).to eq(song)
    end
  end

end