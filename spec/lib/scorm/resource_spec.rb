require 'spec_helper'
require 'scorm/resource'

describe Scorm::Resource do
  describe ".from_xml" do
    describe "with valid data" do
      let(:resource_doc) {
        xml_scorm_manifest("valid_resource").xpath("/xmlns:manifest/xmlns:resources/xmlns:resource")[0]
      }
      let(:resource) { Scorm::Resource.from_xml(resource_doc) }

      it "should set identifier" do
        resource.identifier.should eq("RES")
      end

      it "should set type" do
        resource.type.should eq("webcontent")
      end

      it "should set href" do
        resource.href.should eq("example.html")
      end

      it "should set adlcp:scormtype" do
        resource.adlcp_scormtype.should eq("sco")
      end

      it "should set xml:base" do
        resource.xml_base.should eq("http://localhost/")
      end

      it "should parse metadata"
      it "should parse files"
      it "should parse dependencies"
    end
  end
end
