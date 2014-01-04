require_relative '../../../spec_helper'
 
describe Gamework::HasAssets do
  before(:each) do
    class MockAsset
      include Gamework::HasAssets
      has_assets 'media'
    end
  end

  after(:each) { Object.send(:remove_const, :MockAsset) }

  describe ".asset_directory" do
    it "returns the directory for song and sound assets" do
      expect(MockAsset.asset_directory).to eq('media')
    end
  end

  describe "#asset_path" do
    it "builds a path from multiple arguments" do
      mock = MockAsset.new
      path = mock.asset_path("song.wav", "songs")
      expect(path).to match(/media\/songs\/song.wav\z/)
    end
  end

end