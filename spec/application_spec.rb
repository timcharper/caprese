require File.expand_path("spec_helper", File.dirname(__FILE__))

describe Application do
  describe "#running?, #activate!, and #quit!" do
    it "detects if an application is running" do
      app = Application.new("Calculator")
      app.activate!
      sleep 0.5
      app.running?.should be_true
      app.quit!
      sleep 0.5
      app.running?.should be_false
    end
  end
end