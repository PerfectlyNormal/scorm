require 'spec_helper'
require 'scorm/adlcp/time_limit_action'

describe Scorm::Adlcp::TimeLimitAction do
  describe ".from_xml" do
    it "returns nil if the selector returns 0 elements" do
      item = xml_organization_item("")
      Scorm::Adlcp::TimeLimitAction.from_xml(item.xpath("adlcp:timeLimitAction")).should be_nil
    end

    it "reads the action" do
      item = xml_organization_item("<adlcp:timeLimitAction>exit,no message</adlcp:timeLimitAction>")
      action = Scorm::Adlcp::TimeLimitAction.from_xml(item.xpath("adlcp:timeLimitAction"))
      action.should eq("exit,no message")
    end

    it "raises an error if more than one element is found" do
      item = xml_organization_item(
        "<adlcp:timeLimitAction>exit,no message</adlcp:timeLimitAction>
         <adlcp:timeLimitAction>exit,message</adlcp:timeLimitAction>"
      )
      expect {
        Scorm::Adlcp::TimeLimitAction.from_xml(item.xpath("adlcp:timeLimitAction"))
      }.to raise_error(Scorm::Errors::DuplicateItem)
    end
  end

  describe "#valid?" do
    it "should not be valid without an action" do
      Scorm::Adlcp::TimeLimitAction.new.should_not be_valid
    end

    ["exit,message", "exit,no message",
     "continue,message", "continue,no message"].each do |valid_state|
      it "should be valid with '#{valid_state}'" do
        Scorm::Adlcp::TimeLimitAction.new(action: valid_state).should be_valid
      end
    end

    it "should not be valid with a random string" do
      Scorm::Adlcp::TimeLimitAction.new(action: "continue,no exit").should_not be_valid
    end
  end
end
