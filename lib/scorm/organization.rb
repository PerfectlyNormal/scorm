require 'scorm/errors'
require 'scorm/adlcp'
require 'scorm/organization/item'

# 3.4.1.7. <organization> Element
# The <organization> element describes a particular hierarchical organization.
# The content organization is defined by the <organization> element. The
# content organization is a conceptual term. The content organization can be
# a lesson, module, course, chapter, etc. What a content organization defines
# is dependent on an organization’s curricular taxonomy.
# The <organization> element represents an Activity in the terms of IMS SS.
#
# XML Namespace: http://www.imsglobal.org/xsd/imscp_v1p1
# XML Namespace Prefix: imscp
# XML Binding Representation: <organization>
# SCORM Requirements:
#   SCORM places a requirement that all manifests shall adhere to the
#   following multiplicity requirements for the <organization> element:
#     Content Aggregation: 1 or More
#     Resource:            0
#
# For Resource Content Packages, this element shall not appear.
# The <organizations> element (its parent) is required to be empty.
#
# Data Type:
#   The <organization> element is a parent element.
#   Parent elements have no values associated with them.
#   Parent elements act as “containers” for other elements/attributes.
#   The <organization> element contains the following elements/attributes:
#
# Attributes:
#   * identifier (mandatory):
#     An identifier for the organization that is unique within the manifest
#     file. Typically this value is provided by an author or authoring tool.
#     XML Data Type: xs:ID.
#
#   * structure (optional):
#     Describes the shape of the organization. The default value of the
#     structure attribute, if not provided, shall be 'hierarchical'.
#     The value has an SPM of 200 characters.
#     XML Data Type: xs:string.
#
#   * adlseq:objectivesGlobalToSystem (optional, default=true):
#     This attribute indicates that any mapped global shared objectives
#     defined in sequencing information (refer to
#     Section 5.1.1: <sequencing> Element) are either global to the learner
#     and one experience of a content organization (false) or global for the
#     lifetime of the learner within the LMS (true) across all content
#     organizations.
#     XML Data Type: xs:boolean.
#
#   * adlcp:sharedDataGlobalToSystem (optional, default = true):
#     This attribute indicates that any shared data mapped across SCOs
#     (refer to section <adlcp:data> Element) are either global to the
#     learner and one experience of a content organization (false) or
#     global for the lifetime of the learner within the LMS (true).
#     XML Data Type: xs:boolean.
#
# Elements:
#   * <title>
#   * <item>
#   * <metadata>
#   * <adlcp:completionThreshold>
#   * <imsss:sequencing>
#
class Scorm::Organization
  include Virtus.model

  def self.from_xml(data)
    instance = new
    instance.identifier = data.attr('identifier')
    instance.structure  = data.attr('structure') || 'hierarchical'
    instance.adlseq_objectives_global_to_system = data.attr('adlseq:objectivesGlobalToSystem') || true
    instance.adlcp_shared_data_global_to_system = data.attr('adlcp:sharedDataGlobalToSystem')  || true
    raise Scorm::Errors::InvalidManifest.new(
      '<organization> must have an identifier'
    ) unless instance.identifier.to_s.strip != ''

    # Children
    instance.title = Scorm::Title.from_xml(data.xpath('xmlns:title'), 'organization')
    data.xpath('xmlns:item').each do |item|
      instance.items.push(Scorm::Organization::Item.from_xml(item))
    end

    instance
  end

  attribute :identifier, String
  attribute :structure,  String, default: 'hierarchical'
  attribute :adlseq_objectives_global_to_system, Boolean, default: true
  attribute :adlcp_shared_data_global_to_system, Boolean, default: true
  attribute :title, Scorm::Title
  attribute :items, Array[Scorm::Organization::Item]

  def valid?
    identifier.to_s.strip != '' &&
      title.to_s.strip != ''
  end

  def eql?(other)
    return false if other.class != self.class
    other.identifier == self.identifier
  end

  def ==(other)
    eql?(other)
  end

  def hash
    identifier.hash
  end

  def to_s
    "<Organization:#{identifier} structure='#{structure}'>"
  end
end
