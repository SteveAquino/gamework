require_relative '../../../spec_helper'
 
describe Gamework::HasAssets do
  before(:each) do
    class MockAsset
      include Gamework::HasAssets
    end

    Gamework::App.config {|c| c.asset_directory = File.expand_path('media') }
  end

  after(:each) do
    Object.send(:remove_const, :MockAsset)
    Gamework::App.config {|c| c.asset_directory = nil }
  end

  describe "#asset_path" do
    it "builds a path from a single argument" do
      mock = MockAsset.new
      path = mock.asset_path("song.wav")
      expect(path).to match(/media\/song.wav\z/)
    end

    it "builds a path from multiple arguments" do
      mock = MockAsset.new
      path = mock.asset_path("song.wav", "songs")
      expect(path).to match(/media\/songs\/song.wav\z/)
    end
  end

end
