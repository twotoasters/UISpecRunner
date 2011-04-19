require 'tmpdir'

class UISpecRunner
  class Drivers
    class Shell
      attr_reader :config
      
      def initialize(config)
        @config = config
      end
      
      def run_specs(env)
        run_env = config.env.merge(env)
        run_env.merge!('DYLD_ROOT_PATH' => config.sdk_dir, 'IPHONE_SIMULATOR_ROOT' => config.sdk_dir, 'CFFIXED_USER_HOME' => Dir.tmpdir)
        puts "Setting environment variables: #{run_env.inspect}" if config.verbose?
        with_env(run_env) do
          start_securityd if config.securityd
          command = "#{config.app_executable_path} -RegisterForSystemEvents"
          puts "Executing: #{command}" if config.verbose?
          output = `#{command}`
          return $?
        end        
      end
      
      def with_env(env)
        before = env.inject({}) { |h, (k, _)| h[k] = ENV[k]; h }
        env.each { |k, v| ENV[k] = v }
        yield
      ensure
        before.each { |k, v| ENV[k] = v }
      end
      
      def run_command(command)
        puts "Executing: #{command}" if config.verbose?
        system(command)
      end

      def path_to_securityd
        "#{config.sdk_dir}/usr/libexec/securityd"
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
    end
  end
end
