require 'virtus'

def scorm_manifest(name)
  File.read File.expand_path(
    File.join(__FILE__, "..", "fixtures", "manifests", "#{name}.xml")
  )
end
