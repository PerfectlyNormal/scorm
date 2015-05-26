require 'spec_helper'
require 'scorm/errors'
require 'scorm/adlcp/data'
require 'scorm/adlcp/map'

describe Scorm::Adlcp::Data do
  describe ".from_xml" do
    it "returns nil if no XML data is given" do
      doc = xml_organization_item("").xpath("//adlcp:data")[0]
      expect(Scorm::Adlcp::Data.from_xml(doc)).to be_nil
    end

    it "should parse <adlcp:map> elements" do
      doc = xml_organization_item(<<-XML).xpath("//adlcp:data")
        <adlcp:data>
          <adlcp:map targetID="somewhere"/>
          <adlcp:map targetID="somewhere-else"/>
        </adlcp:data>
      XML
      data = Scorm::Adlcp::Data.from_xml(doc)
      expect(data.maps).not_to be_empty
      expect(data.maps.size).to eq(2)
      expect(data.maps[0]).to be_a(Scorm::Adlcp::Map)
      expect(data.maps[1]).to be_a(Scorm::Adlcp::Map)
    end

    it "should throw an exception if no <adlcp:map> elements are found" do
      doc = xml_organization_item(<<-XML).xpath("//adlcp:data")
        <adlcp:data></adlcp:data>
      XML

      expect {
        Scorm::Adlcp::Data.from_xml(doc)
      }.to raise_error(Scorm::Errors::RequiredItemMissing)
    end
  end

  describe "#valid?" do
    it "should not be valid without at least one <adlcp:map>" do
      data = Scorm::Adlcp::Data.new
      expect(data).not_to be_valid

      data.maps.push(Scorm::Adlcp::Map.new(target_id: "somewhere"))
      expect(data).to be_valid
    end
  end
end
