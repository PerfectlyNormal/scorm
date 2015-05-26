require 'spec_helper'
require 'scorm/adlcp/data_from_lms'

describe Scorm::Adlcp::DataFromLMS do
  describe ".from_xml" do
    it "should return nil if the element doesn't exist" do
      item = xml_organization_item("")
      Scorm::Adlcp::DataFromLMS.from_xml(item.xpath("adlcp:dataFromLMS")).should be_nil
    end

    it "should raise an error if more than one element exists" do
      item = xml_organization_item(
        "<adlcp:dataFromLMS>some data here</adlcp:dataFromLMS>
         <adlcp:dataFromLMS>and more data here!?</adlcp:dataFromLMS>"
      )
      expect {
        Scorm::Adlcp::DataFromLMS.from_xml(item.xpath("adlcp:dataFromLMS"))
      }.to raise_error(Scorm::Errors::DuplicateItem)
    end

    it "should read the contents" do
      item = xml_organization_item(
        "<adlcp:dataFromLMS>some data here</adlcp:dataFromLMS>")
      Scorm::Adlcp::DataFromLMS.from_xml(item.xpath("adlcp:dataFromLMS")).data.should eq("some data here")
    end
  end
end
