require 'uispecrunner'
require 'uispecrunner/options'

class UISpecRunner
  class Application
    def self.run!(*arguments)
      options = UISpecRunner::Options.new(arguments)
      
      if options[:invalid_argument]
        $stderr.puts options[:invalid_argument]
        options[:show_help] = true
      end

      if options[:command] == :help
        $stderr.puts options.opts
        return 1
      end
      
      if options[:command] == :version
        version_path = File.join(File.dirname(__FILE__), '..', '..', 'VERSION')
        version = File.read(version_path)
        $stdout.puts version
        return 0
      end
      
      # Read standard arguments from uispec.opts
      options_file = File.join(Dir.getwd, 'uispec.opts')
      if File.exists?(options_file)
        options = UISpecRunner::Options.from_file(options_file).merge(options)
      end
      
      runner = UISpecRunner.new(options)
      runner.run!
      return 0
    end
  end
end
