require 'tmpdir'

class UISpecRunner
  class Drivers
    class WaxSim
      WAXSIM_BIN_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'ext', 'bin'))
      
      attr_reader :config
      
      def initialize(config)
        @config = config
      end
      
      def waxsim_path
        File.join(WAXSIM_BIN_DIR, 'waxsim')
      end
      
      def family_switch
        "-f #{config.family}" if config.family
      end
      
      def run_specs(env)
        env_args = env.map { |k,v| "-e #{k}=#{v} "}.join(' ')
        exit_status = nil
        command = %Q{#{waxsim_path} -s #{config.sdk_version} #{family_switch} #{env_args} "#{config.app_path}"}
        puts "Executing command: #{command}" if config.verbose?
        `#{command}`
        
        # TODO: Total hack. Can't figure out how to get the exit status any other way.
        # WaxSim can't get the child pid because the process isn't forked as a child. The output
        # can't be parsed directly because of funkiness with the file descriptors. Better ideas?
        exit_status = `tail /var/log/system.log| grep "Exiting with status code:"`.split(/code\:\s/).last.to_i
        
        return exit_status
      end
    end
  end
end
