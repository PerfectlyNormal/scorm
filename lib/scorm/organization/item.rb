require 'scorm/title'

# 3.4.1.9. <item> Element
# The <item> element is a node that describes the hierarchical structure of
# the organization. The <item> element represents an activity in the content
# organization. The <item> element describes a node within the organization’s
# structure. The <item> element can be nested and repeated within other <item>
# elements to any number of levels. This structuring of <item> elements shapes
# the content organization and describes the relationships between parts of
# the learning content.
#
# The <item> element can act as a container of other <item> elements or as
# a leaf node. If an <item> is a leaf node, then the <item> shall reference
# a <resource> element. If an <item> element is a parent element, the <item>
# itself is not permitted to reference a <resource> element
# (only leaf <item> elements are permitted to reference resources).
#
# XML Namespace: http://www.imsglobal.org/xsd/imscp_v1p1
# XML Namespace Prefix: imscp
# XML Binding Representation: <item>
# SCORM Requirements:
#   SCORM places a requirement that all manifests shall adhere to the
#   following multiplicity requirements for the <item> element:
#     Content Aggregation: 1 or More
#     Resource:            0
#
# For Resource Content Packages, this element shall not appear.
# The <organizations> element is required to be empty.
#
# Data Type:
#   The <item> element is a parent element.
#   Parent elements have no values associated with them.
#   Parent elements act as “containers” for other elements/attributes.
#   The <item> element contains the following elements/attributes:
#
# Attributes:
#   * identifier (mandatory):
#     An identifier attribute is an identifier, for the item, that is
#     unique within the manifest.
#     XML Data Type: xs:ID.
#
#   * identifierref (optional):
#     The identifierref attribute is a reference to an identifier in
#     the resources section or a (sub)manifest.
#     If no identifierref is supplied, it is assumed that there is no
#     content associated with this entry in the organization.
#     The value has an SPM of 2000 characters.
#     XML Data Type: xs:string.
#
#   * isvisible (optional):
#     The isvisible attribute indicates whether or not this item is displayed
#     when the structure of the package is displayed or rendered.
#     If not present, value is defaulted to be true.
#     The value only affects the item for which it is defined and not the
#     children of the item or a resource associated with an item.
#     XML Data Type: xs:boolean.
#
#   * parameters (optional):
#     The parameters attribute contains the static parameters to be passed
#     to the resource at launch time. The parameters attribute should only
#     be used for <item> elements that reference <resource> elements.
#     The value has an SPM of 1000 characters.
#     XML Data Type: xs:string.
#
#     The accepted syntax for the parameters attribute value shall be:
#       * #<parameter>
#       * <name>=<value>(&<name>=<value>)*(#<parameter>)
#       * ?<name>=<value>(&<name>=<value>)*(#<parameter>)
#
#     Where:
#       * <parameter>, <name> and <value> is some implementation defined
#         characterstring value.
#       * = is required to separate the <name> and <value> pair
#       * & is required to separate multiple sets of <name> and <value> pairs
#       * (&<name>=<value>)* indicates that 0 or more <name> and <value> pairs
#         can be concatenated together
#
#     The characters used in the parameters value may need to be URL encoded.
#     RFC 3986 defines the requirements for encoding URLs.
#
# Elements:
#   * <title>
#   * <item>
#   * <metadata>
#   * <adlcp:timeLimitAction>
#   * <adlcp:dataFromLMS>
#   * <adlcp:completionThreshold>
#   * <imsss:sequencing>
#   * <adlnav:presentation>
#   * <adlcp:data>
#
class Scorm::Organization
  class Item
    include Virtus

    def self.from_xml(data)
      instance = new
      instance.identifier    = data.attr("identifier")
      instance.identifierref = data.attr("identifierref") || ""
      instance.isvisible     = data.attr("isvisible")     || true
      instance.parameters    = data.attr("parameters")    || ""

      instance.title         = Scorm::Title.from_xml(data.xpath("xmlns:title"), "item")
      instance
    end

    attribute :identifier,    String
    attribute :identifierref, String,  default: ""
    attribute :isvisible,     Boolean, default: true
    attribute :parameters,    String,  default: ""
    attribute :title,         Scorm::Title

    def to_s
      str  = ["<Item:#{identifier}"]
      str.push(" identifierref='#{identifierref}'") if identifierref.to_s.strip != ""
      str.push(" isvisible='false'")                if !isvisible
      str.push(" parameters='#{parameters}'")       if parameters.to_s.strip != ""
      str.push(">")
      str.join
    end
  end
end
