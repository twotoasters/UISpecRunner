class UISpecRunner
  class Options < Hash
    attr_reader :opts, :orig_args
    
    def initialize(args)
      super()
      
      @orig_args = args.clone
      
      self[:target] = 'UISpec'
      self[:configuration] = 'Debug'
      self[:build_dir] = './build'
      
      require 'optparse'
      @opts = OptionParser.new do |o|
        o.banner = "Usage: #{File.basename($0)} [options]\ne.g. #{File.basename($0)}"
        
        # Configure default settings
        self[:run_mode] = :all
        self[:target] = 'UISpec'
        self[:configuration] = 'Debug'
        self[:build_dir] = './build'
        self[:verbose] = false
        
        o.separator ""
        o.separator "Run Modes:"
        
        o.on('-c', '--class [CLASS]', 'Run the specified UISpec class') do |class_name|
          self[:class_name] = class_name
          self[:run_mode] = :class
        end
        
        o.on('-m', '--method [METHOD]', 'Run the specified spec method') do |method|
          self[:method_name] = method
          self[:run_mode] = :class
          # TODO: Need to raise exception if method is specified without class
        end
        
        o.on('-p', '--protocol [PROTOCOL]', 'Run all UISpec classes implementing the Objective-C protocol') do |protocol|
          self[:protocol_name] = protocol
          self[:run_mode] = :protocol
        end
        
        o.separator ""
        o.separator "Environment options:"
        
        o.on('--project [PROJECT_FILE]', 'Run the UISpec target in specified project') do |project|
          self[:project] = project
        end
        
        o.on('--sdk [VERSION]',
             'Run the UISpec target against the iPhone SDK version',
             'Default: 3.0') do |sdk_version|
          self[:sdk_version] = sdk_version
        end                
        
        o.on('--configuration [CONFIGURATION]',
             'Build with specified XCode configuration.',
             'Default: Debug') do |configuration|
          self[:configuration] = configuration
        end
        
        o.on('--target [TARGET]',
             'Run the specified XCode target.',
             'Default: UISpec') do |target|
          self[:target] = target
        end
        
        o.on('--builddir [BUILD_DIR]',
             'Run app in the build directory.',
             'Default: ./build') do |build_dir|
          self[:build_dir] = build_dir
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
  end
end
