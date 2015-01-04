# Actors

Actors are the building blocks of your game.  Actors can be defined ahead of time with specific, custom functionality, or built on the fly with an attributes hash.

Here's a basic actor definition:

```
class Hero < Gamework::Actor::Base
  # Extend our actor with extra behavior
  trait 'gamework::animated_sprite'
  trait 'gamework::physics'

  # Define attributes with default values
  attributes width: 30, height: 30, name: 'Unknown'
end

@hero = Hero.new x: 100, y: 100, name: 'Bob'
@hero.x    #=> 100
@hero.name #=> 'Bob'
```

## Attributes

Actors are initialized with default attributes specified in `Gamework::Actor::Base::BASE_OPTIONS`:

```
{
  x: 0,
  y: 0,
  z: 0,
  width:  1,
  height: 1,
  scale:  1,
  angle:  0,
  fixed:  false
}
```

By using the `.attributes` method, you can override the default settings and add extra `attr_reader` attributes:

```
class Hero < Gamework::Actor::Base
  attributes width: 30,
             height: 30,
             hp: 100,
             name: 'Unknown'

  def set_name(name)
    @name = name
  end

  def take_damage(amount)
   @hp -= ammount
  end
end
```

All attributes can be overridden when initializing a new actor:

```
@bob = Hero.new name: 'Bob', hp: 1000
@joe = Hero.new name: 'Joe', hp: 500, mp: 100 # Define custom attributes per instance
```

## Adding Behavior to Actors using Traits

Sometimes you want to add extra logic to your actors, such as sprites and movement.  In Gamework, `traits` are a special kind of module that can easily be included to extend a class.  Traits work using a naming convention for the module and method names that make it easy for Gamework to integrate your custom logic into Scenes.

A trait module must be a module whose name ends with `Trait`, for example `PhysicsTrait` or `Ai::MovementTrait`.  This allows your module to be added to an actor class by calling `.trait` with the name of your trait.:

```
class Hero < Gamework::Actor::Base
  trait 'physics'
  trait 'ai::movement'
end
```

Each trait can provide up to 3 hook methods that get called by the including scene:

```
initialize_:trait # Called when an including class is created
update_:trait     # Called on an instance before drawing occurs each frame
draw_:trait       # Called on an instance when drawing occurs each frame
```

By defining these hook methods, you can add behavior to different parts of the draw cycle.  For example, adding acceleration to an actor:

```
# Provides basic 2 dimensional physics
# with simple velocity and mass equations
module PhysicsTrait
  def initialize_physics
    @vel_x ||= 0
    @vel_y ||= 0
    @speed ||= 0.5
    @mass  ||= 5
  end

  # Moves as an object in
  # 'space' at a given velocity
  def update_physics
    @x += @vel_x
    @y += @vel_y
    
    @vel_x *= drag
    @vel_y *= drag
  end

  # Amount that velocity is
  # multiplied by on each
  # update to slow an object
  def drag
    1 - (@mass/100.0)
  end

  # Increase the angle by
  # a given degree
  def rotate(degrees)
    @angle += degrees
  end

  # Set the angle explicitly
  def set_angle(degrees)
    @angle = degrees
  end

  # Accelerates in two dimensions at
  # @speed/px per frame
  def accelerate
    @vel_x += Gosu::offset_x(@angle, @speed)
    @vel_y += Gosu::offset_y(@angle, @speed)
  end

  # Same as accelerate only reduces velocity
  # instead of increasing it
  def decelerate
    @vel_x += Gosu::offset_x(@angle, -@speed)/2
    @vel_y += Gosu::offset_y(@angle, -@speed)/2
  end
end

```

### Default Traits

There are a number of traits that are included with Gamework, including the physics from the example above:

- `gamework::physics` - Adds velocity, acceleration, and rotation
- `gamework::movement` - Adds 4 directional movement
- `gamework::warp` - Makes actors warp between screen edges
- `gamework::animated_sprite` - Adds spritesheet mapping and animating

## Interacting with Scenes

Actors and Scenes have a special relationship because the current scene needs to keep track of all the known actors.  Scenes manage updating and drawing actors on the screen.  To add a new actor to your scene, call the `#add_actor` method:

```
class MyScene < Gamework::Scene
  def add_hero(name)
    @hero = Hero.new name: name
    add_actor @hero
  end
end
```

Each frame, the scene loops through all of the known actors and calls `#update` and `#draw` in turn.  When `#update` and `#draw` are called on an actor, all of that actor's traits are invoked.

## Built in Actors

- `Gamework::Shape` - creates squares, rectangles, ciricles, and more
- `Gamework::Text` - draws free text on the screen
- `Gamework::Tileset` - reads a spritesheet and a sprite-map key to build maps
- `Gamework::Animation` - reads a spritesheet for single or looped animation
- `Gamework::Transition` - creates basic fade in/out transitions for scenes
