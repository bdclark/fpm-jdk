#!/usr/bin/env bash
set -e

err_out() { cat <<< "Error: $@" 1>&2; exit 1; }

jdk_path=$1
[[ -f $jdk_path ]] || err_out "${jdk_path} does not exist"
jdk_name=$(basename $jdk_path)

regex='^jdk-([7-8])u([0-9]+)-linux-[x|i]([0-9]+).gz$'

mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
script_dir=$mydir/scripts
pkg_dir=$mydir/pkg

if [[ ! $jdk_name =~ $regex ]]; then
 err_out "'${jdk_name}' - unrecognized format, must be jdk-7/jdk-8 tarball (.gz)"
fi

ver="${BASH_REMATCH[1]}"
minor_ver="${BASH_REMATCH[2]}"
arch="${BASH_REMATCH[3]}"

# Not yet supporting jdk-8
[[ $ver -eq 8 ]] && err_out "jdk-8 not yet supported"

[[ ! $arch -eq 64 ]] && err_out "Currently only supports 64-bit jdk"

cd $mydir

# Clean build directory and extract tarball
rm -rf -- build
mkdir build
tar -xzf $jdk_path -C build
jdk_src_dir=$(ls build)

# Compress man page files
gzip build/$jdk_src_dir/man/man1/*.1

# Build RPM
[[ -d  "$mydir/pkg" ]] || mkdir pkg
bundle exec fpm -s dir -t rpm --name oracle-jdk7 --version $minor_ver \
--template-scripts \
--after-install $script_dir/rpm-after-install.erb \
--before-remove $script_dir/rpm-before-remove.erb \
--prefix /usr/lib/jvm/$jdk_src_dir \
--directories /usr/lib/jvm/$jdk_src_dir \
--package pkg \
-C build/$jdk_src_dir .

rm -rf -- build
