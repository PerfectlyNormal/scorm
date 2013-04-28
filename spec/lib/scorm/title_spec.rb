require 'spec_helper'
require 'scorm/title'

describe Scorm::Title do
  let(:xml_source) { xml_scorm_manifest("one_organization") }
  let(:doc)        { xml_source.xpath("//xmlns:organization/xmlns:title") }

  it "reads <title>" do
    org = Scorm::Title.from_xml(doc, "organization")
    org.title.should eq("Default Organization")
  end

  it "raises an error unless one, and only one, <title> element exists" do
    missing  = xml_scorm_manifest("untitled_organization").xpath("//xmlns:organization/xmlns:title")
    too_many = xml_scorm_manifest("wellnamed_organization").xpath("//xmlns:organization/xmlns:title")

    expect {
      Scorm::Title.from_xml(missing, "organization")
    }.to raise_error(Scorm::Errors::RequiredItemMissing)

    expect {
      Scorm::Title.from_xml(too_many, "organization")
    }.to raise_error(Scorm::Errors::DuplicateItem)
  end
end
