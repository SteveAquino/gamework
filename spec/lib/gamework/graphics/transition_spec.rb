require 'spec_helper'

describe Gamework::Transition do
  let(:transition) { Gamework::Transition.new(:fade_in, duration: 1) }

  before(:each) do
    Gamework::App.stub(:width)  { 100 }
    Gamework::App.stub(:height) { 100 }
  end

  describe "#update" do
    it 'calls #update_surface' do
      expect(transition).to receive(:update_surface)
      transition.update
    end

    it 'calls #delete if #finished? returns true' do
      transition.stub(:finished?) { true }
      expect(transition).to receive(:delete)
      transition.update
    end
  end

  describe '#make_surface' do
    it 'creates a Gamework::Shape instance' do
      expect(transition.make_surface(:fade_in).kind_of? Gamework::Shape).to be_true
    end
  end

  describe '#update_surface' do
    it 'calls a method based on type' do
      %w(fade_in fade_out).each do |type|
        expect(transition).to receive(type).with(1)
        transition.update_surface(type, 1)
      end
    end
  end

  describe '#fade_in' do
    let!(:surface) { transition.make_surface(:fade_in) }

    it 'decreases the surface alpha' do
      transition.fade_in(1)
      expect(surface.alpha).to eq(251)
    end

    it 'marks finished when the surface alpha is 0' do
      10.times { transition.fade_in(0.1) }
      expect(transition.finished?).to be_true
    end
  end

  describe '#fade_out' do
    let!(:surface) { transition.make_surface(:fade_out) }

    it 'increases the surface alpha' do
      transition.fade_out(1)
      expect(surface.alpha).to eq(4)
    end

    it 'marks finished when the surface alpha is 255' do
      10.times { transition.fade_out(0.1) }
      expect(transition.finished?).to be_true
    end
  end

  describe '#finished? 'do
    it 'returns a boolean based on the value of @finished' do
      transition.instance_variable_set "@finished", true
      expect(transition.finished?).to be_true
    end
  end
end