#!/bin/bash
set -e

# Script to update the Homebrew formula with a new release
# Usage: ./update-formula.sh v1.5.0

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version-tag>"
    echo "Example: $0 v1.5.0"
    exit 1
fi

VERSION_TAG="$1"
VERSION_NUMBER="${VERSION_TAG#v}" # Remove 'v' prefix

echo "🔄 Updating Homebrew formula for version $VERSION_TAG"

# Download the release tarball and calculate SHA256
TARBALL_URL="https://github.com/pem725/NeuronAutomator/archive/refs/tags/${VERSION_TAG}.tar.gz"
echo "📥 Downloading tarball from: $TARBALL_URL"

TEMP_FILE=$(mktemp)
curl -L -o "$TEMP_FILE" "$TARBALL_URL"

if [ ! -s "$TEMP_FILE" ]; then
    echo "❌ Error: Failed to download tarball or file is empty"
    rm -f "$TEMP_FILE"
    exit 1
fi

SHA256=$(shasum -a 256 "$TEMP_FILE" | cut -d' ' -f1)
rm -f "$TEMP_FILE"

echo "✅ SHA256: $SHA256"

# Update the formula
FORMULA_FILE="Formula/neuron-automator.rb"

# Create backup
cp "$FORMULA_FILE" "${FORMULA_FILE}.backup"

# Update version and SHA256
sed -i '' "s|url.*github.com/pem725/NeuronAutomator/archive.*|url \"https://github.com/pem725/NeuronAutomator/archive/refs/tags/${VERSION_TAG}.tar.gz\"|" "$FORMULA_FILE"
sed -i '' "s|sha256.*|sha256 \"$SHA256\"|" "$FORMULA_FILE"

echo "✅ Updated formula file"

# Show the changes
echo ""
echo "📋 Changes made:"
diff "${FORMULA_FILE}.backup" "$FORMULA_FILE" || true

# Validate the formula
echo ""
echo "🧪 Testing formula..."
if command -v brew >/dev/null 2>&1; then
    brew audit --strict --online "$FORMULA_FILE"
    brew style "$FORMULA_FILE"
    echo "✅ Formula validation passed"
else
    echo "⚠️  Homebrew not installed, skipping validation"
fi

# Clean up backup
rm -f "${FORMULA_FILE}.backup"

echo ""
echo "🎉 Formula updated successfully!"
echo ""
echo "📝 Next steps:"
echo "   1. Review the changes: git diff"
echo "   2. Test locally: brew install --build-from-source ./Formula/neuron-automator.rb"
echo "   3. Commit changes: git add . && git commit -m \"Update to $VERSION_TAG\""
echo "   4. Push to GitHub: git push origin main"
echo ""