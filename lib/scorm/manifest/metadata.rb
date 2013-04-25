class Scorm::Manifest
  class Metadata
    include Virtus

    def self.from_xml(document)
      instance = new
      instance.schema        = document.xpath("xmlns:schema").text
      instance.schemaversion = document.xpath("xmlns:schemaversion").text
      instance
    end

    attribute :schema, String
    attribute :schemaversion, String
  end
end
