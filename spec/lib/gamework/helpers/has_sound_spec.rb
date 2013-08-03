require_relative '../../../spec_helper'
 
describe Gamework::HasSound do
  describe ".asset_directory" do
    it "returns the directory for song and sound assets" do
      Gamework::HasSound.asset_directory.should_not be_nil
    end
  end

  describe ".asset_path" do
    it "returns the directory for song and sound assets" do
      Gamework::HasSound.asset_directory = "media"
      path = Gamework::HasSound.asset_path("song.mp3", "songs")
      path.should =~ /media\/songs\/song.mp3\z/
    end

    it "builds a path from multiple arguments" do
      Gamework::HasSound.asset_directory = "media"
      path = Gamework::HasSound.asset_path("song.mp3", "songs", "test_dir")
      path.should =~ /media\/test_dir\/songs\/song.mp3\z/
    end
  end

  describe "#load_song" do
    it "adds a song to memory" do
      file = File.expand_path("../../../../media/song.mp3", __FILE__)
      Gamework::HasSound.load_song(file)
      Gamework::HasSound.current_song.should_not be_nil
      Gamework::HasSound.current_song.is_a?(Gosu::Song).should be_true
    end

    it "only holds a single song instance across classes" do
      class Mock1
        include Gamework::HasSound
      end
      class Mock2
        include Gamework::HasSound
      end

      file = File.expand_path("../../../../media/song.mp3", __FILE__)
      song = Mock1.new.load_song(file)

      Mock2.current_song.should eq(song)
      Gamework::HasSound.current_song.should eq(song)
    end
  end
end