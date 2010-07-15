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

      if options[:show_help]
        $stderr.puts options.opts
        return 1
      end
      
      # Read standard arguments from uispec.opts
      options_file = 'uispec.opts'
      if File.exists?(options_file)
        option_file_args = File.readlines(options_file).map {|l| l.chomp.split " "}.flatten
        options = options.merge(UISpecRunner::Options.new(option_file_args))
      end
      
      runner = UISpecRunner.new(options)
      runner.run!
      return 0
    end
  end
end
