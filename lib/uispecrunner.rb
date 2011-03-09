# UISpec Runner
# By: Blake Watters <blake@twotoasters.com>
# Portions borrowed from Eloy Duran's Kicker script (http://github.com/alloy/UISpec)

require 'rubygems'
gem 'open4', '>= 1.0.1'
require 'open4'
require 'uispecrunner/xcode_builder'
require 'uispecrunner/drivers/shell'
require 'uispecrunner/drivers/osascript'

class UISpecRunner
  # Build Options
  attr_accessor :workspace, :scheme, :project, :target, :configuration, :sdk_version, :build_dir
  
  # Run Options
  attr_accessor :verbose, :securityd, :driver, :env, :exit_on_finish, :app_path
  
  # private
  attr_accessor :run_mode, :spec, :example, :protocol
  
  def initialize(options = {})
    options.each { |k,v| self.send("#{k}=", v) }
    self.configuration ||= 'Debug'
    self.build_dir ||= './build'
    self.run_mode ||= :all
    self.driver ||= :shell
    self.exit_on_finish ||= true
    self.env ||= {}
  end    
  
  def run!
    case self.run_mode
    when :all
      run_all!
    when :spec
      run_spec!(self.spec)
    when :example
      run_spec_example!(self.spec, self.example)
    when :protocol
      run_protocol!(self.protocol)
    else
      raise ArgumentError, "Unknown run mode: #{config.run_mode}"
    end    
  end
  
  def run_all!
    run_specs
  end
  
  def run_protocol!(protocol_name)
    run_specs('UISPEC_PROTOCOL' => protocol_name)
  end
  
  def run_spec!(spec_name)
    run_specs('UISPEC_SPEC' => spec_name)
  end
  
  def run_spec_example!(spec_name, example_name)
    run_specs('UISPEC_SPEC' => spec_name, 'UISPEC_EXAMPLE' => example_name)
  end    
  
  # Configuration Methods
  
  def verbose?
    self.verbose
  end
  
  def exit_on_finish?
    self.exit_on_finish
  end
  
  def xcode_root
    @xcode_root ||= "#{`xcode-select -print-path`.chomp}"
  end

  def sdk_dir
    "#{xcode_root}/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator#{self.sdk_version}.sdk"
  end
  
  def app_path
    @app_path || "#{self.build_dir}/#{self.configuration}-iphonesimulator/#{self.target}.app/#{self.target}"
  end
  
  def app_executable_name
    File.basename(app_path).gsub(/.app$/, '')
  end
  
  def app_executable_path
    File.join(app_path, app_executable_name)
  end
  
  private
    def driver_class
      # TODO: Add WaxSim...
      if self.driver == :shell
        UISpecRunner::Drivers::Shell
      elsif self.driver == :osascript
        UISpecRunner::Drivers::OSAScript
      end
    end
    
    def run_specs(env = {})
      puts "Building project..."
      builder = UISpecRunner::XcodeBuilder.new(self)
      if builder.build!
        @app_path ||= builder.app_path
        puts "Running specs via #{driver}..."
        env['UISPEC_EXIT_ON_FINISH'] = self.exit_on_finish? ? 'YES' : 'NO'
        driver = driver_class.new(self)      
        driver.run_specs(env)
        # TODO: Exit with exit code from the process...
      else
        puts "Failed to build"
        # TODO: Exit with the exit code from xcodebuild...
        exit(-1)
      end
    end
end
