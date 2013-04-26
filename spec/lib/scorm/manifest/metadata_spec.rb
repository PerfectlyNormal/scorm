require 'spec_helper'
require 'scorm/manifest'

describe Scorm::Manifest::Metadata do
  describe ".from_xml" do
    it "reads the important bits" do
      doc = xml_scorm_manifest("version_scorm_2004_4th")
      metadata = Scorm::Manifest::Metadata.from_xml(doc.xpath("/xmlns:manifest/xmlns:metadata"))
      metadata.schema.should eq("ADL SCORM")
      metadata.schemaversion.should eq("2004 4th Edition")
    end

    it "returns an invalid instance if given invalid or no input" do
      doc = xml_scorm_manifest("no_metadata")
      metadata = Scorm::Manifest::Metadata.from_xml(doc.xpath("/xmlns:manifest/xmlns:metadata"))
      metadata.schema.should eq("")
      metadata.schemaversion.should eq("")
      metadata.valid?.should be_false
    end
  end

  describe "#validate!" do
    describe "with invalid data" do
      it "should raise an exception" do
        doc = xml_scorm_manifest("invalid_scorm_version")
        expect {
          Scorm::Manifest::Metadata.from_xml(doc.xpath("/xmlns:manifest/xmlns:metadata")).validate!
        }.to raise_error(Scorm::Manifest::InvalidSCORMVersion)
      end
    end

    describe "with unsupported data" do
      it "should raise an exception" do
        doc = xml_scorm_manifest("version_scorm_1.2")
        expect {
         Scorm::Manifest::Metadata.from_xml(doc.xpath("/xmlns:manifest/xmlns:metadata")).validate!
        }.to raise_error(Scorm::Manifest::UnsupportedSCORMVersion)
      end
    end
  end
end
