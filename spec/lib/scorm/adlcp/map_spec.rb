require 'spec_helper'
require 'scorm/adlcp/map'

describe Scorm::Adlcp::Map do
  describe ".from_xml" do
    let(:item) { xml_organization_item(<<-XML) }
                  <adlcp:data><adlcp:map targetID="somewhere"
                                         readSharedData="false"
                                         writeSharedData="false" /></adlcp:data>
                XML
    let(:map) { item.xpath("//adlcp:map")[0] }

    it "reads the targetID" do
      Scorm::Adlcp::Map.from_xml(map).target_id.should eq("somewhere")
    end

    it "raises an exception if targetID is missing" do
      map = xml_organization_item(<<-XML).xpath("//adlcp:map")[0]
        <adlcp:data><adlcp:map /></adlcp:data>
      XML

      expect {
        Scorm::Adlcp::Map.from_xml(map)
      }.to raise_error(Scorm::Errors::InvalidManifest)
    end

    it "reads readSharedData" do
      Scorm::Adlcp::Map.from_xml(map).read_shared_data.should be_false
    end

    it "reads writeSharedData" do
      Scorm::Adlcp::Map.from_xml(map).write_shared_data.should be_false
    end
  end

  describe "default values" do
    it "defaults readSharedData to true" do
      Scorm::Adlcp::Map.new.read_shared_data.should be_true
    end

    it "defaults writeSharedData to true" do
      Scorm::Adlcp::Map.new.write_shared_data.should be_true
    end
  end

  describe "#valid?" do
    it "is not valid without a targetID" do
      Scorm::Adlcp::Map.new.should_not be_valid
    end

    it "is valid with a targetID" do
      Scorm::Adlcp::Map.new(target_id: "somewhere").should be_valid
    end

    it "is not valid if the targetID is just whitespace" do
      Scorm::Adlcp::Map.new(target_id: "   ").should_not be_valid
    end
  end
end
