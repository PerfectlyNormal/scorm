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
        expect(resource.identifier).to eq("RES")
      end

      it "should set type" do
        expect(resource.type).to eq("webcontent")
      end

      it "should set href" do
        expect(resource.href).to eq("example.html")
      end

      it "should set adlcp:scormType" do
        expect(resource.adlcp_scorm_type).to eq("sco")
      end

      it "should set xml:base" do
        expect(resource.xml_base).to eq("http://localhost/")
      end

      it "should parse metadata"
      describe "parsing files" do
        let(:resource_doc) {
          xml_scorm_manifest("resource_with_dependencies").xpath(
            "/xmlns:manifest/xmlns:resources/xmlns:resource"
          )[0]
        }
        let(:resource) { Scorm::Resource.from_xml(resource_doc) }

        it "should have 2 files" do
          expect(resource.files).not_to be_empty
          expect(resource.files.length).to eq(2)
        end

        it "should have been parsed correctly" do
          hrefs = resource.files.collect(&:href)
          expect(hrefs).to include("example.html")
          expect(hrefs).to include("example.jpg")
        end
      end

      describe "parsing dependencies" do
        let(:resource_doc) {
          xml_scorm_manifest("resource_with_dependencies").xpath(
            "/xmlns:manifest/xmlns:resources/xmlns:resource"
          )[0]
        }
        let(:resource) { Scorm::Resource.from_xml(resource_doc) }

        it "should have 1 dependency" do
          expect(resource.dependencies).not_to be_empty
          expect(resource.dependencies.length).to eq(1)
        end

        it "should have been parsed correctly" do
          expect(resource.dependencies[0].identifierref).to eq("assets")
        end

      end
    end
  end

  describe "#valid?" do
    let(:resource_doc) {
      xml_scorm_manifest("valid_resource").xpath("/xmlns:manifest/xmlns:resources/xmlns:resource")[0]
    }
    let(:resource) { Scorm::Resource.from_xml(resource_doc) }

    it "should start out valid" do
      expect(resource).to be_valid
    end

    it "should require the identifier to be present" do
      resource.identifier = ""
      expect(resource).not_to be_valid
    end

    it "should require the type to be present" do
      resource.type = ""
      expect(resource).not_to be_valid
    end

    it "should not require href to be present" do
      resource.href = ""
      expect(resource).to be_valid
    end

    it "should not require xml:base to be present" do
      resource.xml_base = ""
      expect(resource).to be_valid
    end

    it "should require adlcp:scormType to be present" do
      resource.adlcp_scorm_type = ""
      expect(resource).not_to be_valid
    end

    it "should require adlcp:scormType to be set to 'sco' or 'asset'" do
      resource.adlcp_scorm_type = "sco"
      expect(resource).to be_valid

      resource.adlcp_scorm_type = "asset"
      expect(resource).to be_valid

      resource.adlcp_scorm_type = "whatisthis"
      expect(resource).not_to be_valid
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

    describe "with dependencies" do
      it "should only be valid if the dependencies are valid"
    end

    describe "with files" do
      it "should only be valid if the files is valid"
    end
  end
end
