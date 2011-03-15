class UISpecRunner
  class Options < Hash
    attr_reader :opts, :orig_args
    
    def self.from_file(options_file)
      args = File.readlines(options_file).map {|l| l.chomp.split " "}.flatten
      UISpecRunner::Options.new(args)
    end
    
    def initialize(args)
      super()
      
      @orig_args = args.clone
      
      # Configure default settings
      self[:run_mode] = :all
      self[:configuration] = 'Debug'
      self[:build_dir] = './build'
      self[:verbose] = false
      self[:sdk_version] = '4.0'
      self[:driver] = :waxsim
      self[:exit_on_finish] = true
      self[:env] = {}
      
      require 'optparse'
      @opts = OptionParser.new do |o|
        o.banner = "Usage: #{File.basename($0)} [options]\ne.g. #{File.basename($0)}"                
        
        o.separator ""
        o.separator "Run Modes:"
        
        o.on('-s', '--spec [CLASS]', 'Run the specified UISpec class') do |spec|
          self[:spec] = spec
          self[:run_mode] = :spec
        end
        
        o.on('-e', '--example [METHOD]', 'Run the specified example method (requires --spec)') do |example|
          self[:example] = example
          self[:run_mode] = :example
          # TODO: Need to raise exception if method is specified without class
        end
        
        o.on('-p', '--protocol [PROTOCOL]', 'Run all UISpec classes implementing the Objective-C protocol') do |protocol|
          self[:protocol] = protocol
          self[:run_mode] = :protocol
        end
        
        o.separator ""
        o.separator "Environment options:"
        
        o.on('-a', '--app [APP_PATH]',
             'Run the app at the specified path',
             'Default: auto-detect the app during the build') do |app_path|
          self[:app_path] = app_path
        end
        
        o.on('--project [PROJECT_FILE]',
             'Run the UISpec target in specified project',
             'Default: auto-detect project in current directory') do |project|
          self[:project] = project
        end
        
        o.on('--workspace [WORKSPACE_PATH]',
             'Run the UISpec scheme in the specified Xcode workspace at the path') do |workspace|
          self[:workspace] = workspace
        end
        
        o.on('--scheme [SCHEME_NAME]',
             'Build and run the specified XCode scheme.',
             'Default: UISpec (If workspace provided)') do |scheme|
          self[:scheme] = scheme
        end
        
        o.on('--driver [DRIVER]', [:shell, :osascript, :waxsim],
             "Select driver (shell, osascript, waxsim)",
             'Default: waxsim') do |driver|
              self[:driver] = driver.to_sym
        end
        
        o.on('--sdk [VERSION]',
             'Run the UISpec target against the iPhone SDK version',
             'Default: 4.0') do |sdk_version|
          self[:sdk_version] = sdk_version
        end                
        
        o.on('-c', '--configuration [CONFIGURATION]',
             'Build with specified XCode configuration.',
             'Default: Debug') do |configuration|
          self[:configuration] = configuration
        end
        
        o.on('-t', '--target [TARGET]',
             'Run the specified XCode target.',
             'Default: UISpec') do |target|
          self[:target] = target
        end
        
        o.on('--builddir [BUILD_DIR]',
             'Run app in the build directory.',
             'Default: ./build') do |build_dir|
          self[:build_dir] = build_dir
        end
        
        o.on('--securityd',
             'Start the securityd daemon before running specs. This allows interaction with the keychain.') do |securityd|
          self[:securityd] = securityd
        end
        
        o.on('--no-exit', 'Do not exit the process after running the specs') do |exit_on_finish|
          self[:exit_on_finish] = exit_on_finish
        end
        
        o.on('-S', '--skip-build', 'Do not build the app, just run the specs') do |skip_build|
          self[:skip_build] = skip_build
        end
        
        o.on('-v', '--[no-]verbose', "Run verbosely") do |v|
          self[:verbose] = v
        end
        
        o.on('-E', '--env [VARIABLE=VALUE]',
             'Specify an environment variable to pass to the application.') do |env|
          key, value = env.split('=')
          self[:env][key] = value
        end
        
        o.on('--version', 'Show version') do
          self[:command] = :version
        end
        
        o.on_tail('-h', '--help', 'Display this help and exit') do
          self[:command] = :help
        end
      end
      
      begin
        @opts.parse!(args)
        
        # Set default Scheme name if Workspace was provided
        if self[:workspace]
          self[:scheme] ||= 'UISpec'
        else
          self[:target] ||= 'UISpec'
        end
        # TODO: Support running specific files
      rescue OptionParser::InvalidOption => e
        self[:invalid_argument] = e.message
      end
    end
    
    def merge(other)
      self.class.new(@orig_args + other.orig_args)
    end
  end
end
