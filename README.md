# Gamework

Gamework is a MVC game making framework built on the
Ruby Gosu library.  While providing a basic application
structure and utility methods, Gamework tries to
remain agnostic as to what kind of game you want to
build.

## Installation

Add this line to your application's Gemfile:

    gem 'gamework'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gamework

## Usage

As described, Gamework provides an MVC framework for building games.  The basic components are as follows:

- **Actors**: Representing the *model* in MVC, actors are the main components and stars of the game.  Instances of models are rendered as graphics on screen, and have attributes such as `width` and `acceleration`.
- **Maps**: *Coming soon*
- **Scenes**: *Coming soon*

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
