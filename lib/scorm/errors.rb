module Scorm
  module Errors
    class InvalidManifest         < RuntimeError; end
    class NoMetadataError         < InvalidManifest; end
    class DuplicateMetadataError  < InvalidManifest; end
    class UnsupportedSCORMVersion < RuntimeError; end
    class InvalidSCORMVersion     < RuntimeError; end
  end
end