require File.expand_path("spec_helper", File.dirname(__FILE__))

describe CapreseAction do
  describe ".config_schema" do
    context "[String]" do
      before(:each) do
        @klass = Class.new(CapreseAction) do
          config_schema [String]
        end
      end

      it "causes splatted args to be unfolded" do
        @klass.new([["a", "b"]]).config.should == ["a", "b"]
      end

      it "takes an array" do
        @klass.new(["a", "b"]).config.should == ["a", "b"]
      end
    end

    context "{...}" do
      before(:each) do
        @klass = Class.new(CapreseAction) do
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

  describe "#validate" do
    context "schema is [String]" do
      before(:each) do
        @klass = Class.new(CapreseAction) do
          config_schema [String]
        end
      end

      it "fails if all items aren't strings" do
        action = @klass.new([1, 2])
        action.should_not be_valid
        action.errors.should include("config expects an array of strings, got [1, 2]")
      end
    end

    context "schema is {String => String}" do
      before(:each) do
        @klass = Class.new(CapreseAction) do
          config_schema({String => String})
        end
      end

      it "fails if you provide an array instead of a hash" do
        action = @klass.new([1, 2])
        action.should_not be_valid
        action.errors.should include("config expects a Hash, got a(n) Array instead")
      end

      it "fails if all keys aren't strings" do
        action = @klass.new({:a => "1", "b" => "2"})
        action.should_not be_valid
        action.errors.should include("key :a expected to be of type String, but is of type Symbol")
      end

      it "fails if all values aren't strings" do
        action = @klass.new({"a" => :value, "b" => "2"})
        action.should_not be_valid
        action.errors.should include("key \"a\" expects a value of type String, but you provided :value of type Symbol")
      end
    end

    context "schema is {:message => String, :credentials => {:name => String, :pass => String}}" do
      before(:each) do
        @klass = Class.new(CapreseAction) do
          config_schema({:message => String, :credentials => {:name => String, :pass => String}})
        end
      end

      it "fails if you provide an array instead of a hash" do
        action = @klass.new([1, 2])
        action.should_not be_valid
        action.errors.should include("config expects a Hash, got a(n) Array instead")
      end

      it "is valid if the keys are missing" do
        action = @klass.new({})
        action.should be_valid
      end

      it "fails if an invalid key is specified in the outer hash" do
        action = @klass.new({:boo => "hi"})
        action.should_not be_valid
        action.errors.should include("Unexpected key :boo provided. Valid keys here are [:credentials, :message]")
      end

      it "fails if an invalid key is specified in the inner hash" do
        action = @klass.new({:credentials => {:boo => "hi"}})
        action.should_not be_valid
        action.errors.should include("Unexpected key :boo provided. Valid keys here are [:name, :pass]")
      end

      it "fails if a value doesn't match the specification" do
        action = @klass.new({:message => :hi})
        action.should_not be_valid
        action.errors.should include("key :message expects a value of type String, but you provided :hi of type Symbol")
      end

      it "passes if the value does match the specification" do
        action = @klass.new({:message => "hello world", :credentials => {:name => "Tim", :pass => "secret"}})
        action.should be_valid
      end

      it "fails if you provide a value where a nested hash is expected" do
        action = @klass.new({:credentials => :hi})
        action.should_not be_valid
        action.errors.should include("key :credentials expects a nested Hash of values, but you provided :hi")
      end
    end
  end
end
