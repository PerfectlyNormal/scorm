* Read and parse the rest of the manifest elements
  * Read additional data from <metadata>
* Improve validation
  * Organization::Item#identifier needs to be unique within the manifest
  * Similar others that has to be taken care of
* Every bit of the manifest needs to be Read/Write, so we can change
* Write the manifest back out to a file
* Support opening packages and parsing the contents
* Support writing packages
* Handle the important bits of the RTE as well, so the gem can be used as a basis for an
  LMS.

## Far future

* Support additional versions of the standard.
