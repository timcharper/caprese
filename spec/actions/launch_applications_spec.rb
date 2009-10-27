require File.expand_path("../spec_helper", File.dirname(__FILE__))

describe LaunchApplications do
  describe "#validate" do
    it "is invalid if a non-existing application is provided" do
      action = LaunchApplications.new(["System Preferences", "Jooky - Party in a Can"])
      action.should_not be_valid
      action.errors.should include("I can't find application Jooky - Party in a Can installed in /Applications/Jooky - Party in a Can.app")
    end

    it "is valid if provided applications exist" do
      action = LaunchApplications.new(["System Preferences"])
      action.should be_valid
    end
  end
end