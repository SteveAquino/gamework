class Link < Gamework::Actor::Base
  trait 'gamework::movement'
  trait 'gamework::animated_sprite'

  attributes width:  30,
             height: 30,
             scale:  2,
             spritesheet: asset_path('images/link.png'),
             split_sprites: true
end

