require_relative '../../../spec_helper'
 
describe Gamework::Drawable do
  let(:drawable) { Gamework::Drawable.new }

  describe "#create_attributes" do
    it "creates readable attributes from a hash of options" do
      drawable.send :create_attributes, {opt: 'hello', tion: 'world'}
      drawable.opt.should eq('hello')
      drawable.tion.should eq('world')
    end

    it "is called on initialize" do
      drawable = Gamework::Drawable.new({opt: 'hello', tion: 'world'})
      drawable.opt.should eq('hello')
      drawable.tion.should eq('world')
    end

    it "sets default options" do
      drawable.x.should eq(0)
      drawable.y.should eq(0)
      drawable.z.should eq(0)
      drawable.width.should  eq(1)
      drawable.height.should eq(1)
      drawable.angle.should  eq(0)
      drawable.scale.should  eq(1)
      drawable.fixed.should  be_false
    end

    it "overrides default options" do
      drawable = Gamework::Drawable.new x: 100
      drawable.x.should eq(100)
    end
  end

  describe '#announce' do
    it 'logs a message with given options' do
      logger = double('logger', info: '')
      Gamework::App.stub(:logger)   { logger }
      expect(logger).to receive(:info).with("Gamework::Drawable".yellow.bold, "{x: 100, y: 100}")
      drawable.send :announce, x: 100, y: 100
    end
  end

  describe "#set_position" do
    it "sets the value of x and y" do
      drawable = Gamework::Drawable.new
      drawable.set_position(100,200)
      drawable.x.should eq(100)
      drawable.y.should eq(200)
    end
  end

  describe "#resize" do
    it "sets the value of width and height" do
      drawable = Gamework::Drawable.new
      drawable.resize(100,200)
      drawable.width.should eq(100)
      drawable.height.should eq(200)
    end
  end

  describe "#fix" do
    it "sets the value of fixed to true" do
      drawable = Gamework::Drawable.new
      drawable.fix
      drawable.fixed?.should be_true
    end
  end

  describe "#unfix" do
    it "sets the value of fixed to false" do
      drawable = Gamework::Drawable.new(fixed: true)
      drawable.unfix
      drawable.fixed?.should be_false
    end
  end

  describe "#touch?" do
    it "returns true if two objects overlap" do
      drawable1 = Gamework::Drawable.new(x: 100, y: 100)
      drawable2 = Gamework::Drawable.new(x: 100, y: 100)
      drawable1.touch?(drawable2).should be_true
    end

    it "compensates for width" do
      drawable1 = Gamework::Drawable.new(x: 100, y: 100, width: 10, height: 10)
      drawable2 = Gamework::Drawable.new(x: 109, y: 100, width: 10, height: 10)
      drawable1.touch?(drawable2).should be_true
    end

    it "compensates for height" do
      drawable1 = Gamework::Drawable.new(x: 100, y: 100, width: 10, height: 10)
      drawable2 = Gamework::Drawable.new(x: 100, y: 109, width: 10, height: 10)
      drawable1.touch?(drawable2).should be_true
    end
  end

  describe ".trait" do

    it "dynamically includes a Trait module" do
      module SweetnessTrait
        def say_something_sweet
          'sweet'
        end
      end
      class SweetGuy < Gamework::Drawable
        trait :sweetness
      end
      guy = SweetGuy.new
      guy.say_something_sweet.should eq('sweet')

      Object.send(:remove_const, :SweetGuy)
    end

    it "includes namespaced modules" do
      class Ball < Gamework::Drawable
        trait 'gamework::physics'
      end
      Ball.new.respond_to?(:accelerate).should be_true

      Object.send(:remove_const, :Ball)
    end
  end

  describe ".attributes" do
    before(:each) do
      class Ball < Gamework::Drawable
        attributes x: 100, y: 200, custom: 'value'
      end
    end

    after(:each) { Object.send(:remove_const, :Ball) }

    it "specifies default attributes for new instances" do
      ball = Ball.new
      expect(ball.x).to eq(100)
      expect(ball.y).to eq(200)
      expect(ball.custom).to eq('value')
    end

    it "defines attributes that can be set at initialization" do
      ball = Ball.new x: 200, y: 300, custom: 'other'
      expect(ball.x).to eq(200)
      expect(ball.y).to eq(300)
      expect(ball.custom).to eq('other')
    end
  end

end
