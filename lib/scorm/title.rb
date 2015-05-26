require 'forwardable'
require 'scorm/errors'
# 3.4.1.10. <title> Element
# The <title> element describes the title of the item.
#
# XML Namespace: http://www.imsglobal.org/xsd/imscp_v1p1
# XML Namespace Prefix: imscp
# XML Binding Representation: <title>
# SCORM Requirements:
#   SCORM places a requirement that all manifests shall adhere to the
#   following multiplicity requirements for the <title> element:
#
#   Content Aggregation: 1 and only 1
#   Resource:            0
#
# For Resource Content Packages, this element shall not appear.
# The <organizations> element is required to be empty.
# Consequently, no <item> or <title> will be provided.
#
# Data Type:
#   The <title> element is represented as a characterstring element.
#   The characterstring has an SPM of 200 characters.
#   XML Data Type: xs:string.
#
class Scorm::Title
  include Virtus.value_object
  extend Forwardable

  def self.from_xml(title, parent)
    raise Scorm::Errors::RequiredItemMissing.new(
      "An <#{parent}> is required to have a <title>"
    ) if title.length == 0
    raise Scorm::Errors::DuplicateItem.new(
      "An <#{parent}> can only have one <title>"
    ) if title.length > 1

    new(title: title.text)
  end

  values do
    attribute :title, String
  end

  def_delegators :title, :to_s, :hash, :eql, :==
end
