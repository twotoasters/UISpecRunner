class UISpecRunner
  class Drivers
    class OSAScript
      attr_reader :config
      
      def initialize(config)
        @config = config
      end
      
      def run_specs(env)
        # Set the environment variables requested by the runner...
        env_definitions = env.map do |key, value|
          "my setEnvironmentVariable(\"#{key}\", \"#{value}\")"
        end.join("\n")
        
        script = <<-SCRIPT
        on deactivateEnvironmentVariable(variableName)
          
          tell application "Xcode"
        		tell active project document			
        			set executableName to name of executable of active target as string			
        			tell executable executableName

        				-- Check to see if the fallback path already exists				
        				set hasVariable to false as boolean

        				repeat with environmentVariable in environment variables					
        					if name of environmentVariable is equal to variableName then
        						set active of environmentVariable to no
      						end if
    						end repeat
    						
  						end tell -- executable
						end tell -- active project document
					end tell -- Xcode
					
        end deactivateEnvironmentVariable
        
        on setEnvironmentVariable(variableName, variableValue)

        	tell application "Xcode"
        		tell active project document			
        			set executableName to name of executable of active target as string			
        			tell executable executableName

        				-- Check to see if the fallback path already exists				
        				set hasVariable to false as boolean

        				repeat with environmentVariable in environment variables					
        					if name of environmentVariable is equal to variableName then						
        						-- Overwrite any value						
        						set value of environmentVariable to variableValue						
        						set active of environmentVariable to yes						
        						set hasVariable to true as boolean						
        						exit repeat						
        					end if					
        				end repeat

        				-- Since the fallback path doesn't exist yet, create it				
        				if not hasVariable then					
        					make new environment variable with properties {name:variableName, value:variableValue, active:yes}					
        				end if				
        			end tell -- executable			
        		end tell -- active project document		
        	end tell -- Xcode

        end setEnvironmentVariable

        application "iPhone Simulator" quit
--        application "iPhone Simulator" activate

        tell application "Xcode"
            set targetProject to project of active project document
        		#{env_definitions}

            tell targetProject
                set active build configuration type to build configuration type "Debug"
                set active SDK to "iphonesimulator4.0"
        				set the active target to the target named "UISpec"
--                set value of build setting "SDKROOT" of build configuration "Debug" of active target to "iphoneos4.0"

        				build targetProject
        				launch targetProject
        				
        				-- Clear out the environment variables
        				my deactivateEnvironmentVariable("UISPEC_PROTOCOL")
        				my deactivateEnvironmentVariable("UISPEC_SPEC")
        				my deactivateEnvironmentVariable("UISPEC_EXAMPLE")
            end tell
        end tell
        SCRIPT
        # puts "#{script}"
        # exit
        `osascript <<SCRIPT\n#{script}\nSCRIPT`
      end
    end
  end
end
