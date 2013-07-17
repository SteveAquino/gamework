require_relative '../../spec_helper'
 
describe Gamework::Sound do
	describe ".load_song" do
		it "adds a song to memory" do
			file = File.expand_path("../../../media/song.mp3", __FILE__)
			Gamework::Sound.load_song(file)
			Gamework::Sound.current_song.should_not be_nil
			Gamework::Sound.current_song.is_a?(Gosu::Song).should be_true
		end		

		it "only holds a single song instance across classes" do
			class Mock1
				include Gamework::Sound
			end
			class Mock2
				include Gamework::Sound
			end

			file = File.expand_path("../../../media/song.mp3", __FILE__)
			song = Mock1.load_song(file)

			Mock2.current_song.should eq(song)
			Gamework::Sound.current_song.should eq(song)
		end
	end
end