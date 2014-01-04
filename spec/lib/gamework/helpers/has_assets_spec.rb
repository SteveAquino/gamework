require_relative '../../../spec_helper'
 
describe Gamework::HasAssets do

  describe ".asset_directory" do
    it "returns the directory for song and sound assets" do
      class MockAsset
        include Gamework::HasAssets
        has_assets "assets"
      end
      MockAsset.asset_directory.should_not be_nil
    end
  end

  describe ".asset_directory" do
    it "returns the directory for song and sound assets" do
      class MockAsset
        include Gamework::HasAssets
      end
      MockAsset.asset_directory.should_not be_nil
    end
  end

  describe "#asset_path" do
    it "returns the directory for song and sound assets" do
      class MockAsset
        include Gamework::HasAssets
        has_assets 'media'
      end
      asset = MockAsset.new
      path = asset.asset_path("song.wav", "songs")
      path.should =~ /media\/songs\/song.wav\z/
    end

    it "builds a path from multiple arguments" do
      class MockAsset
        has_assets 'media'
      end
      asset = MockAsset.new
      path = asset.asset_path("song.wav", "songs", "test_dir")
      path.should =~ /media\/test_dir\/songs\/song.wav\z/
    end
  end

end