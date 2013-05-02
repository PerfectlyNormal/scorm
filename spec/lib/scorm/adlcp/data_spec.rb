require 'spec_helper'
require 'scorm/errors'
require 'scorm/adlcp/data'
require 'scorm/adlcp/map'

describe Scorm::Adlcp::Data do
  describe ".from_xml" do
    it "returns nil if no XML data is given" do
      doc = xml_organization_item("").xpath("//adlcp:data")[0]
      Scorm::Adlcp::Data.from_xml(doc).should be_nil
    end

    it "should parse <adlcp:map> elements" do
      doc = xml_organization_item(<<-XML).xpath("//adlcp:data")[0]
        <adlcp:data>
          <adlcp:map targetID="somewhere"/>
          <adlcp:map targetID="somewhere-else"/>
        </adlcp:data>
      XML
      data = Scorm::Adlcp::Data.from_xml(doc)
      data.maps.should_not be_empty
      data.maps.size.should eq(2)
      data.maps[0].should be_a(Scorm::Adlcp::Map)
      data.maps[1].should be_a(Scorm::Adlcp::Map)
    end

    it "should throw an exception if no <adlcp:map> elements are found" do
      doc = xml_organization_item(<<-XML).xpath("//adlcp:data")[0]
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
      data.should_not be_valid

      data.maps.push(Scorm::Adlcp::Map.new(target_id: "somewhere"))
      data.should be_valid
    end
  end
end
