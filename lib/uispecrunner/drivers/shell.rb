require 'tmpdir'

class UISpecRunner
  class Drivers
    class Shell
      attr_reader :config
      
      def initialize(config)
        @config = config
      end
      
      def run_specs(env)
        if build_project!
          run_env = config.env.merge(env)
          run_env.merge!('DYLD_ROOT_PATH' => sdk_dir, 'IPHONE_SIMULATOR_ROOT' => sdk_dir, 'CFFIXED_USER_HOME' => Dir.tmpdir)
          puts "Setting environment variables: #{run_env.inspect}" if config.verbose?
          with_env(run_env) do
            start_securityd if config.securityd
            command = "#{config.build_dir}/#{config.configuration}-iphonesimulator/#{config.target}.app/#{config.target} -RegisterForSystemEvents"
            puts "Executing: #{command}" if config.verbose?
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
      
      def with_env(env)
        before = env.inject({}) { |h, (k, _)| h[k] = ENV[k]; h }
        env.each { |k, v| ENV[k] = v }
        yield
      ensure
        before.each { |k, v| ENV[k] = v }
      end

      def project_switch
        "-project #{config.project}" if config.project
      end

      def sdk_switch
        "-sdk #{sdk_dir}" if config.sdk_version
      end
      
      def sdk_dir
        "/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator#{config.sdk_version}.sdk"
      end

      def build_project!
        command = "xcodebuild #{project_switch} -target #{config.target} -configuration #{config.configuration} #{sdk_switch} > /dev/null"
        puts "Building project with: #{command}" if config.verbose?
        system(command)
      end
      
      def run_command(command)
        puts "Executing: #{command}" if config.verbose?
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
    end
  end
end
