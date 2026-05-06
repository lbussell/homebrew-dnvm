#!/bin/bash
set -e

IMAGE_NAME="dnvm-brew-test"

echo "=== Building test image ==="
docker build --progress=plain --tag "$IMAGE_NAME" .

echo ""
echo "=== Testing dnvm in container ==="
docker run --rm "$IMAGE_NAME" bash -c '
  echo "=== dnvm --help ==="
  dnvm --help
  echo ""
  echo "=== dnvm selfinstall ==="
  dnvm selfinstall -y --skip-tracking
  echo ""
  echo "=== dnvm track lts ==="
  dnvm track lts
  echo ""
  echo "=== dnvm list ==="
  dnvm list
  echo ""
  echo "=== dotnet --version ==="
  export DOTNET_ROOT="$HOME/.local/share/dnvm/dn"
  export PATH="$DOTNET_ROOT:$PATH"
  export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
  dotnet --version
  echo ""
  echo "=== dotnet --info ==="
  dotnet --info
'

echo ""
echo "=== SUCCESS: dnvm installed and working via Homebrew ==="
