require 'spec_helper'
require 'scorm/manifest'

describe Scorm::Manifest do
  describe ".parse" do
    it "should raise an exception when given an empty string" do
      expect { Scorm::Manifest.parse("") }.to raise_error(Scorm::Errors::InvalidManifest)
      expect { Scorm::Manifest.parse(" ") }.to raise_error(Scorm::Errors::InvalidManifest)
    end

    it "should raise an exception when given nil" do
      expect { Scorm::Manifest.parse(nil) }.to raise_error(Scorm::Errors::InvalidManifest)
    end
  end

  describe "supported versions" do
    it "should raise an exception when given an unsupported version" do
      expect {
        Scorm::Manifest.parse(scorm_manifest("version_scorm_1.2"))
      }.to raise_error(Scorm::Errors::UnsupportedSCORMVersion)

      expect {
        Scorm::Manifest.parse(scorm_manifest("version_scorm_2004_3rd"))
      }.to raise_error(Scorm::Errors::UnsupportedSCORMVersion)
    end

    it "should not raise an exception when given a supported version" do
      expect {
        Scorm::Manifest.parse(scorm_manifest("version_scorm_2004_4th"))
      }.to_not raise_error
    end

    it "should correctly read the supported version" do
      manifest = Scorm::Manifest.parse(scorm_manifest("version_scorm_2004_4th"))
      expect(manifest.schema).to eq("ADL SCORM")
      expect(manifest.schemaversion).to eq("2004 4th Edition")
    end
  end

  it "should parse each defined resource" do
    manifest = Scorm::Manifest.parse(scorm_manifest("valid_resource"))
    expect(manifest.resources).not_to be_empty
    expect(manifest.resources.length).to eq(1)
    expect(manifest.resources[0]).to be_a(Scorm::Resource)
  end

  describe "the organization set" do
    it "should be parsed" do
      manifest = Scorm::Manifest.parse(scorm_manifest("one_organization"))
      expect(manifest.organization_set).not_to be_nil
    end

    it "should throw an exception if no organization set was found" do
      expect {
        Scorm::Manifest.parse(scorm_manifest("no_organizations"))
      }.to raise_error(Scorm::Errors::NoOrganizationsError)
    end

    it "should throw an exception if more than one organization set was found" do
      expect {
        Scorm::Manifest.parse(scorm_manifest("too_many_organizations"))
      }.to raise_error(Scorm::Errors::DuplicateOrganizationsError)
    end

    it "should delegate organization queries here" do
      manifest = Scorm::Manifest.parse(scorm_manifest("one_organization"))
      expect(manifest.organizations).not_to be_empty
      expect(manifest.organizations.length).to eq(1)
      expect(manifest.organizations[0]).to be_a(Scorm::Organization)
    end
  end
end
