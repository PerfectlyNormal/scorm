require 'scorm/organization'

# 3.4.1.6. <organizations> Element
# The <organizations> element describes one or more structures or
# organizations for the content package.
#
# XML Namespace: http://www.imsglobal.org/xsd/imscp_v1p1
# XML Namespace Prefix: imscp
# XML Binding Representation: <organizations>
# SCORM Requirements:
#   SCORM places a requirement that all manifests shall adhere to the
#   following multiplicity requirements for the <organizations> element:
#     Content Aggregation: 1 and only 1
#     Resource:            1 and only 1
#
# SCORM places a requirement that when building a Resource Content Package,
# this element is required to be represented in the manifest as an empty
# element (i.e., <organizations/>).
# When building a Content Aggregation Content Package, this element is
# required to contain at least one <organization> sub-element.
#
# Data Type:
#   The <organizations> element is a parent element.
#   Parent elements have no values associated with them.
#   Parent elements act as “containers” for other elements/attributes.
#   The <organizations> element contains the following elements/attributes:
#
# Attributes:
#   * default (mandatory – for a Content Aggregation Content Package):
#     The default attribute identifies the default organization to use.
#     The value of this element must reference an identifier attribute
#     of an <organization> element that is a direct descendent of the
#     <organizations> element.
#     XML Data Type: xs:IDREF.
#
# Elements:
#   * <organization>
#
class Scorm::OrganizationSet
  include Virtus

  def self.from_xml(data)
    raise Scorm::Errors::NoOrganizationsError.new(
      "<organizations> must appear once, but was not found"
    ) if data.length == 0
    raise Scorm::Errors::DuplicateOrganizationsError.new(
     "<organizations> can only appear once, but was found #{data.length} times"
    ) if data.length > 1

    instance = new
    instance.default = data.try(:attr, "default")
    data.xpath("xmlns:organization").each do |org|
      instance.organizations.push(Scorm::Organization.from_xml(org))
    end

    raise Scorm::Errors::InvalidManifest.new(
      "The <organizations> element requires a 'default' attribute, but none was found"
    ) if !instance.default

    instance
  end

  attribute :default, String
  attribute :organizations, Array[Scorm::Organization]

  def default_organization
    organizations.select { |org| org.identifier == default }.first
  end

  def valid?
    default.to_s.strip != "" &&
      default_organization != nil
  end

  def to_s
    "<Organizations default='#{default}'>"
  end
end
