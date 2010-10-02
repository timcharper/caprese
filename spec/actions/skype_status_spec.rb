require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SkypeStatus do

  before :each do
    @action = SkypeStatus.new(
                :away => "Pomodoro! Ends",
                :available => "Available"
              )
  end

  # spces are commented as Skype needs to be running
  describe "status update" do
    it "can set status to Do Not Disturb when pomodoro starts" do
#      @action.start
    end

    it "can set status to online when pomodoro ends" do
#      @action.stop
    end
  end

end