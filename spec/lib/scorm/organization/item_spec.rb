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

      it "throws an error if there is more than one <adlcp:dataFromLMS> element" do
        itemsrc = xml_organization_item(<<-XML)
          <title>My First Item</title>
          <adlcp:dataFromLMS>here's some data</adlcp:dataFromLMS>
          <adlcp:dataFromLMS>and some more, but this is not allowed!</adlcp:dataFromLMS>
        XML

        expect {
          Scorm::Organization::Item.from_xml(itemsrc)
        }.to raise_error(Scorm::Errors::DuplicateItem)
      end

      it "reads <adlcp:completionThreshold>" do
        item = Scorm::Organization::Item.from_xml(doc)
        item.adlcp_completion_threshold.should_not be_nil
        item.adlcp_completion_threshold.should be_a(Scorm::Adlcp::CompletionThreshold)
        item.adlcp_completion_threshold.should be_valid
      end

      it "throws an error if there is more than one <adlcp:completionThreshold> element" do
        itemsrc = xml_organization_item(<<-XML)
          <title>My First Item</title>
          <adlcp:completionThreshold progressWeight="0.5"/>
          <adlcp:completionThreshold/>
        XML

        expect {
          Scorm::Organization::Item.from_xml(itemsrc)
        }.to raise_error(Scorm::Errors::DuplicateItem)
      end

      it "reads <imsss:sequencing>"
      it "reads <adlnav:presentation>"

      it "reads <adlcp:data>" do
        item = Scorm::Organization::Item.from_xml(doc)
        item.adlcp_data.should_not be_nil
        item.adlcp_data.should be_a(Scorm::Adlcp::Data)
        item.adlcp_data.should be_valid
      end

      it "throws an error if there is more than one <adlcp:data> element" do
        itemsrc = xml_organization_item(<<-XML)
          <title>My First Item</title>
          <adlcp:data><adlcp:map targetID="somewhere"/></adlcp:data>
          <adlcp:data><adlcp:map targetID="nowhere"/></adlcp:data>
        XML

        expect {
          Scorm::Organization::Item.from_xml(itemsrc)
        }.to raise_error(Scorm::Errors::DuplicateItem)
      end
    end
  end
end
