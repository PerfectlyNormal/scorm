require 'spec_helper'
require 'scorm/organization'

describe Scorm::Organization::Item do
  describe ".from_xml" do
    it "reads the identifier"
    it "reads the 'identifierref' attribute"
    it "reads the 'isvisible' attribute"
    it "reads the 'parameters' attribute"

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
