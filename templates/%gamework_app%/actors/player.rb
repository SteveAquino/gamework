class Link < Gamework::Drawable
  trait 'gamework::movement'
  trait 'gamework::animated_sprite'

  attributes width: 30,
             height: 30,
             spritesheet: asset_path('images/link.png'),
             follow: true
end
