#!/usr/bin/env sh
# Lightweight Gradle bootstrapper. Downloads the pinned Gradle distribution when needed.
set -eu
APP_HOME=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
GRADLE_VERSION="8.7"
GRADLE_HOME="${GRADLE_USER_HOME:-$HOME/.gradle}/wrapper/dists/gradle-${GRADLE_VERSION}-bin/local"
GRADLE_BIN="$GRADLE_HOME/gradle-${GRADLE_VERSION}/bin/gradle"
if [ ! -x "$GRADLE_BIN" ]; then
  mkdir -p "$GRADLE_HOME"
  ARCHIVE="$GRADLE_HOME/gradle-${GRADLE_VERSION}-bin.zip"
  if command -v curl >/dev/null 2>&1; then
    curl -fL "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o "$ARCHIVE"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$ARCHIVE" "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
  else
    echo "curl or wget is required to download Gradle." >&2; exit 1
  fi
  unzip -q -o "$ARCHIVE" -d "$GRADLE_HOME"
fi
exec "$GRADLE_BIN" "$@"
