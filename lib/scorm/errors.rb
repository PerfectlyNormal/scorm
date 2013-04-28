module Scorm
  module Errors
    class InvalidManifest         < RuntimeError; end
    class RequiredItemMissing     < InvalidManifest; end
    class DuplicateItem           < InvalidManifest; end

    class NoMetadataError         < RequiredItemMissing; end
    class DuplicateMetadataError  < DuplicateItem; end
    class NoOrganizationsError    < RequiredItemMissing; end
    class DuplicateOrganizationsError < DuplicateItem; end

    class UnsupportedSCORMVersion < RuntimeError; end
    class InvalidSCORMVersion     < InvalidManifest; end
  end
end
