# win32-service Change Log

<!-- latest_release 2.4.0 -->
## [win32-service-2.4.0](https://github.com/chef/win32-service/tree/win32-service-2.4.0) (2025-06-30)

#### Merged Pull Requests
- Updating for Ruby 3.4 and Cookstyle [#87](https://github.com/chef/win32-service/pull/87) ([johnmccrae](https://github.com/johnmccrae))
<!-- latest_release -->

<!-- release_rollup since=2.3.2 -->
### Changes not yet released to rubygems.org

#### Merged Pull Requests
- Updating for Ruby 3.4 and Cookstyle [#87](https://github.com/chef/win32-service/pull/87) ([johnmccrae](https://github.com/johnmccrae)) <!-- 2.4.0 -->
<!-- release_rollup -->

<!-- latest_stable_release -->
## [win32-service-2.3.2](https://github.com/chef/win32-service/tree/win32-service-2.3.2) (2021-11-08)

#### Merged Pull Requests
- daemon: Enable to handle user defined control codes [#74](https://github.com/chef/win32-service/pull/74) ([ashie](https://github.com/ashie))
- Add PR testing in Buildkite [#75](https://github.com/chef/win32-service/pull/75) ([tas50](https://github.com/tas50))
- Resolve the majority of chefstyle violations [#76](https://github.com/chef/win32-service/pull/76) ([tas50](https://github.com/tas50))
<!-- latest_stable_release -->

## [win32-service-2.2.0](https://github.com/chef/win32-service/tree/win32-service-2.2.0) (2020-11-20)

#### Merged Pull Requests
- Refactor ::status with new methods [#64](https://github.com/chef/win32-service/pull/64) ([jasonwbarnett](https://github.com/jasonwbarnett))

## [win32-service-2.1.6](https://github.com/chef/win32-service/tree/win32-service-2.1.6) (2020-08-17)

#### Merged Pull Requests
- Optimize requires for non-omnibus installs [#72](https://github.com/chef/win32-service/pull/72) ([tas50](https://github.com/tas50))

## [win32-service-2.1.5](https://github.com/chef/win32-service/tree/win32-service-2.1.5) (2020-01-30)

#### Merged Pull Requests
- removed secondary SERVICE_STATUS_PROCESS class from structs [#71](https://github.com/chef/win32-service/pull/71) ([Dreweasland](https://github.com/Dreweasland))

## [win32-service-2.1.4](https://github.com/chef/win32-service/tree/win32-service-2.1.4) (2019-04-17)

#### Merged Pull Requests
- Require Ruby 2.3 + misc changes [#63](https://github.com/chef/win32-service/pull/63) ([tas50](https://github.com/tas50))
- Bugfix: NoMethodError in Win32::Service.new [#67](https://github.com/chef/win32-service/pull/67) ([jasonwbarnett](https://github.com/jasonwbarnett))

## [win32-service-2.1.2](https://github.com/chef/win32-service/tree/win32-service-2.1.2) (2019-03-22)

#### Merged Pull Requests
- Slim our gem size and unify our rake tasks [#54](https://github.com/chef/win32-service/pull/54) ([tas50](https://github.com/tas50))
- Require Ruby 2.2 or later [#58](https://github.com/chef/win32-service/pull/58) ([tas50](https://github.com/tas50))
- Add ::delayed_start method [#59](https://github.com/chef/win32-service/pull/59) ([jasonwbarnett](https://github.com/jasonwbarnett))
- DRY up the calls to ::CloseServiceHandle [#61](https://github.com/chef/win32-service/pull/61) ([jasonwbarnett](https://github.com/jasonwbarnett))
- Add open_sc_manager and open_service helpers + add in rspec testing [#62](https://github.com/chef/win32-service/pull/62) ([jasonwbarnett](https://github.com/jasonwbarnett))
- Bugfix: restore original behavior of ::delayed_start [#65](https://github.com/chef/win32-service/pull/65) ([jasonwbarnett](https://github.com/jasonwbarnett))

## [win32-service-1.0.1](https://github.com/chef/win32-service/tree/win32-service-1.0.1) (2018-06-29)

## 0.8.10 - 11-Dec-2016
* Fixed a bug where action resolution information was not correct. Thanks go
  to BXII-Dave for the spot and patch.

## 0.8.9 - 26-Jun-2016
* Added the ffi-win32-extensions dependency.
* Changed the way service dependencies are determined.
* Removed the helper.rb file since it's no longer used.

## 0.8.8 - 24-Jun-2016
* Fixed the function prototypes for CreateEvent and AdjustTokenPrivileges
  where I was using :bool instead of :int.
* Updated the various FFI module wrapper names so that they're more distinctly
  namespaced. Avoids a clash with the win32-eventlog gem, and possibly others.
* Discovered more places where QueryServiceConfig2 could fail while attempting
  to get failure actions and delayed auto start info. Instead of failing,
  these now set their respective data to nil.
* A timeout value in our main observer thread was increased to potentially
  improve performance. Feedback welcome.
* This gem is now signed.
* Added the win32-service.rb and win32-daemon.rb files for convenience.
* Use require_relative internally.
* Added win32-security as a development dependency. It was already being used
  for tests but now it's actually part of the gemspec.
* Many tests are now skipped unless run with administrative privileges, either
  because they require it, or because they otherwise take too long.
* Gem related tasks in the Rakefile now assume Rubygems 2.x.
* Added an appveyor.yml file.
* The DemoDaemon example will create C:/Tmp if it doesn't already exist.

## 0.8.7 - 14-Jul-2014
* Fixed a bug in the SERVICE_DELAYED_AUTO_START_INFO struct. It now returns 0
  or 1, though it still accepts true or false as arguments. Thanks go to
  Kartik Null Cating-Subramanian for the spot.

## 0.8.6 - 21-Aug-2014
* Some internal changes that make stopping a service more robust. Thanks go
  to Ethan J. Brown for the patches.
* Renamed the constants module to avoid name clashes. Thanks go to Michael
  Smith for the spot.

## 0.8.5 - 2-Jul-2014
* The service type for Service.new no longer defaults to being an interactive
  process. This could cause process credential issues and wasn't very
  useful in practice anyway. Thanks go to Pierre Ynard for the report.
* More tests skipped unless run with admin privileges.
* Use relative_require instead of doing things manually.
* Minor memory efficieny improvements.
* Skip errors on ERROR_RESOURCE_TYPE_NOT_FOUND when getting service config info. Thanks go to Rob Reynolds for the patch.

## 0.8.4 - 23-Jan-2014
* Cleaned up some unused and/or misnamed variables.
* Automatically require devkit in Rakefile if mingw.
* Added a patch that warns, instead of fails, if a resource is misconfigured
  in the Service.services method. Thanks go to Josh Cooper for the patch.
* Fixed the service test that ensures that trying to start an already running
  service will raise an error. Thanks again to Jim Arnold for the patch.

## 0.8.3 - 1-Nov-2013
* Fixed a bug where a service's state could be changed when merely
  interrogating the service. Thanks go to Glenn Sarti / Puppet Labs
  for the spot.
* Fixed a bug where attempting to get the description of a service that
  has no description could raise an error. Now an empty string is returned.

## 0.8.2 - 13-Aug-2013
* Fixed a bug in the Service.start method where it was not handling arguments
  properly. Thanks go to Sean Karlage for the spot.

## 0.8.1 - 2-Aug-2013
* Fixed the failure actions code for the Service#configure method
  so that it is also using FFI.
* An internal fix for the Daemon class was added. In short, you no longer
  need to, nor should you, call exit! in a service_stop method. Thanks go
  to Adrian Candaten for pointing out the issue in general.
* Made FFI functions private.
* Added Rake as a development dependency.
* Removed an internal helper function that was no longer being used.

## 0.8.0 - 19-Jun-2013
* Converted all code to use FFI. This includes the Daemon code, which means
  that it also now works with JRuby.

## 0.7.2 - 7-Sep-2011
* Now works with mingw compiler by skipping __try and __finally if using
  mingw, or using them with mingw if the seh.h header is found.
* The binary gem now contains binaries for both Ruby 1.8.7 and 1.9.2 using
  a simple wrapper.
* Updated some Rake tasks.

## 0.7.1 - 9-Feb-2010
* Compatibility fixes for 1.9.x.
* Fixed a bug where the controls_accepted struct member was always nil. This
  has been fixed and now always returns an array.
* Added 'pre-shutdown' as possible values for the list of controls accepted.
* Changed test-unit from a runtime dependency to a development dependency.
* Some tests were refactored to be more reliable.
* Refactored the Rakefile and gemspec.

## 0.7.0 - 30-Jun-2009
* INTERFACE CHANGE: The Service.new and Service.configure methods now accept
  a single hash argument only. The :service_name key is mandatory, while the
  :host key is optional.
* Fixed a bug in the Service.services method where a segfault would occur if
  the binary_path_name was greater than 260 characters. The buffer size has
  been increased to 1024 characters. Thanks go to Dan Daniels for the spot.
* Altered the Daemon class so that the Ruby interpreter was not invoked within
  the Service_Main function. The functions that close stdin, stdout and stderr
  are now called within the mainloop method. Thanks go to Tim Hanson for the
  spot and the patch.
* Eliminated a minor build warning in daemon.c
* License changed to Artistic 2.0, with corresponding gemspec update.
* Added an uninstall rake task.
* Updated the service_stop method in the demo_daemon.rb file, and added some
  additional comments.
* The test files were renamed.
* Several tests were updated and refactored to use Test::Unit 2.x. That
  library is now a dependency.
* The 'uninstall' Rakefile task is now more verbose.

## 0.6.1 - 1-Jan-2008
* The Service.services method now handles the scenario where a particular
  service may still exist, but its underlying registry entry has been deleted.
  In this case, most ServiceInfo struct members are set to nil and a warning
  is issued.
* RDoc updates.

## 0.6.0 - 25-Nov-2007
* The Service control class is now pure Ruby. The Daemon class is still C,
  however. That may change in the future. This means the windows-pr
  library is now a prerequisite.
* The Service.new method has been altered in a way that is not backwards
  compatible. It is now the same as Service.create.
* The Service.start method now properly handles arguments to the
  Daemon#service_main method.
* The Daemon source code is now separate from the Service control class
  source code. That means you must require them separately, as needed.
* The Daemon class should be much more responsive to service events now,
  especially service_stop. Many thanks go to Kevin Burge for the patch.
* Added the Daemon.mainloop method as a shortcut for Daemon.new.mainloop.
* The Daemon class now redirects STDIN, STDOUT and STDERR to the NUL device
  if they're still associated with a terminal when the service starts. This
  should help prevent Errno::EBADF errors.
* The Service.services class method now supports the group parameter for
  versions of Ruby built with older compilers, i.e. it will now work with
  the one-click Ruby installer.
* The Service.getdisplayname method was changed to Service.get_display_name.
  An alias has been provided for backwards compatibility.
* The Service.getservicename method was changed to Service.get_service_name.
  An alias has been provided for backwards compatibility.
* Added the Service.config_info method.
* The Service.create and Service.configure methods now allow you to set
  failure actions, failure commands, and reset/retry periods.
* Improved test suite.
* Changed 'tdaemon.rb', 'tdaemon_ctl.rb' and 'service_test.rb' to
  'demo_daemon.rb', 'demo_daemon_ctl.rb' and 'demo_services.rb', respectively.
* Some refactoring and updates to the demo daemon and demo daemon controller
  examples.
* The Win32Service struct is now ServiceInfo.
* ServiceError is now Service::Error.
* DaemonError is now Daemon::Error.
* Some documentation improvements, corrections and updates.

## 0.5.2 - 25-Nov-2006
* Fixed a bug in the Daemon class where the service event handling methods
  (most notably service_stop) did not work properly due to thread blocking
  issues.  Many thanks go to Patrick Hurley for the patch.
* Added the Daemon#running? method as helper method for your service_main
  method.
* The 'interactive?' struct member is now just 'interactive'.  This was
  supposed to have been in the last release but was somehow missed.  Sorry.
* Scrapped the old daemon_test.rb file and split it into two new files -
  tdaemon.rb and tdaemon_ctl.rb.  In the process a few bugs were fixed.
* Added a gemspec.
* Documentation and test suite updates.

## 0.5.1 - 18-Jun-2006
* Added the Service.open method.
* The Service.new method now accepts a block, and automatically closes itself
  at the end of the block.
* Fixed in a bug in the Service.create method where setting dependencies
  was not working properly.  Thanks go to Scott Harper for the spot.
* The 'interactive?' struct member is now just 'interactive' since Ruby no
  longer supports question marks in struct member names.  UGH.
* The block for Service#configure_service is no longer optional.
* Replaced ClipSrv with W32Time for most of the test methods in tc_service.rb
  because it had a dependency that is disabled on most systems.
* Added a tweak to the extconf.rb file to help with the test suite.
* Some documentation updates and corrections.

## 0.5.0 - 26-Nov-2005
* Added a service_init hook, and (internally) altered the way the service
  starts.  This was done to deal with services that need to perform any
  initialization in the Daemon itself before the service starts.  Previously
  this would result in the service timing out during startup.

  Thanks go to Jamey Cribbs for spotting the problem.

* Modified the Daemon example, adding a service_init hook that does about 10
  seconds worth of initialization before finally starting.  See the comments
  in examples\daemon_test.rb for more information.
* Minor test and README changes.

## 0.4.6 - 24-May-2005
* Fixed an initialization bug that could cause Daemons to fail unless the
  win32-service package was the last package require'd.
* Altered the Service.start method.  It now takes any number of arguments
  (after the service and host name).  These arguments are passed to the
  service's Service_Main() function.
* The Service.services method now returns an Array of ServiceStruct's in
  non-block form.
* The Service.start, Service.pause, Service.resume, Service.stop and
  Service.delete methods now return the class (self), not 'true'.
* Added the ability to add or configure the service description in
  Service#create_service or Service#configure, respectively.
* Fixed a bug in the Service.start method where false positives could result.
* Updated the ServiceStatus struct to include pid and service_flags on Win2k
  or later.
* Unicode is now the default setting as far as internal string handling.  It
  will still work fine with 'regular' text.
* Added safe string handling for string input values.
* Added rdoc comments into the C source.
* Made the service.txt and daemon.txt files rdoc friendly.
* Removed the service.rd and daemon.rd files.  If you want html documentation,
  run rdoc over the service.txt and daemon.txt files.
* The dreaded "code cleanup".

## 0.4.5 - 28-Feb-2005
* Fixed an accessor bug in Service#create.  Thanks go to Nathaniel Talbott
  for the spot.
* Eliminated a warning that appeared starting in Ruby 1.8.2 regarding Struct
  redefinitions.
* Moved 'examples' directory to toplevel directory.
* Deleted the 'test2.rb' example.  This was supplanted by the 'daemon_test.rb'
  script.
* Renamed the 'test.rb' file to 'services_test.rb'.
* Made this document rdoc friendly.

## 0.4.4 - 27-Aug-2004
* Modified the Service class to use the newer allocation framework.  The
  Daemon class already used this, hence no major version bump.
* Fixed in a bug in the create_service() method with regards to the
  'dependencies' option and null arguments (you no longer need to specify
  an empty array).

## 0.4.3 - 14-Aug-2004
* Fixed the Daemon class by adding back the constants it needed in order to
  run.  I accidentally broke this when I changed the Daemon class from being
  a subclass of Service to being its own class.
* Added a separate test suite for the Daemon class, tc_daemon.rb, to help
  me from making that mistake ever again. :)
* Updated the daemon_test.rb script a bit to report error messages should
  any occur.
* Minor doc updates

## 0.4.2 - 10-Jul-2004
* The Daemon class is no longer a subclass of Service.
* Added the 'pid' and 'service_flags' struct members to the Win32Service
  struct.  These members are only available to folks using Windows 2000 or
  later and who compile with VC++ 7.0 or later (including the .NET SDK).
* The Service.services method now accepts a group name as an optional third
  argument.  Again, you must be using Windows 2000 or later and compile with
  VC++ 7.0 or later (including the .NET SDK).
* The deprecated STR2CSTR() functions were replaced with StringValuePtr().
  This also means that as of this version, win32-service requires Ruby
  1.8.0 or greater.
* Moved the sample programs to doc/examples
* Removed the .html files under /doc.  You can generate that on your own if
  you like.

## 0.4.1 - 14-Mar-2004
* Added the exists? class method and corresponding test suite additions.
* Pushed the ServiceError and DaemonError classes under the Win32 module.
* Normalized tc_service.rb so that it can be run outside of the test directory
  more easily.

## 0.4.0 - 9-Feb-2004
* Changed "worker" method to "service_main" method.
* Added event hooks for stop, pause, resume, etc.  See the documentation for
  further details.  (Thanks Park Heesob)
* Some of the Daemon functions were raising ServiceError.  They have been
  changed to DaemonError.
* Updated the daemon_test.rb file to use the new event hooks.
* Documentation additions and updates.

## 0.3.0 - 31-Jan-2004
* Added a Daemon subclass.  This allows you to run Ruby programs as a service.
  Please see the documentation for more details. (Thanks Park Heesob).  This
  should be considered an ALPHA release.
* The Win32ServiceError class has been renamed to just ServiceError.  I felt
  the "Win32" was redundant, given that it's already under the Win32 module.
* In some cases a bogus error description was being returned because the
  GetLastError() function was being called too late.  This has been fixed.
  (Thanks Park Heesob).
* The explicit garbage collection has been removed because what I thought was
  a memory leak was not, in fact, a memory leak.  In addition, it was hurting
  performance badly.
* The "\r\n" is now automatically stripped from error messages.  This was
  causing slightly garbled error messages.  (Thanks Park Heesob).
* Added explicit closing of the Service Control Manager handle in the
  services() function for those rare cases where it may fail while reading
  service information.
* Made some of the error strings a bit more descriptive.
* Test suite and documentation additions, including a sample daemon program
  in the test directory called "daemon_test.rb".

## 0.2.2 - 15-Jan-2004
* Fixed a mistake in the service_init declaration within Init_service().
* Fixed bug in the service_init function with regards to desired access.
* Modified service_free() function to explicitly set the hSCManager handle
  to NULL and modified the service_close() method to test hSCManager handle
  for NULL value.  This should eliminate accidentally trying to close an
  already closed handle, which may have happened as the result of a free()
  call. (Thanks Park Heesob).
* Added explicit garbage collection in Service.services() method.
* More explicit about closing open HANDLE's when error conditions arise.

## 0.2.1 - 2-Nov-2003
* Made the exported less redundant and less verbose, e.g.
  Service::SERVICE_DISABLED is now just Service::DISABLED.  The same is true
  for the service control constants, i.e. the 'SC_' has been removed.
* Corresponding test suite changes.

## 0.2.0 - 16-Oct-2003
* The constructor has been changed.  It now only takes a machine name and a
  desired access for arguments.  The keyword arguments are now part of the
  create_service method() and only in block form.  See the documentation for
  more details.
* Added a configure_service() and close() instance methods.
* Added several new constants to allow finer control over created and
  configured services.
* Added Win32ServiceError as an exception.  All failures now raise this
  error instead of a vanilla StandardError.
* Moved some common code into the service.h file.

## 0.1.0 - 10-Oct-2003
- Initial release