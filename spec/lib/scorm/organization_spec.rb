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

    describe "child elements" do
      it "reads <title>" do
        org = Scorm::Organization.from_xml(doc)
        org.title.should eq("Default Organization")
      end

      it "raises an error unless one, and only one, <title> element exists" do
        missing  = xml_scorm_manifest("untitled_organization").xpath("//xmlns:organization")[0]
        too_many = xml_scorm_manifest("wellnamed_organization").xpath("//xmlns:organization")[0]

        expect {
          Scorm::Organization.from_xml(missing)
        }.to raise_error(Scorm::Errors::RequiredItemMissing)

        expect {
          Scorm::Organization.from_xml(too_many)
        }.to raise_error(Scorm::Errors::DuplicateItem)
      end

      it "does not put an <item> nested in another <item> at the top level" do
        doc    = xml_scorm_manifest("organization_item_with_nested_items")
        orgsrc = doc.xpath("//xmlns:organization")[0]
        org    = Scorm::Organization.from_xml(orgsrc)

        org.items.should_not be_empty
        org.items.collect(&:identifier).should_not include("nested-item")
      end
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

  describe "equality" do
    it "should be equal if they have the same identifier" do
      org1 = Scorm::Organization.new
      org2 = Scorm::Organization.new

      org1.identifier = "default_org"
      org2.identifier = "default_org"

      org1.should eq(org2)
    end

    it "should not be equal if they have different identifiers" do
      org1 = Scorm::Organization.new
      org2 = Scorm::Organization.new

      org1.identifier = "default_org"
      org2.identifier = "alternate_org"

      org1.should_not eq(org2)
    end
  end

  describe "#valid?" do
    it "should be valid with an identifier" do
      org = Scorm::Organization.new(title: Scorm::Title.new(title: "Doesn't matter"))
      org.should_not be_valid

      org.identifier = "my-first-organization"
      org.should be_valid
    end

    it "should require a title" do
      org = Scorm::Organization.new(identifier: "doesntmatter")
      org.should_not be_valid

      org.title = Scorm::Title.new(title: "My first Organization")
      org.should be_valid
    end
  end
end
