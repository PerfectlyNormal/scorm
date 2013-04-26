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

    it "should raise an exception if no metadata element exists" do
      doc = xml_scorm_manifest("no_metadata")
      expect {
        Scorm::Manifest::Metadata.from_xml(doc.xpath("/xmlns:manifest/xmlns:metadata"))
      }.to raise_error(Scorm::Errors::NoMetadataError)
    end

    it "should raise an exception if there are more than one metadata element" do
      doc = xml_scorm_manifest("duplicate_metadata")
      expect {
        Scorm::Manifest::Metadata.from_xml(doc.xpath("/xmlns:manifest/xmlns:metadata"))
      }.to raise_error(Scorm::Errors::DuplicateMetadataError)
    end

    it "should not raise an exception when there is only one metadata element" do
      doc = xml_scorm_manifest("version_scorm_2004_4th")
      expect {
        Scorm::Manifest::Metadata.from_xml(doc.xpath("/xmlns:manifest/xmlns:metadata"))
      }.to_not raise_error(Scorm::Errors::InvalidManifest)
    end
  end

  describe "#validate!" do
    describe "with invalid data" do
      it "should raise an exception" do
        doc = xml_scorm_manifest("invalid_scorm_version")
        expect {
          Scorm::Manifest::Metadata.from_xml(doc.xpath("/xmlns:manifest/xmlns:metadata")).validate!
        }.to raise_error(Scorm::Errors::InvalidSCORMVersion)
      end
    end

    describe "with unsupported data" do
      it "should raise an exception" do
        doc = xml_scorm_manifest("version_scorm_1.2")
        expect {
         Scorm::Manifest::Metadata.from_xml(doc.xpath("/xmlns:manifest/xmlns:metadata")).validate!
        }.to raise_error(Scorm::Errors::UnsupportedSCORMVersion)
      end
    end
  end
end
