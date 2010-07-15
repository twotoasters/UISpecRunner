# -e - Executes a single spec by method name
# -c - Executes all specs in a given class
# -p - Execute all specs on a class conforming to a specific protocol
# -sdk - Set the SDK version
# -project= - Set the project
# -latest-sdk - Detect the latest SDK
# 
# TODO: Should be able to install a Rake file
# TODO: Should be able to install a main.m runner file.
require 'uispecrunner'
require 'uispecrunner/options'

class UISpecRunner
  class Application
    def self.run!(*arguments)
      # TODO: Parse the options
      # TODO: Instantiate the app and run...
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
