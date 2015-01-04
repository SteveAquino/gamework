require_relative '../../../spec_helper'
 
describe Gamework::Actor::Base do
  let(:actor) { Gamework::Actor::Base.new }

  describe "#create_attributes" do
    it "creates readable attributes from a hash of options" do
      actor.send :create_attributes, {opt: 'hello', tion: 'world'}
      actor.opt.should eq('hello')
      actor.tion.should eq('world')
    end

    it "is called on initialize" do
      actor = Gamework::Actor::Base.new({opt: 'hello', tion: 'world'})
      actor.opt.should eq('hello')
      actor.tion.should eq('world')
    end

    it "sets default options" do
      actor.x.should eq(0)
      actor.y.should eq(0)
      actor.z.should eq(0)
      actor.width.should  eq(1)
      actor.height.should eq(1)
      actor.angle.should  eq(0)
      actor.scale.should  eq(1)
      actor.fixed.should  be_false
    end

    it "overrides default options" do
      actor = Gamework::Actor::Base.new x: 100
      actor.x.should eq(100)
    end
  end

  describe '#announce' do
    it 'logs a message with given options' do
      logger = double('logger', info: '')
      Gamework::App.stub(:logger)   { logger }
      expect(logger).to receive(:info).with("Gamework::Actor::Base".yellow.bold, "{x: 100, y: 100}")
      actor.send :announce, x: 100, y: 100
    end
  end

  describe "#set_position" do
    it "sets the value of x and y" do
      actor = Gamework::Actor::Base.new
      actor.set_position(100,200)
      actor.x.should eq(100)
      actor.y.should eq(200)
    end
  end

  describe "#resize" do
    it "sets the value of width and height" do
      actor = Gamework::Actor::Base.new
      actor.resize(100,200)
      actor.width.should eq(100)
      actor.height.should eq(200)
    end
  end

  describe "#fix" do
    it "sets the value of fixed to true" do
      actor = Gamework::Actor::Base.new
      actor.fix
      actor.fixed?.should be_true
    end
  end

  describe "#unfix" do
    it "sets the value of fixed to false" do
      actor = Gamework::Actor::Base.new(fixed: true)
      actor.unfix
      actor.fixed?.should be_false
    end
  end

  describe "#touch?" do
    it "returns true if two objects overlap" do
      actor1 = Gamework::Actor::Base.new(x: 100, y: 100)
      actor2 = Gamework::Actor::Base.new(x: 100, y: 100)
      actor1.touch?(actor2).should be_true
    end

    it "compensates for width" do
      actor1 = Gamework::Actor::Base.new(x: 100, y: 100, width: 10, height: 10)
      actor2 = Gamework::Actor::Base.new(x: 109, y: 100, width: 10, height: 10)
      actor1.touch?(actor2).should be_true
    end

    it "compensates for height" do
      actor1 = Gamework::Actor::Base.new(x: 100, y: 100, width: 10, height: 10)
      actor2 = Gamework::Actor::Base.new(x: 100, y: 109, width: 10, height: 10)
      actor1.touch?(actor2).should be_true
    end
  end

  describe ".trait" do
    it "dynamically includes a Trait module" do
      module SweetnessTrait
        def say_something_sweet
          'sweet'
        end
      end
      class SweetGuy < Gamework::Actor::Base
        trait :sweetness
      end
      guy = SweetGuy.new
      guy.say_something_sweet.should eq('sweet')

      Object.send(:remove_const, :SweetGuy)
    end

    it "includes namespaced modules" do
      class Ball < Gamework::Actor::Base
        trait 'gamework::physics'
      end
      Ball.new.respond_to?(:accelerate).should be_true

      Object.send(:remove_const, :Ball)
    end
  end

  describe ".attributes" do
    before(:each) do
      class Ball < Gamework::Actor::Base
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
