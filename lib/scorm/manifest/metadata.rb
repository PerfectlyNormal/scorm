class Scorm::Manifest
  class Metadata
    include Virtus.model

    def self.from_xml(document)
      raise Scorm::Errors::NoMetadataError.new(
        '<metadata> must appear once, but was not found'
      ) if document.length == 0
      raise Scorm::Errors::DuplicateMetadataError.new(
       "<metadata> can only appear once, but was found #{document.length} times"
      ) if document.length > 1

      # <schema> and <schemaversion> must appear once, and only once.
      # Verify this.
      schema        = document.xpath('xmlns:schema')
      schemaversion = document.xpath('xmlns:schemaversion')
      [schema, schemaversion].each do |tag|
        raise Scorm::Errors::InvalidManifest.new(
          "<#{tag.name}> must appear once, and only once, inside the <metadata> tag.
           Was found #{tag.length} times"
        ) if tag.length != 1
      end

      instance = new
      instance.schema        = schema.text
      instance.schemaversion = schemaversion.text
      # FIXME: Needs to read more elements, <lom> among others

      instance
    end

    attribute :schema, String
    attribute :schemaversion, String

    def validate!
      raise Scorm::Errors::InvalidSCORMVersion.new(
        "#{to_s} is not a valid SCORM version"
      ) if !valid_schema? || !valid_schemaversion?

      raise Scorm::Errors::UnsupportedSCORMVersion.new(
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
      schema == 'ADL SCORM'
    end

    def valid_schemaversion?
      Scorm::Manifest::VALID_SCORM_VERSIONS.include?(schemaversion)
    end

    def supported_schemaversion?
      Scorm::Manifest::SUPPORTED_SCORM_VERSIONS.include?(schemaversion)
    end
  end
end
