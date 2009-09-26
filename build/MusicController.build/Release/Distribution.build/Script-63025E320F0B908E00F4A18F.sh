#!/bin/bash
#!/bin/bash
set -o errexit


[ $BUILD_STYLE = Release ] || { echo Distribution target requires "'Release'" build style; false; }

VERSION=$(defaults read "$BUILT_PRODUCTS_DIR/$PROJECT_NAME.app/Contents/Info" CFBundleVersion)
SHORT_VERSION=$(defaults read "$BUILT_PRODUCTS_DIR/$PROJECT_NAME.app/Contents/Info" CFBundleShortVersionString)
DOWNLOAD_BASE_URL="http://musiccontroller.googlecode.com/files"
RELEASENOTES_URL="http://code.google.com/p/musiccontroller/source/detail?r=$VERSION"

ARCHIVE_FILENAME_ZIP="$PROJECT_NAME.$SHORT_VERSION.$VERSION.zip"
ARCHIVE_FILENAME="$PROJECT_NAME.$SHORT_VERSION.$VERSION.dmg"
DOWNLOAD_URL="$DOWNLOAD_BASE_URL/$ARCHIVE_FILENAME"
KEYCHAIN_PRIVKEY_NAME="Sparkle Private Key 1"

WD=$PWD
cd "$BUILT_PRODUCTS_DIR"
rm -f "$PROJECT_NAME"*.zip
zip -qr "$ARCHIVE_FILENAME_ZIP" "$PROJECT_NAME.app"

rm -f "$PROJECT_NAME"*.dmg

dmgcanvas -t $SRCROOT/MusicControllerDMG.dmgCanvas -o $BUILT_PRODUCTS_DIR/$ARCHIVE_FILENAME

SIZE=$(stat -f %z "$ARCHIVE_FILENAME")
PUBDATE=$(date +"%a, %d %b %G %T %z")
SIGNATURE=$(
	openssl dgst -sha1 -binary < "$ARCHIVE_FILENAME" \
	| openssl dgst -dss1 -sign <(security find-generic-password -g -s "$KEYCHAIN_PRIVKEY_NAME" 2>&1 1>/dev/null | perl -pe '($_) = /"(.+)"/; s/\\012/\n/g') \
	| openssl enc -base64
)

[ $SIGNATURE ] || { echo Unable to load signing private key with name "'$KEYCHAIN_PRIVKEY_NAME'" from keychain; false; }

cat <<EOF
		<item>
			<title>Version $SHORT_VERSION $VERSION</title>
			<sparkle:releaseNotesLink>$RELEASENOTES_URL</sparkle:releaseNotesLink>
			<pubDate>$PUBDATE</pubDate>
			<enclosure
				url="$DOWNLOAD_URL"
				sparkle:version="$VERSION"
				sparkle:shortVersionString="$SHORT_VERSION"
				type="application/octet-stream"
				length="$SIZE"
				sparkle:dsaSignature="$SIGNATURE"
			/>
		</item>
EOF

#echo scp "'$HOME/svn/my-cool-app/build/Release/$ARCHIVE_FILENAME'" www.example.com:download/
#echo scp "'$WD/appcast.xml'" www.example.com:web/software/my-cool-app/appcast.xml
