require 'nokogiri'
require 'forwardable'
require 'scorm/manifest/metadata'
require 'scorm/organization_set'
require 'scorm/resource'

class Scorm::Manifest
  include Virtus.model
  extend Forwardable

  VALID_SCORM_VERSIONS     = ['2004 4th Edition', '2004 3rd Edition', 'CAM 1.3', '1.2']
  SUPPORTED_SCORM_VERSIONS = ['2004 4th Edition']

  def self.parse(data)
    # Basic sanity check
    raise Scorm::Errors::InvalidManifest.new(
      "'#{data.inspect}' does not look like a valid SCORM manifest"
    ) if data.nil? || data.strip.length == 0

    new.load(data)
  end

  attribute :identifier, String
  attribute :metadata, Scorm::Manifest::Metadata
  attribute :resources, Array[Scorm::Resource]
  attribute :organization_set, Scorm::OrganizationSet

  def_delegators :metadata, :schema, :schemaversion
  def_delegators :organization_set, :organizations, :default_organization

  def load(data)
    doc = Nokogiri::XML(data, "utf-8") { |config| config.nonet }
    self.identifier = doc.root.attr("identifier")
    self.metadata   = Scorm::Manifest::Metadata.from_xml(
      doc.xpath('/xmlns:manifest/xmlns:metadata')
    ).validate!
    self.organization_set = Scorm::OrganizationSet.from_xml(
      doc.xpath("/xmlns:manifest/xmlns:organizations")
    )

    doc.xpath("/xmlns:manifest/xmlns:resources/xmlns:resource").each do |resource|
      self.resources.push Scorm::Resource.from_xml(resource)
    end

    self
  end
end
