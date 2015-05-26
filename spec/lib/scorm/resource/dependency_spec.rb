require 'spec_helper'
require 'scorm/resource/dependency'

describe Scorm::Resource::Dependency do
  describe ".from_xml" do
    it "reads the identifierref" do
      doc = xml_scorm_manifest("resource_with_dependencies")
      xml = doc.xpath("//xmlns:dependency")[0] # Keep it simple, avoid too much traversal
      dep = Scorm::Resource::Dependency.from_xml(xml)

      expect(dep.identifierref).to eq("assets")
    end
  end

  describe "#valid?" do
    it "should require the identifierref to be present in the manifest"
  end

  describe "#resource" do
    it "should be able to find the resource"
  end
end
