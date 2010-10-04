require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Terminal do

  before :each do
    @action = Terminal.new(["echo 'hello world!'"])
  end

  describe "#start" do
    it "launch a Terminal only if it isn't running already" do
      @action.start
      Terminal.caprese_application.should be_running
    end

    it "should run the script in the first windows" do
      # I don't know how to write a test for this!
    end

    after :each do
      Terminal.caprese_application.quit!
    end

  end

end