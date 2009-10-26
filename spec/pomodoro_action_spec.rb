require File.expand_path("spec_helper", File.dirname(__FILE__))

describe PomodoroAction do
  describe ".config_schema" do
    context "[String]" do
      before(:each) do
        @klass = Class.new(PomodoroAction) do
          config_schema [String]
          def self.to_s; "DummyClass"; end
        end
      end

      it "causes splatted args to be unfolded" do
        @klass.new([["a", "b"]]).config.should == ["a", "b"]
      end

      it "takes an array" do
        @klass.new(["a", "b"]).config.should == ["a", "b"]
      end

      it "raises if an items aren't strings" do
        running do
          @klass.new([1, 2])
        end.should raise_error(RuntimeError, "DummyClass expects an array of strings")
      end
    end

    context "{...}" do
      before(:each) do
        @klass = Class.new(PomodoroAction) do
          config_schema({String => Object})
        end
      end

      it "takes a hash" do
        @klass.new({:param => 1}).config.should == {:param => 1}
      end

      it "unfolds a splat" do
        @klass.new([{:param => 1}]).config.should == {:param => 1}
      end
    end
  end
end