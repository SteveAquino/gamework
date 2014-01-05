require 'colorize'

module Gamework
  class Logger
    COLORS = {
      red: 31,
      green: 32,
      yellow: 33,
      blue: 34
    }

    def initialize(log_file=nil)
      @log_file = log_file
    end

    def log(message, level=:info)
      message = format_log(message, level)
      puts(message)
      write_to_log(message, @log_file) if @log_file
    end

    def warn(message)
      log(message, :warn)
    end

    def error(message)
      log(message, :error)
    end

    def format_log(message, level=:info)
      header = "[#{Time.now}]"
      header = case level.intern
      when :warn
        "#{header} WARN:".yellow
      when :error
        "#{header} ERROR:".red
      else
        header.blue
      end
      "#{header} #{message}"
    end

    private

    def write_to_log(message, log_file)
      f = File.open File.expand_path(log_file), 'a'
      f.puts(message.uncolorize)
      f.close
    end
  end
end