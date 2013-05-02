require 'virtus'
require 'scorm/errors'
require 'scorm/adlcp/map'

# 3.4.1.18. <data> Element
# The <data> element is the container used to define sets of data shared
# associated with an activity. This element is an ADL defined extension to
# the IMS Content Packaging Specification. The element shall only appear, if
# needed, as a child of a leaf <item> element that references a SCO resource.
#
# XML Namespace: http://www.adlnet.org/xsd/adlcp_v1p3
# XML Namespace Prefix: adlcp
# XML Binding Representation: <data>
# SCORM Requirements:
#   SCORM places a requirement that all manifests shall adhere to the
#   following multiplicity requirements for the <data> element:
#     Content Aggregation: 0 or 1
#     Resource:            0
# For Resource Content Packages, this element shall not appear.
# The <organizations> element is required to be empty.
#
# Data Type:
#   The <data> element is a parent element. Parent elements have no values
#   associated with them. Parent elements act as “containers” for other
#   elements/attributes. The <data> element contains the following
#   elements/attributes:
#
# Attributes:
#   * None
#
# Elements:
#   * <adlcp:map>
#
module Scorm::Adlcp
  class Data
    include Virtus

    def self.from_xml(data)
      return nil if data.nil? || (data.is_a?(Nokogiri::XML::NodeSet) && data.empty?)
      instance = new

      data.xpath("adlcp:map").each do |map|
        instance.maps.push(Scorm::Adlcp::Map.from_xml(map))
      end

      raise Scorm::Errors::RequiredItemMissing.new(
        "<adlcp:data> requires one or more <adlcp:map> elements, but found none"
      ) if instance.maps.empty?

      instance
    end

    attribute :maps, Array[Scorm::Adlcp::Map]

    def valid?
      !maps.empty?
    end
  end
end
