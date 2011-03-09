class UISpecRunner
  class XcodeBuilder
    attr_reader :config, :app_path
    
    def initialize(config)
      @config = config
    end
    
    def build!
      command = "xcodebuild #{workspace_switch} #{scheme_switch} #{project_switch} #{target_switch} -configuration #{config.configuration} #{sdk_switch}"
      puts "Building project with: #{command}" if config.verbose?
      status = Open4::popen4(command) do |pid, stdin, stdout, stderr|
        stdout.each_line do |line|
          if line =~ /^Touch\s/
            @app_path = line.split(/^Touch\s/).last.chomp
            puts "*** Found app path: #{self.app_path}" if config.verbose?
          end
          puts line if config.verbose?
        end
        
        stderr.each_line do |line|
          puts line
        end
      end
      puts "Exited with status: #{ status.exitstatus }" if config.verbose? || status.exitstatus != 0
      return status.exitstatus
    end
    
    private
      def workspace_switch
        "-workspace #{config.workspace}" if config.workspace
      end
      
      def scheme_switch
        "-scheme #{config.scheme}" if config.scheme
      end
      
      def project_switch
        "-project #{config.project}" if config.project
      end
      
      def target_switch
        "-target #{config.target}" if config.target
      end

      def sdk_switch
        "-sdk #{config.sdk_dir}" if config.sdk_version
      end
  end
end
