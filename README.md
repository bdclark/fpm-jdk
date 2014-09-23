# Build Oracle JDK packages using Effing Package Manager (FPM)

**THIS REPO IS UNDER CONSTRUCTION**


## Usage of Installed Package(s)

Interactive alternative settings:
```
update-alternatives --config java           # symlinks JRE to /usr/bin and /usr/lib/jvm/jre
update-alternatives --config javac          # symlinks JDK to /usr/bin and /usr/lib/jvm/java
# To override additional openjdk symlinks:
update-alternatives --config jre_1.7.0      # symlinks JRE to /usr/lib/jvm/jre-1.7.0
update-alternatives --config java_sdk_1.7.0 # symlinks JDK to /usr/lib/jvm/java-1.7.0
```

Same as above, but non-interactively set to specific installed JDK:
```
update-alternatives --set java /usr/lib/jvm/jdk1.7.0_67/jre/bin/java
update-alternatives --set javac /usr/lib/jvm/jdk1.7.0_67/bin/javac
# To additionally override openjdk symlinks
update-alternatives --set jre_1.7.0 /usr/lib/jvm/jdk1.7.0_67/jre
update-alternatives --set java_sdk_1.7.0 /usr/lib/jvm/jdk1.7.0_67
```

## Building a package
### Requirements:

* `rpmbuild` (`brew install rpm` on OSX or `apt-get install rpmbuild` on Ubuntu)
* `ruby`
* `fpm` gem
* a pre-downloaded Oracle JDK tarball (e.g. `jdk-7u67-linux-x64.gz`)

***Note:*** The script assumes you're using bundler for ruby to install fpm: `bundle install fpm`

### Run the build script:
```
./build-jdk-rpm.sh /path/to/oracle_jdk_tarball
```

TODO:

* Get debs working
* Support JDK 8
* Support RPMs and DEBs other than 64-bit
* More testing
* Facilitate push to S3?
