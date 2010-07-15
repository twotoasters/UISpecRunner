# TODO: Should be able to install a Rake file
# TODO: Should be able to install a main.m runner file.
# TODO: Should be able to auto-detect sdk version
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
      
      # puts "Arguments are: #{options.opts}"
      # exit 1
      runner = UISpecRunner.new(options)
      runner.run!
      return 0
    end
  end
end
