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
      expect(Scorm::Adlcp::Map.from_xml(map).target_id).to eq("somewhere")
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
      expect(Scorm::Adlcp::Map.from_xml(map).read_shared_data).to be_falsey
    end

    it "reads writeSharedData" do
      expect(Scorm::Adlcp::Map.from_xml(map).write_shared_data).to be_falsey
    end
  end

  describe "default values" do
    it "defaults readSharedData to true" do
      expect(Scorm::Adlcp::Map.new.read_shared_data).to be_truthy
    end

    it "defaults writeSharedData to true" do
      expect(Scorm::Adlcp::Map.new.write_shared_data).to be_truthy
    end
  end

  describe "#valid?" do
    it "is not valid without a targetID" do
      expect(Scorm::Adlcp::Map.new).not_to be_valid
    end

    it "is valid with a targetID" do
      expect(Scorm::Adlcp::Map.new(target_id: "somewhere")).to be_valid
    end

    it "is not valid if the targetID is just whitespace" do
      expect(Scorm::Adlcp::Map.new(target_id: "   ")).not_to be_valid
    end
  end
end
