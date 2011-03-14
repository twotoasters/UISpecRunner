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
      
      def run_specs(env)
        env_args = env.map { |k,v| "-e #{k}=#{v} "}.join(' ')
        # TODO: Add support for family...
        command = %Q{#{waxsim_path} -s #{config.sdk_version} #{env_args} "#{config.app_path}"}
        puts "Executing: #{command}"
        `#{command}`
      end
    end
  end
end
