require 'virtus'

def scorm_manifest(name)
  File.read File.expand_path(
    File.join(__FILE__, "..", "fixtures", "manifests", "#{name}.xml")
  )
end

def xml_scorm_manifest(name)
  Nokogiri::XML(scorm_manifest(name), "utf-8") { |config| config.nonet }
end
