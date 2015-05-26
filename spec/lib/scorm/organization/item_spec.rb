require 'spec_helper'
require 'scorm/organization'

describe Scorm::Organization::Item do
  describe ".from_xml" do
    let(:source) { xml_scorm_manifest("organization_item") }
    let(:doc)    { source.xpath("//xmlns:organization/xmlns:item")[0] }

    it "reads the identifier" do
      expect(Scorm::Organization::Item.from_xml(doc).identifier).to eq("intro")
    end

    it "reads the 'identifierref' attribute" do
      expect(Scorm::Organization::Item.from_xml(doc).identifierref).to eq("intro_resource")
    end

    it "reads the 'isvisible' attribute" do
      expect(Scorm::Organization::Item.from_xml(doc).isvisible).to be_falsey
    end

    it "reads the 'parameters' attribute" do
      expect(Scorm::Organization::Item.from_xml(doc).parameters).to eq("test=true")
    end

    describe "parsing child elements" do
      it "reads <title>" do
        expect(Scorm::Organization::Item.from_xml(doc).title).to eq("Introduction")
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

          expect(item.items).not_to be_empty
          expect(item.items.first.identifier).to eq("nested-item")
        end
      end

      it "reads <metadata>"

      it "reads <adlcp:timeLimitAction>" do
        expect(Scorm::Organization::Item.from_xml(doc).adlcp_time_limit_action).to eq("exit,no message")
      end

      it "reads <adlcp:dataFromLMS>" do
        item = Scorm::Organization::Item.from_xml(doc)
        expect(item.adlcp_data_from_lms).to eq("this will be passed along from the LMS")
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
        expect(item.adlcp_completion_threshold).not_to be_nil
        expect(item.adlcp_completion_threshold).to be_a(Scorm::Adlcp::CompletionThreshold)
        expect(item.adlcp_completion_threshold).to be_valid
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
        expect(item.adlcp_data).not_to be_nil
        expect(item.adlcp_data).to be_a(Scorm::Adlcp::Data)
        expect(item.adlcp_data).to be_valid
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
