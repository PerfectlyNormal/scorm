# 3.4.1.23. <resource> Element
#
# The <resource> element is a reference to a resource.
# There are two primary types of resources defined within SCORM:
#   * SCOs
#   * assets
#
# XML Namespace: http://www.imsglobal.org/xsd/imscp_v1p1
# XML Namespace Prefix: imscp
# XML Binding Representation: <resource>
#
# SCORM Requirements:
# SCORM places a requirement that all manifests shall adhere to the
# following multiplicity requirements for the <resource> element:
#
# Content Aggregation: 0 or More
# Resource:            0 or More
#
# A leaf <item> element is required to reference a resource
# (SCO resource or asset resource). If an <item> references a resource,
# this resource is subject to being identified for delivery and launch to
# the learner. If an <item> references a <resource>, then the <resource>
# element shall meet the following requirements:
#
# * The type attribute should be set to webcontent.
# * The adlcp:scormType shall be set to sco or asset.
# * The href attribute shall be required.
#
# Data Type:
# The <resource> element is a parent element.
# Parent elements have no values associated with them.
# Parent elements act as “containers” for other elements/attributes.
# The <resource> element contains the following elements/attributes:
#
# Attributes:
#   * identifier (mandatory):
#     The identifier attribute represents an identifier, of the resource,
#     that is unique within the scope of its containing manifest file.
#     This identifier is typically provided by an author or authoring tool.
#     XML Data Type: xs:ID.
#
#   * type (mandatory):
#     The type attribute indicates the type of resource.
#     The value has an SPM of 1000 characters.
#     XML Data Type: xs:string.
#
#   * href(optional):
#     The href attribute is a reference a Uniform Resource Locator (URL).
#     The href attribute represents the “entry point” or “launching point” of this resource.
#     External fully qualified URLs are also permitted.
#     The URL may also contain additional parameters (refer to
#     Section 3.4.3.3: Handling Additional Parameters as Part of URLs for information
#     regarding the handling of these parameters).
#
#     This value is affected by the use of xml:base values.
#     Refer to Section 3.4.3.1: Handling the XML Base Attribute for more information
#     on xml:base usage requirements and guidance.
#
#     The value has an SPM of 2000 characters.
#     The SPM represents the length of the href with the values of any xml:base applied to it. 
#     XML Data Type: xs:string.
#
#  * xml:base (optional):
#    The xml:base attribute provides a relative path offset for the files
#    contained in the manifest. The usage of this element is defined in the
#    XML Base Working Draft from the W3C.
#    The value has an SPM of 2000 characters.
#    XML Data Type: xs:anyURI.
#
#  * adlcp:scormType (mandatory):
#    The adlcp:scormType attribute defines the type of SCORM resource.
#    This is an ADL defined extension to the
#    IMS Content Packaging Information Model.
#
#    XML Data Type: xs:string.
#    The character string is restricted and shall be one of the following
#    characterstring tokens (sco or asset).
#    Where sco indicates that the resource is a SCO resource and
#    asset indicates that the resource is an asset resource.
#
# Elements:
#   * <metadata>
#   * <file>
#   * <dependency>
#
class Scorm::Resource

end
