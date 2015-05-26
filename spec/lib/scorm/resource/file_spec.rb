require 'spec_helper'
require 'scorm/resource'

describe Scorm::Resource::File do
  describe ".from_xml" do
    it "reads the href attribute" do
      doc  = xml_scorm_manifest("valid_resource")
      xml  = doc.xpath("//xmlns:file")[0] # Keep it simple, avoid traversing everything
      file = Scorm::Resource::File.from_xml(xml)

      expect(file.href).to eq("example.html")
    end
  end

  describe "#valid?" do
    it "should require the href attribute" do
      file = Scorm::Resource::File.new
      file.href = ""
      expect(file).not_to be_valid

      file.href = "example.html"
      expect(file).to be_valid
    end
  end
end
