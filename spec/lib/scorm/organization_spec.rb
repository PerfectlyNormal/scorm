require 'spec_helper'
require 'scorm/organization'

describe Scorm::Organization do
  let(:xml_source) { xml_scorm_manifest("one_organization") }
  let(:doc)        { xml_source.xpath("/xmlns:manifest/xmlns:organizations/xmlns:organization")[0] }

  describe ".from_xml" do
    it "reads the identifier" do
      Scorm::Organization.from_xml(doc).identifier.should eq("default_org")
    end

    it "reads the 'structure' attribute" do
      Scorm::Organization.from_xml(doc).structure.should eq("not-really-normal")
    end

    it "reads the 'adlseq:objectivesGlobalToSystem' attribute" do
      org = Scorm::Organization.from_xml(doc)
      org.adlseq_objectives_global_to_system.should be_false
    end

    it "reads the 'adlcp:sharedDataGlobalToSystem' attribute" do
      org = Scorm::Organization.from_xml(doc)
      org.adlcp_shared_data_global_to_system.should be_false
    end

    it "raises an exception if the identifier cannot be found" do
      src = xml_scorm_manifest("organization_without_identifier")
      no_identifier = src.xpath("//xmlns:organization")[0]
      expect {
        Scorm::Organization.from_xml(no_identifier)
      }.to raise_error(Scorm::Errors::InvalidManifest)
    end
  end

  it "defaults to 'hierarchical' for the structure attribute" do
    Scorm::Organization.new.structure.should eq("hierarchical")
  end

  it "defaults to 'true' for adlseq:objectivesGlobalToSystem" do
    Scorm::Organization.new.adlseq_objectives_global_to_system.should be_true
  end

  it "defaults to 'true' for adlcp:sharedDataGlobalToSystem" do
    Scorm::Organization.new.adlcp_shared_data_global_to_system.should be_true
  end
end
