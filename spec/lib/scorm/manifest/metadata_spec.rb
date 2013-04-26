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
  end
end
