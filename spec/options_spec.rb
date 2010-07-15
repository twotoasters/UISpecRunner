require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UISpecRunner::Options do
  it "should set the command to run_protocol" do
    options = UISpecRunner::Options.new('-p UISpecIntegration')
    options[:command].should == :run_protocol
  end
end
