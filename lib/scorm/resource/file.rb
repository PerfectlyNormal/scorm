# 3.4.1.25. <file> Element
# The <file> element is a listing of files that a resource described by
# a <resource> element requires for delivery. This element is repeated
# as necessary for each file for a given resource.
# The element acts as an inventory system detailing the set of files used
# to build the resource. The <file> element represents files that are local
# to the content package. For all files that are required for delivery of the
# content package in a SCORM run-time environment and are local to the content
# package (physically located in the content package), a <file> element shall
# be used to represent the file relative to the resource in which it is used.
# If the resource identified by a <resource> element is local to the package,
# then the resource itself shall be identified as a <file> element.
# The launch location of the <resource> (<resource>’s href value) shall be used
# as the href of the file. The value of the <file> element’s href attribute
# should not contain any parameters that may have been defined on the <resource>
# element’s href attribute.
#
# All of the physical files that are included in the content package should be
# referenced by a file element. Leaving these references to the physical files
# out of the manifest may cause a wide range of problems.
#
# XML Namespace: http://www.imsglobal.org/xsd/imscp_v1p1
# XML Namespace Prefix: imscp
# XML Binding Representation: <file>
# SCORM Requirements:
#   SCORM places a requirement that all manifests shall adhere to the following multiplicity requirements for the <file> element:
#     Content Aggregation: 0 or More
#￼￼￼￼￼Resource:            0 or More
# Data Type:
#   The <file> element is a parent element. Parent elements have no
#   values associated with them. Parent elements act as “containers”
#   for other elements/attributes.
#   The <file> element contains the following elements/attributes:
#
# Attributes:
#   * href (mandatory):
#     The href attribute identifies the location of the file.
#     This value is affected by the use of xml:base values.
#     Some systems may treat this value as case sensitive, developers
#     should be aware of this and ensure that values used match the
#     resources being referenced.
#     Refer to Section 3.4.3.1: Handling the XML Base Attribute for more
#     information on xml:base usage requirements and guidance.
#
#     The value has an SPM of 2000 characters.
#     The SPM represents the length of the href with the values of any
#     xml:base applied to it.
#
#     XML Data Type: xs:string.
#
# Elements:
#   * <metadata>
#
class Scorm::Resource
  class File
    include Virtus.model

    def self.from_xml(data)
      instance = new
      instance.href = data.attr('href')
      # FIXME: Parse <metadata> here

      instance
    end

    attribute :href, String

    def to_s
      "<File #{href}>"
    end

    def valid?
      href.to_s != ''
    end
  end
end
