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
      it "reads <title>" do
        Scorm::Organization::Item.from_xml(doc).title.should eq("Introduction")
      end

      describe "nested <item>s" do
        it "throws an error if the parent <item> has identifierref set" do
          doc     = xml_scorm_manifest("organization_item_with_nested_and_identifierref")
          itemsrc = doc.xpath("//xmlns:organization/xmlns:item")[0]

          expect {
            Scorm::Organization::Item.from_xml(itemsrc)
          }.to raise_error(Scorm::Errors::InvalidManifest)
        end

        it "reads nested items" do
          doc     = xml_scorm_manifest("organization_item_with_nested_items")
          itemsrc = doc.xpath("//xmlns:organization/xmlns:item")[0]
          item    = Scorm::Organization::Item.from_xml(itemsrc)

          item.items.should_not be_empty
          item.items.first.identifier.should eq("nested-item")
        end
      end

      it "reads <metadata>"

      it "reads <adlcp:timeLimitAction>" do
        Scorm::Organization::Item.from_xml(doc).adlcp_time_limit_action.should eq("exit,no message")
      end

      it "reads <adlcp:dataFromLMS>" do
        item = Scorm::Organization::Item.from_xml(doc)
        item.adlcp_data_from_lms.should eq("this will be passed along from the LMS")
      end

      it "reads <adlcp:completionThreshold>"
      it "reads <imsss:sequencing>"
      it "reads <adlnav:presentation>"

      it "reads <adlcp:data>" do
        item = Scorm::Organization::Item.from_xml(doc)
        item.adlcp_data.should_not be_nil
        item.adlcp_data.should be_a(Scorm::Adlcp::Data)
        item.adlcp_data.should be_valid
      end
    end
  end
end
