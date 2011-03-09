# UISpecRunner
### By Blake Watters <blake@twotoasters.com>
### [http://github.com/twotoasters/UISpecRunner]()

A flexible CLI test runner for use with the UISpec iOS BDD framework.

Install the gem and run: `uispec -h` for details.

## Requirements
To utilize the uispec utility, you must add the UISpecRunner category
to your project. This category provides support for running specs by
Protocol and provides a general environment variable based runner. The
category header and implementation file as well as a main.m are available
in the src/ directory with this gem. Use `gem edit uispecrunner` or pull
them from Github.

*NOTE* - Be sure you update your app delegate class in main.m if necessary.
Compare the call to `UIApplicationMain` from your normal app's main.m
to the spec runner. Example:
  `int retVal = UIApplicationMain(argc, argv, nil, @"MyAppDelegateClassHere");`

## Features
- Running all specs
- Running all specs in a class
- Running a specific spec class and method
- Switches for targeting different iOS SDK versions, project files, 
  configurations and targets
- Starting securityd daemon to allow interaction with the keychain
- Support for reading configuration settings from
- A Ruby API for configuring your own spec runners
- Will read common arguments from uispec.opts file for easy per project configuration
- Includes a sample Rakefile for running your UISpec's
- Support for setting arbitrary environment variables on the runner
- Builds project using xcodebuild
- Supports running specs via shell or AppleScript (osascript)

## TODO
- Run via WaxSim
- Simulator/device switch...
- Auto-detect SDK versions available
- Support for running specific files
- Generate a Kicker script
- Enabling Zombies (or other debugging flags, see http://code.google.com/p/google-toolbox-for-mac/source/browse/trunk/UnitTesting/RunIPhoneUnitTest.sh)

## Copyright

Copyright (c) 2010 Blake Watters. See LICENSE for details.
