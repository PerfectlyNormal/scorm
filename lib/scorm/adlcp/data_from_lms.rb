require 'virtus'
require 'forwardable'
require 'scorm/errors'

# 3.4.1.14. <dataFromLMS> Element
# The <dataFromLMS> element provides initialization data expected by the
# resource (i.e., SCO) represented by the <item> after launch. This data
# is opaque to the LMS and only has functional meaning to the SCO. This
# element shall not be used for parameters that the SCO may need during
# the launch (query string parameters). If this type of functionality is
# required, then the developer should use the parameters attribute of the
# item referencing the SCO resource.
#
# This element is an ADL defined extension to the IMS Content Packaging
# Specification. The element shall only appear, if needed, as a child of
# a leaf <item> element. Only those <item> elements that reference a SCO
# resource can contain the <dataFromLMS> element).
#
# The LMS shall use the value of the <dataFromLMS> element, if provided,
# to initialize the cmi.launch_data data model element
# (refer to SCORM Run-Time Environment book).
#
# XML Namespace: http://www.adlnet.org/xsd/adlcp_v1p3
# XML Namespace Prefix: adlcp
# XML Binding Representation: <dataFromLMS>
# SCORM Requirements:
#   SCORM places a requirement that all manifests shall adhere to the
#   following multiplicity requirements for the <dataFromLMS> element:
#     Content Aggregation: 0 or 1
#     Resource:            0
#
# For Resource Content Packages, this element shall not appear.
# The <organizations> element is required to be empty.
#
# Data Type:
#   The <dataFromLMS> element is represented as a characterstring element.
#   The characterstring has an SPM of 4000 characters.
#
module Scorm::Adlcp
  class DataFromLMS
    include Virtus
    extend Forwardable

    def self.from_xml(data)
      return nil if data.length == 0
      raise Scorm::Errors::DuplicateItem.new(
        "Found #{data.length} instances of <adlcp:dataFromLMS>, but only 0 or 1 is allowed."
      ) if data.length > 1

      new(data: data.text)
    end

    def to_s
      "<adlcp:dataFromLMS>#{data.length} bytes</adlcp:dataFromLMS>"
    end

    attribute :data, String, default: ""
    def_delegators :data, :hash, :eql, :==
  end
end
