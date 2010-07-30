# UISpec Runner
# By: Blake Watters <blake@twotoasters.com>
# Portions borrowed from Eloy Duran's Kicker script (http://github.com/alloy/UISpec)

require 'tmpdir'

class UISpecRunner
  attr_accessor :project, :target, :configuration, :sdk_version, :build_dir, :verbose, :securityd, :env
  
  # private
  attr_accessor :run_mode, :spec, :example, :protocol
  
  def initialize(options = {})
    options.each { |k,v| self.send("#{k}=", v) }
    self.target ||= 'UISpec'
    self.configuration ||= 'Debug'
    self.build_dir ||= './build'
    self.run_mode ||= :all
    self.env ||= {}
  end    
  
  def run!
    case run_mode
    when :all
      run_all!
    when :spec
      run_spec!(self.spec)
    when :example
      run_spec_example!(self.spec, self.example)
    when :protocol
      run_protocol!(self.protocol)
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
    def run_command(command)
      puts "Executing: #{command}" if verbose?
      system(command)
    end
    
    def path_to_securityd
      "#{sdk_dir}/usr/libexec/securityd"
    end
    
    def start_securityd
      run_command("launchctl submit -l UISpecRunnerDaemons -- #{path_to_securityd}")
      @securityd_running = true
      Signal.trap("INT") { stop_securityd }
      Signal.trap("TERM") { stop_securityd }
      Signal.trap("EXIT") { stop_securityd }
    end
    
    def stop_securityd
      run_command("launchctl remove UISpecRunnerDaemons") if @securityd_running
      @securityd_running = false
    end
    
    def run_specs(env = {})
     if build_project!
       run_env = self.env.merge(env)
       run_env.merge!('DYLD_ROOT_PATH' => sdk_dir, 'IPHONE_SIMULATOR_ROOT' => sdk_dir, 'CFFIXED_USER_HOME' => tmpdir)
       puts "Setting environment variables: #{run_env.inspect}" if verbose?
       with_env(run_env) do
         start_securityd if securityd
         command = "#{build_dir}/#{configuration}-iphonesimulator/#{target}.app/#{target} -RegisterForSystemEvents"
         puts "Executing: #{command}" if verbose?
         output = `#{command}`
         exit_code = $?
         unless exit_code == 0
           puts "[!] Failed to run UISpec target: #{output}"
           exit 1
         end
       end
     else
       puts "[!] Failed to build UISpecs.app"
       exit 1
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
    
    def with_env(env)
      before = env.inject({}) { |h, (k, _)| h[k] = ENV[k]; h }
      env.each { |k, v| ENV[k] = v }
      yield
    ensure
      before.each { |k, v| ENV[k] = v }
    end
end
