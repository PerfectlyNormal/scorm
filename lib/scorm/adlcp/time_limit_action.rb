require 'virtus'
require 'forwardable'
require 'scorm/errors'

# 3.4.1.13. <timeLimitAction> Element
# The <timeLimitAction> element defines the action that should be taken
# when the maximum time allowed in the current attempt of the activity
# is exceeded. All time tracking and time limit actions are controlled
# by the SCO.
#
# This element is an ADL defined extension to the IMS Content Packaging
# Specification. The element shall only appear, if needed, as a child of
# a leaf <item> element that references a SCO. Only those <item> elements
# that reference a SCO resource can contain the <timeLimitAction> element.
#
# The LMS shall use the value of the <timeLimitAction> element, if provided,
# to initialize the cmi.time_limit_action data model element (refer to the
# SCORM RTE book). If the content developer defines a time limit action, then
# the SCO is responsible for all behaviors based on the time out (if the time
# out occurs).
#
# XML Namespace: http://www.adlnet.org/xsd/adlcp_v1p3
# XML Namespace Prefix: adlcp
# XML Binding Representation: <timeLimitAction>
# SCORM Requirements:
#   SCORM places a requirement that all manifests shall adhere to the following
#   multiplicity requirements for the <timeLimitAction> element:
#     Content Aggregation: 0 or 1
#     Resource:            0
#
# For Resource Content Packages, this element shall not appear.
# The <organizations> element is required to be empty.
#
# Data Type: The <timeLimitAction> element is represented as a characterstring.
# The characterstring is required to be one of following set of restricted
# characterstring tokens:
#   * exit,message:
#     The learner should be forced to exit the SCO. The SCO should provide
#     a message to the learner indicating that the maximum time allowed for
#     the learner attempt was exceeded.
#   * exit,no message:
#     The learner should be forced to exit the SCO with no message.
#   * continue,message:
#     The learner should be allowed to continue in the SCO.
#     The SCO should provide a message to the learner indicating that the
#     maximum time allowed for the learner attempt was exceeded.
#   * continue,no message:
#     Although the learner has exceeded the maximum time allowed for the
#     learner attempt, the learner should be given no message and should
#     not be forced to exit the SCO.
#
# If this feature is used within the SCO, the SCO shall keep track of the time
# affecting this timeout period and provide the informative message indicating
# the timeout (if appropriate).
#
module Scorm::Adlcp
  class TimeLimitAction
    include Virtus.model
    extend Forwardable
    VALID_ACTIONS = ["exit,message", "exit,no message",
                     "continue,message", "continue,no message"]

    def self.from_xml(data)
      return nil if data.length == 0
      raise Scorm::Errors::DuplicateItem.new(
        "A <item> can only have zero or one <adlcp:timeLimitAction>, but found #{data.length}"
      ) if data.length > 1

      instance = new(action: data.text)

      raise Scorm::Errors::InvalidManifest.new(
        "<adlcp:timeLimitAction> was given #{instance.action}, which is invalid."
      ) unless instance.valid?

      instance
    end

    attribute :action, String, default: ""
    def_delegators :action, :eql, :==, :hash

    def to_s
      "<adlcp:timeLimitAction>#{action}</adlcp:timeLimitAction>"
    end

    def valid?
      VALID_ACTIONS.include?(action)
    end
  end
end
