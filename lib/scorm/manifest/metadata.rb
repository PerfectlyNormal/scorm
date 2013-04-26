class Scorm::Manifest
  class Metadata
    include Virtus

    def self.from_xml(document)
      instance = new
      instance.schema        = document.xpath("xmlns:schema").text
      instance.schemaversion = document.xpath("xmlns:schemaversion").text

      instance.validate!

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
    end

    def valid_schema?
      schema == "ADL SCORM"
    end

    def valid_schemaversion?
      Scorm::Manifest::VALID_SCORM_VERSIONS.include?(schemaversion)
    end

    def supported_schemaversion?
      Scorm::Manifest::SUPPORTED_SCORM_VERSIONS.include?(schemaversion)
    end

    def to_s
      "<Manifest:Metadata '#{schema} #{schemaversion}'>"
    end
  end
end
