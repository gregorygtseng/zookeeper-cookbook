# CHANGELOG for zookeeper

This file is used to list changes made in each version of zookeeper.

## v5.0.2

### Fixes

* Update to working Apache mirror (#170 #178)

## v5.0.1

### Fixes

* Drop pinning of apt cookbook to avoid transitive depsolving pain

## v5.0.0

### Breaking

* Use java-cookbook-installed version of Java by way of the `$JAVA_HOME` env var

### Fixes

* Ensure `zookeeper-env.sh` gets the correct values:
    - Properly set `node[zookeeper][config_dir]` with lazy interpolation of the `node[zookeeper][version]` attribute
    - Use lazy evaluation for `exports_config`
* Export some env vars for subshelled SysV-run services

### Other changes

* Add proper testing suite using RuboCop, Foodcritic, ChefSpec, and Test Kitchen, automated w/ Travis CI
* Pin dependency versions to avoid breaking changes being introduced from upstream

## v4.1.0

* Add ability to configure JMX port & local only settings via attributes (#172 @felka)

## v4.0.0

* Upgrade to ZooKeeper 3.4.8

## v3.0.6

* Add `initLimit` and `syncLimit` to ZooKeeper config (#171)

## v3.0.5

* Use `node[zookeeper][user]` attribute consistently
* Fix user for runit-managed service style (#166 #167)

## v3.0.4

* Add missing `user_home` attribute to `zookeeper` resource

## v3.0.3

* Ensure `zookeeper` user has a home folder (#163, #164)

## v3.0.2

* Roll back to version 3.4.6 as per a [deadlock issue](https://issues.apache.org/jira/browse/ZOOKEEPER-2347) found by @eherot on #156

## v3.0.1

* Run apt-get update at compile time
* Use lazy evaluation for `config_dir` (#153, h/t to @Maniacal)
* Update to testing using Chef 12.x
    - Works around the fact that Serverspec requires a version of net-ssh that needs Ruby >= 2.0

## v3.0.0

* Fix setting of `CLASSPATH` to have version dynamically set
* Upgrade to ZooKeeper 3.4.7, due to the disappearance of ZK 3.4.6 at the chosen mirror
    - Upgrading ZK is potentially breaking

## v2.13.1

* Switch to using `value_for_platform_family()` to determine the SysV service script provider to use
    - Makes the cookbook less restrictive w/r/t using it on a RHEL-based OS

## v2.13.0

* Improve generally for better CentOS support (#146)
* Create ZooKeeper log dir on installation (#147)
* Add SysV support for CentOS systems not using Upstart/Runit/Exhibitor
* Fix testing by dropping usage of Chef Zero
    - Not sure why Chef Zero won’t work, but it’d be nice to get it going again
    - Seems to complain about not being able to find something w/r/t the tester cookbook

## v2.12.0

* Add ability to configure znode ACL via node LWRP (#145 thanks @Annih)
* Create zookeeper user as system user (#142 thanks @petere)
* Update to prelease `runit` cookbook b/c of a bug in that cookbook
    - Soon as the next release of it is cut, we can revert e371719
* Switch to chef-zero for the Test Kitchen provisioner

## v2.11.0

* Fix logic around creating `zookeeper-env.sh` (Fixes #141)
* Add tests for default attributes & using `node[zookeeper][env_vars]`
* Add JAVA_OPTS attribute (#144, thanks @andrewgoktepe)

## v2.10.0

* Move creation of `zookeeper-env.sh` to `zookeeper::install`, to allow cookbooks that only call that recipe (e.g., [`exhibitor`](https://github.com/SimpleFinance/cookbook-exhibitor))
* Relax permissions on ZK install_dir (#140)

## v2.9.0

* Add creation & configuration of `zookeeper-env.sh`, an optional file to bring in custom EnvVars for Zookeeper to use
* Fix typo in source for SysV init script (#139)

## v2.8.0

* Proper init support (contributed by @shaneramey)

## v2.7.0

* Add some tests
* Fix up zookeeper_node
* Call runit recipe before service declaration

## v2.6.0

* Run apt::default and update at compille time if on Debian (#127)

## v2.5.1

* Report `zookeeper_config` as updated only if zoo.cfg is updated (#110)
* Fix `zk_installed` return value (#113)
* Fix docs (#114, #115)
* Fix for undefined new method error (#116)
* Always install `build-essential`, regardless of usage of `java` cookbook

## v2.5.0

* Allow configurable `data_dir` parameter for Zookeeper data directory location
  (contributed by @eherot)

## v2.4.3

* Fix erroneous attribute reference

## v2.4.2

* Allow pre-installed Java (contributed by @solarce)

## v2.4.1

* Fixed recipe call (contributed by @solarce)

## v2.4.0

* Split out config rendering to separate recipe (contributed by @solarce)

## v2.3.0

* Split out installation to a separate recipe (contributed by @Gazzonyx)

## v2.2.1

* Set minimum build-essential version for RHEL support (contributed by
  @Gazzonyx)

## v2.2.0

* Upstart support (contributed by @solarce)

## v2.1.1

* Added a service recipe which can be run and activated using new `service_style`
  attribute.

## v2.1.0

* A basic configuration is rendered by default.
* Clarify some points in the README about `zookeeper_config`

## v2.0.0

* Exhibitor cookbook factored out (contributed by @wolf31o2)
* Zookeeper recipe rewritten as LWRP
* Documentation updated slightly
* Tested and verified and (hopefully) as backwards-compatible as possible
  - Being a full version bump, there are no backwards-compatibility promises
* TODO
  - Better documentation
  - `zookeeper_service` resource
  - `zookeeper_config` resource
  - Better tests
  - Swap out "community" Java

## v1.7.4

* Force build-essential to run at compile time (contributed by @davidgiesberg)

## v1.7.3

* Bugfix for attribute access (fixes 1.7.2 bug)

## v1.7.2

* Move ZK download location calculation to recipe to eliminate ordering bug

## v1.7.1

* Test-kitchen support added
* Patch installed to support CentOS platform

## v1.7.0

* Switched to Runit for process supervision (contributed by @gansbrest)
* DEPRECATION WARNING: Upstart is no longer supported and has been removed
* Re-add check-local-zk.py script but punt on utilizing it
* This means we recommend staying on 1.6.1 or below if you use Upstart
* In the meantime, we are working on a strategy to integrate this functionality
  into the Runit script, to support dependent services

## v1.6.0

* Attribute overrides to defaultconfig should now work (contributed by @trane)

## v1.5.1

* Add correct (Apache v2) license to metadta.rb (#61)

## v1.5.0

* Add logic to download existing exhibitor jar

## v1.4.10

* changes: Skip S3 credentials file if AWS credentials are not provided

### OpsWorks related changes

* Moved property files from inaccessible chef dir to exhibitor install dir.
* Logged output to syslog.
* Added option to set exhibitor/amazon log level

## v1.4.9

* Added: s3credentials template to assist with --configtype s3

## v1.4.8

* Added config hook and default for servers-spec setting
* bugfix: cache permission denied error on exhibitor jar move
* bugfix: ZooKeeper install tar cache EACCES error

## v1.4.7

* bugfix: zk_connect_str actually returned when chroot passed.
* forward zk port in vagrant

## v1.4.4

* fix for backwards compatibility with ruby 1.8.7

## v0.1.0:

* Initial release of zookeeper
