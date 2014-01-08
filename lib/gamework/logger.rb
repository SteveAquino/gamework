# This class is a simple wrapper for
# outputing formatted text to the
# active console as well as an
# optional textfile.  Usually there
# is a single instance of this class
# attached to Gamework::App, eg:
#  Gamework::App.info 'Hello world!'

require 'colorize'

module Gamework
  class Logger
    # Allow log silencing by setting
    # Gamework::App.logger.silent = true
    attr_accessor :silent

    def initialize(log_file=nil)
      @log_file = log_file
      @silent   = false
    end

    # Print to the current console and
    # output to a log file if one is set
    def log(*messages, level)
      return if @silent

      message = messages.join("\n    ")
      message = format_log(message, level)
      puts(message)
      write_to_log(message, @log_file) if @log_file
    end

    def info(*messages)
      log(*messages, :info)
    end

    def warn(*messages)
      log(*messages, :warn)
    end

    def error(*messages)
      log(*messages, :error)
    end

    # Add a timestamp and colorize
    # based on log level
    def format_log(message, level=:info)
      header = case level.intern
      when :warn
        "WARN:".yellow
      when :error
        "ERROR:".red
      end
      [header, message].compact.join(" ")
    end

    private

    # Suppress console output during tests
    def puts(string)
      super(string) unless Gamework.const_defined?('ENV') && Gamework::ENV == 'test'
    end

    def write_to_log(message, log_file)
      f = File.open File.expand_path(log_file), 'a'
      f.puts(message.uncolorize)
      f.close
    end
  end
end