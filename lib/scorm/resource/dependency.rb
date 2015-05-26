# 3.4.1.27. <dependency> Element
#
# The <dependency> element identifies a resource whose files this
# resource (the resource in which the dependency is declared in) depends on.
# The resource that the <dependency> references can act as a container for
# multiple files that the resource containing the <dependency> is reliant on.
#
# XML Namespace: http://www.imsglobal.org/xsd/imscp_v1p1
# XML Namespace Prefix: imscp
# XML Binding Representation: <dependency>
# SCORM Requirements:
#   SCORM places a requirement that all manifests shall adhere to the following
#   multiplicity requirements for the <dependency> element:
#     Content Aggregation: 0 or More
#     Resource:            0 or More
#
# Data Type:
#   The <dependency> element only contains attributes.
#
# Attributes:
#   * identifierref (mandatory):
#     The identifierref attribute references an identifier attribute of
#     a <resource> (within the scope of the <manifest> element for which
#     it is defined) and is used to resolve the ultimate location of the
#     dependent resource. The identifierref is not permitted to reference
#     a resource defined in a (sub)manifest.
#     The value has an SPM of 2000 characters.
#     XML Data Type: xs:string.
#
# Elements:
#   * None
#
class Scorm::Resource
  class Dependency
    include Virtus.model

    def self.from_xml(data)
      instance = new
      instance.identifierref = data.attr('identifierref')

      instance
    end

    def to_s
      "<Dependency #{identifierref}>"
    end

    attribute :identifierref, String
  end
end
