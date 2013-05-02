require 'spec_helper'
require 'scorm/adlcp/completion_threshold'

describe Scorm::Adlcp::CompletionThreshold do
  describe ".from_xml" do
    describe "with valid data" do
      let(:doc) { xml_organization_item(<<-XML).xpath("//adlcp:completionThreshold") }
        <adlcp:completionThreshold completedByMeasure="true"
                                   minProgressMeasure="0.5"
                                   progressWeight="0.8"/>
      XML
      subject(:threshold) { Scorm::Adlcp::CompletionThreshold.from_xml(doc) }

      it "should read 'completedByMeasure'" do
        threshold.completed_by_measure.should be_true
      end

      it "should read 'minProgressMeasure'" do
        threshold.min_progress_measure.should eq(0.5)
      end

      it "should read 'progressWeight'" do
        threshold.progress_weight.should eq(0.8)
      end
    end

    describe "with missing data" do
      let(:doc) { xml_organization_item(<<-XML).xpath("//adlcp:completionThreshold") }
        <adlcp:completionThreshold />
      XML
      subject(:threshold) { Scorm::Adlcp::CompletionThreshold.from_xml(doc) }

      it "should use the default for 'completedByMeasure'" do
        threshold.completed_by_measure.should be_false
      end

      it "should use the default for 'minProgressMeasure'" do
        threshold.min_progress_measure.should eq(1.0)
      end

      it "should use the default for 'progressWeight'" do
        threshold.progress_weight.should eq(1.0)
      end
    end

    describe "with invalid data" do
      it "should return nil if no element is given" do
        xml = xml_organization_item("").xpath("//adlcp:completionThreshold")
        Scorm::Adlcp::CompletionThreshold.from_xml(xml).should be_nil
      end

      it "should throw an error if more than one element is given" do
        xml = xml_organization_item(<<-XML).xpath("//adlcp:completionThreshold")
          <adlcp:completionThreshold />
          <adlcp:completionThreshold progressWeight="0.5"/>
        XML

        expect {
          Scorm::Adlcp::CompletionThreshold.from_xml(xml)
        }.to raise_error(Scorm::Errors::DuplicateItem)
      end
    end
  end

  describe "default values" do
    it "should default 'completedByMeasure' to false" do
      subject.completed_by_measure.should be_false
    end

    it "should default 'minProgressMeasure' to 1.0" do
      subject.min_progress_measure.should eq(1.0)
    end

    it "should default 'progressWeight' to 1.0" do
      subject.progress_weight.should eq(1.0)
    end
  end

  describe "#valid?" do
    it "should require 'min_progress_measure' to be within 0.0000 and 1.0000" do
      invalid = [-1, -0.5, -0.0001, 1.0001, 1.5, 2]
      valid   = [0.0000, 0.0001, 0.5, 0.9999, 1.0000]

      invalid.each do |value|
        subject.min_progress_measure = value
        subject.should_not be_valid
      end

      valid.each do |value|
        subject.min_progress_measure = value
        subject.should be_valid
      end
    end

    it "should require 'progress_weight' to be within 0.0000 and 1.0000" do
      invalid = [-1, -0.5, -0.0001, 1.0001, 1.5, 2]
      valid   = [0.0000, 0.0001, 0.5, 0.9999, 1.0000]

      invalid.each do |value|
        subject.progress_weight = value
        subject.should_not be_valid
      end

      valid.each do |value|
        subject.progress_weight = value
        subject.should be_valid
      end
    end

  end
end
