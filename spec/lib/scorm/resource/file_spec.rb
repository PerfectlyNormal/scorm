require 'spec_helper'
require 'scorm/resource'

describe Scorm::Resource::File do
  describe ".from_xml" do
    it "reads the href attribute" do
      doc  = xml_scorm_manifest("valid_resource")
      xml  = doc.xpath("//xmlns:file")[0] # Keep it simple, avoid traversing everything
      file = Scorm::Resource::File.from_xml(xml)

      file.href.should eq("example.html")
    end
  end

  describe "#valid?" do
    it "should require the href attribute" do
      file = Scorm::Resource::File.new
      file.href = ""
      file.should_not be_valid

      file.href = "example.html"
      file.should be_valid
    end
  end
end
