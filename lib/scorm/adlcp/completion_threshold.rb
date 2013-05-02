require 'virtus'
require 'scorm/errors'

# 3.4.1.15. <completionThreshold> Element
# The <completionThreshold> element enables the definition of a threshold
# value to be applied when evaluating an activty’s completion status.
# It also provides a means to designate the degree of contribution (weight)
# the activity’s completion imposes relative to its siblings.
# This element is an ADL defined extension to the IMS Content Packaging
# Specification. The element shall only appear, if needed, as a child of
# an <organization> element or <item> element.
#
# XML Namespace: http://www.adlnet.org/xsd/adlcp_v1p3
# XML Namespace Prefix: adlcp
# XML Binding Representation: <completionThreshold>
# SCORM Requirements:
#   SCORM places a requirement that all manifests shall adhere to the
#   following multiplicity requirements for the <completionThreshold>
#   element:
#     Content Aggregation: 0 or 1
#     Resource:            0
#
# For Resource Content Packages, this element shall not appear.
# The <organizations> element is required to be empty.
#
# Data Type:
#   The <completionThreshold> element is a parent element.
#   Parent elements have no values associated with them.
#   Parent elements act as “containers” for other elements/attributes.
#
# The <completionThreshold> element contains the following elements/attributes:
#
# Attributes:
#   * completedByMeasure (optional, default value = false):
#     This attribute indicates whether the minProgressMeasure attribute’s
#     data value shall be used in place of any other method to determine if
#     the activity is completed.
#     XML Data Type: xs:boolean.
#   * minProgressMeasure (optional, default value = 1.0)
#     The value used as a threshold during measure-based evaluations of the
#     activity’s completion status.
#     XML Data Type: xs:decimal (Range 0.0000 to 1.0000, with a precision to
#                                at least 4 significant digits).
#
#     For a leaf <item> that references a SCO resource, the LMS shall use
#     the minProgressMeasure value, if provided, to initialize the
#     cmi.completion_threshold data model element (refer to the SCORM RTE
#     book). This value will be used by the SCO to determine completion
#     when completedByMeasure is true.
#   * progressWeight (optional, default value = 1.0):
#     This attribute indicates the weighting factor applied to the
#     activity’s progress measure used during completion rollup of the
#     parent activity.
#     XML Data Type: xs:decimal (Range 0.0000 to 1.0000, with a precision to
#                                at least 4 significant digits).
#
# Elements:
#   * None
#
module Scorm::Adlcp
  class CompletionThreshold
    include Virtus

    def self.from_xml(data)
      return nil if data.nil? || data.length == 0
      raise Scorm::Errors::DuplicateItem.new(
        "Found #{data.length} instances of <adlcp:completionThreshold>,
         but only 0 or 1 is allowed."
      ) if data.length > 1

      # There's only one element here, but Nokogiri still treats it as a
      # collection. We don't want that.
      data = data[0]

      instance = new
      instance.completed_by_measure = data.attr("completedByMeasure") || false
      instance.min_progress_measure = data.attr("minProgressMeasure") || 1.0
      instance.progress_weight      = data.attr("progressWeight")     || 1.0
      instance
    end

    attribute :completed_by_measure, Boolean, default: false
    attribute :min_progress_measure, Decimal, default: 1.0
    attribute :progress_weight,      Decimal, default: 1.0

    def valid?
      min_progress_measure <= 1.0000 &&
        min_progress_measure >= 0.0000 &&
        progress_weight <= 1.0000 &&
        progress_weight >= 0.0000
    end
  end
end
