#!/bin/bash - 
#===============================================================================
#
#          FILE:  version.sh
# 
#         USAGE:  ./version.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: David Becerril (dbv), email@davebv.com
#       COMPANY: 
#       CREATED: 18/04/2010 23:15:14 CEST
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

#!/bin/sh

# Xcode auto-versioning script for git by Andre Arko
#   This script will set your CFBundleVersion number to the name of the most recent
#   git tag, and include the current commit's distance from that tag and sha1 hash

# With tag "v1.0", and two commits since then, the build will be:
#   v1.0 (b2 h12345)

# Create new tags with "git tag <version> -m <message>"

# based on the ruby script by Abizern which was
# based on the git script by Marcus S. Zarra and Matt Long which was
# based on the Subversion script by Axel Andersson

# Uncomment to only run when doing a Release build
# if ENV["BUILD_STYLE"] != "Release"
#   puts "Not a Release build."
#   exit
# end

gitnum=`/opt/local/bin/git describe --long`
gitnum0=`echo $gitnum | awk -F '-' '{for (i=1;i<NF-1;i++){version = version $i}}END{print version}'`
gitnum1=`echo $gitnum | awk -F '-' '{print $(NF-1)}'`
gitnum2=`echo $gitnum | awk -F '-' '{print $(NF)}'`
version="$gitnum0 (b$gitnum1 $gitnum2)"
echo $version
info_file="Info.plist"

sed  -E 's!\([\t ]*<key>CFBundleVersion</key>\n[\t ]*<string>\).*\(</string>\)!\1$version\2!' $info_file
sed  -E 's!\([\t ]*<key>CFBundleGitVersion</key>\n[\t ]*<string>\).*\(</string>\)!\1$version\2!' $info_file
sed  -E 's!\([\t ]*<key>CFBundleShortVersionString</key>\n[\t ]*<string>\).*\(</string>\)!\1$version\2!' $info_file

#info_file= File.join(ENV['BUILT_PRODUCTS_DIR'], ENV['INFOPLIST_PATH'])
#info = File.open(info_file, "r").read

#version_re = /([\t ]+<key>CFBundleVersion<\/key>\n[\t ]+<string>).*?(<\/string>)/
#info =~ version_re
#bundle_version_string = $1 + version + $2

#info.gsub!(version_re, bundle_version_string)
#File.open(info_file, "w") { |file| file.write(info) }
echo "Set version string to '${version}'"

