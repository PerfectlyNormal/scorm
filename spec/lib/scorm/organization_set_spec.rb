require 'spec_helper'
require 'scorm/organization_set'

describe Scorm::OrganizationSet do
  let(:xml_source) { xml_scorm_manifest("two_organizations") }
  let(:doc)        { xml_source.xpath("/xmlns:manifest/xmlns:organizations") }

  describe ".from_xml" do
    it "reads the default attribute" do
      expect(Scorm::OrganizationSet.from_xml(doc).default).to eq("default_org")
    end

    it "throws an exception if the default attribute can't be found" do
      src = xml_scorm_manifest("organizations_without_default")
      org = src.xpath("//xmlns:organizations")
      expect {
        Scorm::OrganizationSet.from_xml(org)
      }.to raise_error(Scorm::Errors::InvalidManifest)
    end

    it "parses the child organizations" do
      set = Scorm::OrganizationSet.from_xml(doc)
      expect(set.organizations).not_to be_empty
      expect(set.organizations[0]).to be_a(Scorm::Organization)
      expect(set.organizations[1]).to be_a(Scorm::Organization)
      expect(set.organizations[0]).not_to eq(set.organizations[1])
    end
  end

  describe "#default_organization" do
    let(:set)  { Scorm::OrganizationSet.new }
    let(:org1) { Scorm::Organization.new(identifier: "default_org") }
    let(:org2) { Scorm::Organization.new(identifier: "alternate_org") }

    it "finds the right organization" do
      set.organizations.push(org1)
      set.organizations.push(org2)
      set.default = org2.identifier

      expect(set.default_organization).to eq(org2)
    end

    it "returns nil if it can't find the organization" do
      set.organizations.push(org1)
      set.organizations.push(org2)
      set.default = "third_org"

      expect(set.default_organization).to be_nil
    end
  end

  describe "#valid?" do
    describe "when the 'default' attribute is set" do
      it "is valid when the 'default' organization exists" do
        set = Scorm::OrganizationSet.new
        set.organizations.push(Scorm::Organization.new(identifier: "default_org"))
        set.default = "default_org"
        expect(set).to be_valid
      end

      it "is not valid when the default organization doesn't exist" do
        set = Scorm::OrganizationSet.new(default: "default_org")
        expect(set).not_to be_valid
      end
    end

    describe "when the 'default' attribute is not set" do
      it "is not valid" do
        set = Scorm::OrganizationSet.new
        set.default = nil
        expect(set).not_to be_valid
      end
    end
  end
end
