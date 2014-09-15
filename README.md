# Build Oracle JDK packages using Effing Package Manager (FPM)

**THIS REPO IS UNDER CONSTRUCTION**


## Usage and Examples

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

## Build examples
Requirments:

* `rpmbuild` (on Ubuntu)
* `ruby`
* `fpm` gem

The following examples assumes you've downloaded `jdk-7u67` from Oracle's
download site into the `cache` directory.

Extract tarball:
```
$ tar -xzf jdk-7u67-linux-x64.tar.gz
```

For an RPM:
```
$ fpm -s dir -t rpm --name oracle-jdk7 --version 67 \
--template-scripts \
--after-install ./scripts/after-install.sh.erb \
--after-remove ./scripts/after-remove.sh.erb \
--prefix /usr/lib/jvm/jdk1.7.0_67 \
--directories /usr/lib/jvm/jdk1.7.0_67 \
--package ./pkg \
-C jdk1.7.0_67 .
```

For a deb (STILL TODO - may need own pre/post scripts):
```
$ fpm -s dir -t deb --name oracle-jdk7 --version 67 \
--template-scripts \
--after-install ./scripts/after-install.sh.erb \
--after-remove ./scripts/after-remove.sh.erb \
--prefix /usr/lib/jvm/jdk1.7.0_67 \
-C jdk1.7.0_67 .
```

TODO:

* Get ubuntu/debian working
* More testing
* Additional automation/scripting
* Possibly consider fpm-cookery
* Facilitate push to S3?