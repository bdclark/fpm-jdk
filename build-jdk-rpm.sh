#!/usr/bin/env bash
set -e

err_out() { cat <<< "Error: $@" 1>&2; exit 1; }

usage() {
cat <<EOF
Usage: ${0##*/}  -j JDK_TARBALL [-i ITERATION]
  Build Oracle JDK RPM using FPM.  Assumes FPM is installed locally using
  "bundle install fpm", and will execute fpm with "bundle exec fpm".

  Arguments:
    -j <JDK>        Path to downloaded Oracle JDK tarball (.gz or .tar.gz).
                    This argument is required.
    -i <ITERATION>  The iteration to give to the package. RPM calls this the 'release'.
                    This argument is optional; defaults to "1".
EOF
}

iteration="1"
while getopts ":hi:j:" opt; do
    case $opt in
        i)
            iteration="$OPTARG"
            ;;
        j)
            jdk_path="$OPTARG"
            [[ -f $jdk_path ]] || err_out "Oracle JDK '${jdk_path}' is invalid"
            jdk_name=$(basename $jdk_path)
            ;;
        h)
            usage
            exit 1
            ;;
        \?)
            err_out "Invalid option -${OPTARG}"
            ;;
        :)
            err_out "Option -$OPTARG requires an argument"
            ;;
    esac
done

[[ -z $jdk_path ]] && err_out "Option -j is required"

regex='^jdk-([7-8])u([0-9]+)-linux-[x|i]([0-9]+)(.tar)?.gz$'
if [[ ! $jdk_name =~ $regex ]]; then
 err_out "'${jdk_name}' - unrecognized format, must be jdk-7/8 tarball"
fi

mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
script_dir=$mydir/scripts
pkg_dir=$mydir/pkg

ver="${BASH_REMATCH[1]}"
minor_ver="${BASH_REMATCH[2]}"
arch="${BASH_REMATCH[3]}"

# Not yet supporting jdk-8
# [[ $ver -eq 8 ]] && err_out "jdk-8 not yet supported"

[[ ! $arch -eq 64 ]] && err_out "Currently only supports 64-bit jdk"

cd $mydir

# Clean build directory and extract tarball
rm -rf -- build
mkdir build
tar -xzf $jdk_path -C build
jdk_src_dir=$(ls build)
pkg_name="java-1.${ver}.0-oraclejdk"
pkg_version="1.${ver}.0.${minor_ver}"
pkg_target_dir="/usr/lib/jvm/${pkg_name}-${pkg_version}"

# Compress man page files
gzip build/$jdk_src_dir/man/man1/*.1

# Build RPM
[[ -d  "$mydir/pkg" ]] || mkdir pkg
bundle exec fpm -s dir -t rpm \
--name $pkg_name \
--version $pkg_version \
--iteration $iteration \
--template-scripts \
--after-install $script_dir/rpm-after-install-${ver}.erb \
--before-remove $script_dir/rpm-before-remove-${ver}.erb \
--prefix $pkg_target_dir \
--directories $pkg_target_dir \
--package pkg \
--rpm-os linux \
--architecture x86_64 \
-C build/$jdk_src_dir .

rm -rf -- build
