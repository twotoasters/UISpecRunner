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
      self[:target] = 'UISpec'
      self[:configuration] = 'Debug'
      self[:build_dir] = './build'
      self[:verbose] = false
      self[:sdk_version] = '3.0'
      
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
        
        o.on('--project [PROJECT_FILE]',
             'Run the UISpec target in specified project',
             'Default: auto-detect project in current directory') do |project|
          self[:project] = project
        end
        
        o.on('--sdk [VERSION]',
             'Run the UISpec target against the iPhone SDK version',
             'Default: 3.0') do |sdk_version|
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
             'Start the securityd daemon before running specs. This allow interaction with the keychain.') do |securityd|
          self[:securityd] = securityd
        end
        
        o.on('-v', '--[no-]verbose', "Run verbosely") do |v|
          self[:verbose] = v
        end
        
        o.on_tail('-h', '--help', 'display this help and exit') do
          self[:show_help] = true
        end
      end
      
      begin
        @opts.parse!(args)
        # TODO: Support running specific files
        #self[:project_name] = args.shift
      rescue OptionParser::InvalidOption => e
        self[:invalid_argument] = e.message
      end
    end
    
    def merge(other)
      self.class.new(@orig_args + other.orig_args)
    end
  end
end
