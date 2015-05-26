require 'spec_helper'
require 'scorm/adlcp/time_limit_action'

describe Scorm::Adlcp::TimeLimitAction do
  describe ".from_xml" do
    it "returns nil if the selector returns 0 elements" do
      item = xml_organization_item("")
      expect(Scorm::Adlcp::TimeLimitAction.from_xml(item.xpath("adlcp:timeLimitAction"))).to be_nil
    end

    it "reads the action" do
      item = xml_organization_item("<adlcp:timeLimitAction>exit,no message</adlcp:timeLimitAction>")
      action = Scorm::Adlcp::TimeLimitAction.from_xml(item.xpath("adlcp:timeLimitAction"))
      expect(action).to eq("exit,no message")
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
      expect(Scorm::Adlcp::TimeLimitAction.new).not_to be_valid
    end

    ["exit,message", "exit,no message",
     "continue,message", "continue,no message"].each do |valid_state|
      it "should be valid with '#{valid_state}'" do
        expect(Scorm::Adlcp::TimeLimitAction.new(action: valid_state)).to be_valid
      end
    end

    it "should not be valid with a random string" do
      expect(Scorm::Adlcp::TimeLimitAction.new(action: "continue,no exit")).not_to be_valid
    end
  end
end
