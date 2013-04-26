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

      it "should set adlcp:scormType" do
        resource.adlcp_scorm_type.should eq("sco")
      end

      it "should set xml:base" do
        resource.xml_base.should eq("http://localhost/")
      end

      it "should parse metadata"
      it "should parse files"
      it "should parse dependencies"
    end
  end

  describe "#valid?" do
    let(:resource_doc) {
      xml_scorm_manifest("valid_resource").xpath("/xmlns:manifest/xmlns:resources/xmlns:resource")[0]
    }
    let(:resource) { Scorm::Resource.from_xml(resource_doc) }

    it "should start out valid" do
      resource.should be_valid
    end

    it "should require the identifier to be present" do
      resource.identifier = ""
      resource.should_not be_valid
    end

    it "should require the type to be present" do
      resource.type = ""
      resource.should_not be_valid
    end

    it "should not require href to be present" do
      resource.href = ""
      resource.should be_valid
    end

    it "should not require xml:base to be present" do
      resource.xml_base = ""
      resource.should be_valid
    end

    it "should require adlcp:scormType to be present" do
      resource.adlcp_scorm_type = ""
      resource.should_not be_valid
    end

    it "should require adlcp:scormType to be set to 'sco' or 'asset'" do
      resource.adlcp_scorm_type = "sco"
      resource.should be_valid

      resource.adlcp_scorm_type = "asset"
      resource.should be_valid

      resource.adlcp_scorm_type = "whatisthis"
      resource.should_not be_valid
    end

    # FIXME: The spec says that if an item references this resource,
    #        type should be set to 'webcontent'. But if it doesn't
    #        get referenced by an item, the spec as I read it lets
    #        the type have any value it wants, as long as it is an
    #        xs:string, with a SPM of 1000 characters.
    #        http://www.w3.org/TR/xmlschema-2/#string
    # it "should require the type to be set to 'webcontent'" do
    #   resource.type = "something-strange"
    #   resource.should_not be_valid
    # end
  end
end
