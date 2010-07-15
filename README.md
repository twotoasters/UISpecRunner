# UISpecRunner
### By Blake Watters <blake@twotoasters.com>

A flexible CLI test runner for use with the UISpec iOS BDD framework.
Requires support in the main.m file for your UISpec target.

Install the gem and run: `uispec -h` for details.

## Provides support for:
- Running all specs
- Running all specs in a class
- Running a specific spec class and method
- Switches for targeting different iOS SDK versions, project files, 
  configurations and targets
- Support for reading configuration settings from
- A Ruby API for configuring your own spec runners

## TODO
- Read options from uispec.opts
- Auto-detect SDK versions available
- Print build failure output
- Rake file template
- main.m file template

## Copyright

Copyright (c) 2010 Blake Watters. See LICENSE for details.
