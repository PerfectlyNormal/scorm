require 'nokogiri'
require 'scorm/manifest/metadata'

class Scorm::Manifest
  class InvalidManifest < RuntimeError; end
  class UnsupportedSCORMVersion < RuntimeError; end

  include Virtus
  extend Forwardable

  SUPPORTED_SCORM_VERSIONS = ["2004 4th Edition"]

  def self.parse(data)
    # Basic sanity check
    raise InvalidManifest.new(
      "'#{data.inspect}' does not look like a valid SCORM manifest"
    ) if data.nil? || data.strip.length == 0

    new.load(data)
  end

  attribute :identifier, String
  attribute :metadata, Scorm::Manifest::Metadata

  def_delegators :metadata, :schema, :schemaversion

  def load(data)
    doc = Nokogiri::XML(data, "utf-8") { |config| config.nonet }
    self.identifier = doc.root.attr("identifier")
    self.metadata   = Scorm::Manifest::Metadata.from_xml(doc.xpath('/xmlns:manifest/xmlns:metadata'))

    if metadata.schema != "ADL SCORM" ||
      !SUPPORTED_SCORM_VERSIONS.include?(metadata.schemaversion)
      raise UnsupportedSCORMVersion.new("#{metadata.schema} #{metadata.schemaversion} is not a supported SCORM version.")
    end

    self
  end
end
