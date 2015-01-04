# Gamework

Gamework is a MVC game making framework built on the
Ruby Gosu library.  While providing a basic application
structure and utility methods, Gamework tries to
remain agnostic as to what kind of game you want to
build.

## Installation

First install the gem:

    gem install gamework

Then initialize a new app:

    bundle exec gamework new my-app

Finally, cd into your app and start:

    cd my-app
    bundle exec gamework start

You can also run the developer console inside your app:

    bundle exec gamework console

## Usage

As described, Gamework provides an MVC framework for building games.  The basic components are as follows:

- [**Actors**](https://github.com/SteveAquino/gamework/tree/master/lib/gamework/actor): Representing the *model* in MVC, actors are the main components and stars of the game.  Instances of models are rendered as graphics on screen, and have attributes such as `width` and `acceleration`.
- **Maps**: *Coming soon*
- [**Scenes**](https://github.com/SteveAquino/gamework/tree/master/lib/gamework/scenes): *Coming soon*
- [**Gamework::App**](#main-loop-and-flow): `Gamework::App` provides a global interface to the current window and loop.

### Main Loop and Flow

Actors, Scenes, and Maps all render within the map game loop.  To bridge the gap between these, the window, and player input, the `Gamework::App` module provides a global API for starting the game and queuing up new scenes.

The current scene is responsible for transitioning to the next scene, quitting the game, and responding to user input ([more info](https://github.com/SteveAquino/gamework/tree/master/lib/gamework/scenes)).

#### The Update/Draw Cycle

`Gamework::App` has the `#update` and `#draw` methods that are both called each frame.  These methods delegate to the current scene.  `Gamework::Scene` in turn loops over each actor in the current scene and calls `#update` and `#draw` respectively.

#### Starting the Game and Transitioning Scenes

To start the game, call the `start!` method and pass the name of a scene that should be loaded first:

```
class TitleScene < Gamework::Scene
  on_button_down 'escape', 'kb', :quit

  def start_scene
    show_text 'My First Scene' y: 50,
                               height: 50,
                               width: Gamework::App.width,
                               justify: :center
  end
end

Gamework::App.start! 'title'
```

To load the next scene, call the `next_scene` method with the name of the scene:

```
class TitleScene < Gamework::Scene
  on_button_down 'escape', 'kb', :quit
  on_button_down 'enter', 'kb' do
    Gamework::App.next_scene 'another'
  end

  ...
end

class AnotherScene < Gamework::Scene
  on_button_down 'escape', 'kb', :quit

  def start_scene
    show_text 'Another Scene' y: 50,
                              height: 50,
                              width: Gamework::App.width,
                              justify: :center
  end
end

Gamework::App.start! 'title'

# Press 'ENTER' to go to the next scene
```

In the examples above we call `Scene#quit` when the ESC key was pressed.  `#quit` removes the current scene from the queue of scenes.  When there are no more scenes, the main loop ends and the window closes.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
