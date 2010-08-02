# UISpec Runner
# By: Blake Watters <blake@twotoasters.com>
# Portions borrowed from Eloy Duran's Kicker script (http://github.com/alloy/UISpec)

require 'uispecrunner/drivers/shell'
require 'uispecrunner/drivers/osascript'

class UISpecRunner    
  attr_accessor :project, :target, :configuration, :sdk_version, :build_dir, :verbose, :securityd, :driver, :env
  
  # private
  attr_accessor :run_mode, :spec, :example, :protocol
  
  def initialize(options = {})
    options.each { |k,v| self.send("#{k}=", v) }
    self.target ||= 'UISpec'
    self.configuration ||= 'Debug'
    self.build_dir ||= './build'
    self.run_mode ||= :all
    self.driver ||= :shell
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
  
  def verbose?
    self.verbose
  end
  
  private
    def driver_class
      if self.driver == :shell
        UISpecRunner::Drivers::Shell
      elsif self.driver == :osascript
        UISpecRunner::Drivers::OSAScript
      end
    end
    
    def run_specs(env = {})
      puts "Running specs via #{driver}..."
      driver = driver_class.new(self)
      driver.run_specs(env)
    end
end
