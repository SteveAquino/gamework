require 'spec_helper'

describe Gamework::Shape do
  let(:shape) { Gamework::Shape.new :square }

  describe '#fade' do
    it 'modifies the value of @alpha by a given amount' do
      shape.fade(10)
      expect(shape.alpha).to eq(245)
    end
  end

  describe '#alpha=' do
    it 'modifies the alpha value of @color' do
      shape.alpha = 10
      expect(shape.color.alpha).to eq(10)
    end

    it 'modifies the alpha value for all @colors' do
      colored = Gamework::Shape.new :square, colors: ['white', 'white', 'white', 'white']
      colored.alpha = 10
      colored.colors.each {|c| expect(c.alpha).to eq(10) }
    end

    it "doesn't got lower than 0" do
      shape.alpha = - 10
      expect(shape.alpha).to eq(0)
    end

    it "doesn't go higher than 255" do
      shape.alpha = 1000
      expect(shape.alpha).to eq(255)
    end
  end
end