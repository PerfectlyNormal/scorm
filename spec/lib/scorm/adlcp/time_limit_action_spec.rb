require 'spec_helper'
require 'scorm/adlcp/time_limit_action'

def base_item(contents)
  src = <<-XML
    <?xml version="1.0" encoding="utf-8" standalone="no"?>
    <manifest identifier="one-organization" version="1"
            xmlns="http://www.imsglobal.org/xsd/imscp_v1p1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_v1p3"
            xmlns:adlseq="http://www.adlnet.org/xsd/adlseq_v1p3"
            xmlns:adlnav="http://www.adlnet.org/xsd/adlnav_v1p3"
            xmlns:imsss="http://www.imsglobal.org/xsd/imsss"
            xsi:schemaLocation="http://www.imsglobal.org/xsd/imscp_v1p1 imscp_v1p1.xsd
                                http://www.adlnet.org/xsd/adlcp_v1p3 adlcp_v1p3.xsd
                                http://www.adlnet.org/xsd/adlseq_v1p3 adlseq_v1p3.xsd
                                http://www.adlnet.org/xsd/adlnav_v1p3 adlnav_v1p3.xsd
                                http://www.imsglobal.org/xsd/imsss imsss_v1p0.xsd">
    <metadata>
      <schema>ADL SCORM</schema>
      <schemaversion>2004 4th Edition</schemaversion>
    </metadata>
    <organizations default="default_org">
      <organization identifier="default_org"
                    structure="not-really-normal"
                    adlseq:objectivesGlobalToSystem="false"
                    adlcp:sharedDataGlobalToSystem="false">
        <title>Default Organization</title>
        <item identifier="intro" identifierref="some-resource">
          #{contents}
        </item>
      </organization>
    </organizations>
    </manifest>
  XML
  doc = Nokogiri::XML(src)
  doc.xpath("//xmlns:item")
end

describe Scorm::Adlcp::TimeLimitAction do
  describe ".from_xml" do
    it "returns nil if the selector returns 0 elements" do
      item = base_item("")
      Scorm::Adlcp::TimeLimitAction.from_xml(item.xpath("adlcp:timeLimitAction")).should be_nil
    end

    it "reads the action" do
      item = base_item("<adlcp:timeLimitAction>exit,no message</adlcp:timeLimitAction>")
      action = Scorm::Adlcp::TimeLimitAction.from_xml(item.xpath("adlcp:timeLimitAction"))
      action.should eq("exit,no message")
    end

    it "raises an error if more than one element is found" do
      item = base_item(
        "<adlcp:timeLimitAction>exit,no message</adlcp:timeLimitAction>
         <adlcp:timeLimitAction>exit,message</adlcp:timeLimitAction>"
      )
      expect {
        Scorm::Adlcp::TimeLimitAction.from_xml(item.xpath("adlcp:timeLimitAction"))
      }.to raise_error(Scorm::Errors::InvalidManifest)
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
