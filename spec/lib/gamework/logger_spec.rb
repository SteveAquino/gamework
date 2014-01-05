require 'spec_helper'

describe Gamework::Logger do
  let(:logger)    { Gamework::Logger.new('logs.txt') }
  let(:timestamp) { '2014-01-01 00:00:00 -0800' }
  before(:each)   { Time.stub(:now) { timestamp } }

  describe '#log' do
    it 'prints a message to the console' do
      logger.stub(:write_to_log)
      expect(logger).to receive(:puts).with("[#{timestamp}]".blue + " Hi")
      logger.log('Hi')
    end

    it 'calls #write_to_log if a @log_file is set' do
      logger.stub(:puts)
      expect(logger).to receive(:write_to_log).with("[#{timestamp}]".blue + " Hi", 'logs.txt')
      logger.log('Hi')
    end
  end

  describe '#warn' do
    it 'calls #log with a level of :warn' do
      expect(logger).to receive(:log).with('Hi', :warn)
      logger.warn('Hi')
    end
  end

  describe '#error' do
    it 'calls #log with a level of :error' do
      expect(logger).to receive(:log).with('Hi', :error)
      logger.error('Hi')
    end
  end

  describe '#format_log' do
    it 'appends a timestamp to a message' do
      expect(logger.format_log 'Hi').to eq("[#{timestamp}]".blue + " Hi")
    end

    it 'colorizes input for a given log level' do
      expect(logger.format_log 'Hi', :warn).to eq("[#{timestamp}] WARN:".yellow + " Hi")
      expect(logger.format_log 'Hi', :error).to eq("[#{timestamp}] ERROR:".red + " Hi")
    end
  end

  describe '#write_to_log' do
    let(:file) { double('file', puts: '', close: '') }
    before(:each) { File.stub(:open) { file } }

    it "opens up the log file" do
      expect(File).to receive(:open).with('/home/steve/Gems/gamework/logs.txt', 'a')
      logger.send :write_to_log, 'Hi'.yellow, 'logs.txt'
    end

    it "outputs text uncolorized to a given log file" do
      expect(file).to receive(:puts).with('Hi')
      logger.send :write_to_log, 'Hi'.yellow, 'logs.txt'
    end

    it "closes the log file" do
      expect(file).to receive(:close)
      logger.send :write_to_log, 'Hi'.yellow, 'logs.txt'
    end

  end
end