class Scorm::Manifest
  class Metadata
    include Virtus

    def self.from_xml(document)
      raise Scorm::Manifest::NoMetadataError.new(
        "<metadata> must appear once, but was not found"
      ) if document.length == 0
      raise Scorm::Manifest::DuplicateMetadataError.new(
       "<metadata> can only appear once, but was found #{document.length} times"
      ) if document.length > 1

      instance = new
      instance.schema        = document.xpath("xmlns:schema").text
      instance.schemaversion = document.xpath("xmlns:schemaversion").text

      instance
    end

    attribute :schema, String
    attribute :schemaversion, String

    def validate!
      raise Scorm::Manifest::InvalidSCORMVersion.new(
        "#{to_s} is not a valid SCORM version"
      ) if !valid_schema? || !valid_schemaversion?

      raise Scorm::Manifest::UnsupportedSCORMVersion.new(
        "#{to_s} is not a supported SCORM version"
      ) unless supported_schemaversion?

      self
    end

    def valid?
      valid_schema? && valid_schemaversion?
    end

    def to_s
      "<Manifest:Metadata '#{schema} #{schemaversion}'>"
    end

    private

    def valid_schema?
      schema == "ADL SCORM"
    end

    def valid_schemaversion?
      Scorm::Manifest::VALID_SCORM_VERSIONS.include?(schemaversion)
    end

    def supported_schemaversion?
      Scorm::Manifest::SUPPORTED_SCORM_VERSIONS.include?(schemaversion)
    end
  end
end
