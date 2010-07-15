# UISpec Runner
# By: Blake Watters <blake@twotoasters.com>
# Portions borrowed from Eloy Duran's Kicker script (http://github.com/alloy/UISpec)

require 'tmpdir'

class UISpecRunner
  attr_accessor :project, :target, :configuration, :sdk_version, :build_dir, :verbose
  
  # private
  attr_accessor :run_mode, :class_name, :method_name, :protocol_name
  
  def initialize(options = {})
    options.each { |k,v| self.send("#{k}=", v) }
    self.target ||= 'UISpec'
    self.configuration ||= 'Debug'
    self.build_dir ||= './build'
    self.run_mode ||= :all
  end    
  
  def run!
    # TODO: Do the right thing based on command
    case run_mode
    when :all
      run_all!
    when :class
      run_class!(self.class_name)
    when :method
      run_class_method!(self.class_name, self.method_name)
    when :protocol
      run_protocol!(self.protocol_name)
    else
      raise ArgumentError, "Unknown run mode: #{run_mode}"
    end    
  end
  
  def run_all!
    run_specs
  end
  
  def run_protocol!(protocol_name)
    run_specs('UISPEC_PROTOCOL' => protocol_name)
  end
  
  def run_class!(class_name)
    run_specs('UISPEC_CLASS' => class_name)
  end
  
  def run_class_method!(class_name, method_name)
    run_specs('UISPEC_CLASS' => class_name, 'UISPEC_METHOD' => method_name)
  end
  
  def verbose?
    self.verbose
  end
  
  private
    def run_specs(env = {})
     if build_project!
       with_env('DYLD_ROOT_PATH' => sdk_dir, 'IPHONE_SIMULATOR_ROOT' => sdk_dir, 'CFFIXED_USER_HOME' => tmpdir) do
         command = "#{build_dir}/Debug-iphonesimulator/#{target}.app/#{target} -RegisterForSystemEvents"
         puts "Executing: #{command}" if verbose?
         system command
       end
     else
       puts "[!] Failed to build UISpecs.app"
     end
    end
    
    def sdk_dir
      "/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator#{sdk_version}.sdk"
    end
    
    def tmpdir
      Dir.tmpdir
    end
    
    def project_switch
      "-project #{project}" if project
    end
    
    def sdk_switch
      "-sdk #{sdk_dir}" if sdk_version
    end
    
    def build_project!
      command = "xcodebuild #{project_switch} -target #{target} -configuration #{configuration} #{sdk_switch} > /dev/null"
      puts "Building project with: #{command}" if verbose?
      system(command)
    end
    
    def find_latest_sdk
      # TODO
    end
    
    def with_env(env)
      before = env.inject({}) { |h, (k, _)| h[k] = ENV[k]; h }
      env.each { |k, v| ENV[k] = v }
      yield
    ensure
      before.each { |k, v| ENV[k] = v }
    end
end
