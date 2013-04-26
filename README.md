# Scorm

SCORM is a gem implementing bits and pieces of the SCORM 2004 4th Edition
specification. The eventual goal is to support it all, but that will take a
while.

This gem has gathered some inspiration from the [gem by
mindset](https://github.com/mindset/scorm), but is being made anew.

## Main Goals:

1. Parse SCORM packages and create a representation of everything useful.
2. Write the manifest and all associated files to disk, creating a SCORM package
   suitable for redistribution
3. Handle the RTE-bits, so the library can be used as a backend/basis for a
   full-featured LMS.

## Additional Goals:

1. Support the older versions of the standards for maximum compatibility.

## Installation

Add this line to your application's Gemfile:

    gem 'scorm'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scorm

## Usage

TODO: Write usage instructions here

## About

Created and maintained by Per Christian B. Viken (perchr@northblue.org).
Released under the MIT license.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
