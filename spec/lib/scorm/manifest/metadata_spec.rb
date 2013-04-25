require 'spec_helper'
require 'scorm/manifest'

describe Scorm::Manifest::Metadata do
  describe ".from_xml" do
    it "reads the important bits" do
      doc = Nokogiri::XML(scorm_manifest("version_scorm_2004_4th"), "utf-8") { |config| config.nonet }
      metadata = Scorm::Manifest::Metadata.from_xml(doc.xpath("/xmlns:manifest/xmlns:metadata"))
      metadata.schema.should eq("ADL SCORM")
      metadata.schemaversion.should eq("2004 4th Edition")
    end
  end
end
