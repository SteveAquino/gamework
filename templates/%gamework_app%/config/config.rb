Gamework::App.config do |c|
  c.width  = 800
  c.height = 640
  c.title  = "Ruby Zelda"
  c.asset_directory = File.expand_path 'media'

  # Log console output
  # c.log_file = File.expand_path 'log/log.txt'

  # Enable debug mode
  # c.debug_mode = true
end
