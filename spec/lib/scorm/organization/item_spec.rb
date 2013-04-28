require 'spec_helper'
require 'scorm/organization'

describe Scorm::Organization::Item do
  describe ".from_xml" do
    let(:source) { xml_scorm_manifest("organization_item") }
    let(:doc)    { source.xpath("//xmlns:organization/xmlns:item")[0] }

    it "reads the identifier" do
      Scorm::Organization::Item.from_xml(doc).identifier.should eq("intro")
    end

    it "reads the 'identifierref' attribute" do
      Scorm::Organization::Item.from_xml(doc).identifierref.should eq("intro_resource")
    end

    it "reads the 'isvisible' attribute" do
      Scorm::Organization::Item.from_xml(doc).isvisible.should be_false
    end

    it "reads the 'parameters' attribute" do
      Scorm::Organization::Item.from_xml(doc).parameters.should eq("test=true")
    end

    describe "parsing child elements" do
      it "reads <title>"
      it "reads nested <item>s"
      it "reads <metadata>"
      it "reads <adlcp:timeLimitAction>"
      it "reads <adlcp:dataFromLMS>"
      it "reads <adlcp:completionThreshold>"
      it "reads <imsss:sequencing>"
      it "reads <adlnav:presentation>"
      it "reads <adlcp:data>"
    end
  end
end
