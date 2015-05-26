require 'virtus'
require 'scorm/errors'

# 3.4.1.19. <map> Element
# The <map> element is the container used to describe how an activity will
# utilize a specific set of shared data.
#
# XML Namespace: http://www.adlnet.org/xsd/adlcp_v1p3
# XML Namespace Prefix: adlcp
# XML Binding Representation: <map>
# Data Type:
#   The <map> element is a parent element.
#   Parent elements have no values associated with them.
#   Parent elements act as “containers” for other elements/attributes.
#   The <map> element contains the following elements/attributes:
#
# Attributes:
#   * targetID (required):
#     The identifier of shared data targeted for the mapping. The underlying
#     data type for the targetID, is a unique identifier. Since an empty
#     characterstring does not provide sufficient semantic information to
#     uniquely identify which global shared objective is being targeted, then
#     the targetID attribute cannot be an empty characterstring and cannot
#     contain all whitespace characters (which could be transcribed as an
#     empty characterstring by an XML parser).
#     XML Data Type: xs:anyURI.
#   * readSharedData (optional, default value = true):
#     This attribute indicates that currently available shared data will be
#     utilized by the activity while it is active.
#     XML Data Type: xs:boolean.
#   * writeSharedData (optional, default value = true):
#     This attribute indicates that shared data should be persisted (true or
#     false) upon termination ( Terminate(“”) ) of the attempt on the activity.
#     XML Data Type: xs:boolean.
#
# Elements:
#   * None
#
# Multiplicity: Occurs 1 or more time in the <adlcp:data> element
#
module Scorm::Adlcp
  class Map
    include Virtus.model

    def self.from_xml(data)
      instance = new

      raise Scorm::Errors::InvalidManifest.new(
        "<adlcp:map> requires a targetID attribute, but none found"
      ) unless data.attr("targetID")

      instance.target_id         = data.attr("targetID")
      instance.read_shared_data  = data.attr("readSharedData")
      instance.write_shared_data = data.attr("writeSharedData")

      instance
    end

    attribute :target_id, String
    attribute :read_shared_data,  Boolean, default: true
    attribute :write_shared_data, Boolean, default: true

    def valid?
      target_id.to_s.strip != ""
    end
  end
end
