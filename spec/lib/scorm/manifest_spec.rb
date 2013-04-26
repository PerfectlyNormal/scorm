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
      }.to_not raise_error(Scorm::Errors::UnsupportedSCORMVersion)
    end

    it "should correctly read the supported version" do
      manifest = Scorm::Manifest.parse(scorm_manifest("version_scorm_2004_4th"))
      manifest.schema.should eq("ADL SCORM")
      manifest.schemaversion.should eq("2004 4th Edition")
    end
  end

  it "should parse each defined resource" do
    manifest = Scorm::Manifest.parse(scorm_manifest("valid_resource"))
    manifest.resources.should_not be_empty
    manifest.resources.length.should eq(1)
    manifest.resources[0].should be_a(Scorm::Resource)
  end

  it "should parse each defined organization" do
    manifest = Scorm::Manifest.parse(scorm_manifest("one_organization"))
    manifest.organizations.should_not be_empty
    manifest.organizations.length.should eq(1)
    manifest.organizations[0].should be_a(Scorm::Organization)
  end
end
