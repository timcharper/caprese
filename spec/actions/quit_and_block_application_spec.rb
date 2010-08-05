require File.expand_path("../spec_helper", File.dirname(__FILE__))

describe QuitAndBlockApplications do
  describe "#validate" do
    it "is invalid if a non-existing application is provided" do
      action = QuitAndBlockApplications.new(["System Preferences", "Jooky - Party in a Can"])
      action.should_not be_valid
      action.errors.first.should include("I can't find application Jooky - Party in a Can installed")
    end

    it "is valid if provided applications exist" do
      action = QuitAndBlockApplications.new(["System Preferences"])
      action.should be_valid
    end
  end
end