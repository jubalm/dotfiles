#!/bin/bash

# shadcn/ui Installation Validator
# This script checks if shadcn/ui is properly installed and configured

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERROR_COUNT=0

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "shadcn/ui Installation Validator"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check components.json exists
echo "Checking components.json..."
if [ -f "components.json" ]; then
  echo -e "${GREEN}✓${NC} components.json found"
else
  echo -e "${RED}✗${NC} components.json NOT found"
  echo -e "  ${YELLOW}→${NC} Run: npx shadcn@latest init -d"
  ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check utils.ts exists
echo "Checking lib/utils.ts..."
if [ -f "src/lib/utils.ts" ]; then
  echo -e "${GREEN}✓${NC} src/lib/utils.ts found"
  # Check if it contains cn function
  if grep -q "cn" src/lib/utils.ts; then
    echo -e "${GREEN}✓${NC} cn() utility function present"
  else
    echo -e "${YELLOW}⚠${NC} cn() function not found in utils.ts"
  fi
else
  echo -e "${RED}✗${NC} src/lib/utils.ts NOT found"
  echo -e "  ${YELLOW}→${NC} Run: npx shadcn@latest init -d"
  ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check for required dependencies
echo "Checking required dependencies..."
REQUIRED_DEPS=("clsx" "tailwind-merge" "class-variance-authority")
for dep in "${REQUIRED_DEPS[@]}"; do
  if npm list "$dep" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} $dep installed"
  else
    echo -e "${RED}✗${NC} $dep NOT installed"
    echo -e "  ${YELLOW}→${NC} Run: npm install $dep"
    ERROR_COUNT=$((ERROR_COUNT + 1))
  fi
done

# Check for Tailwind CSS
echo "Checking Tailwind CSS..."
if npm list "tailwindcss" > /dev/null 2>&1; then
  echo -e "${GREEN}✓${NC} tailwindcss installed"
  
  # Check version (should be v4+)
  TAILWIND_VERSION=$(npm list tailwindcss --depth=0 2>/dev/null | grep tailwindcss | sed 's/.*@//' | cut -d' ' -f1)
  if [ -n "$TAILWIND_VERSION" ]; then
    MAJOR_VERSION=$(echo "$TAILWIND_VERSION" | cut -d'.' -f1)
    if [ "$MAJOR_VERSION" -ge 4 ]; then
      echo -e "${GREEN}✓${NC} Tailwind CSS v$TAILWIND_VERSION (v4+ detected)"
    else
      echo -e "${YELLOW}⚠${NC} Tailwind CSS v$TAILWIND_VERSION (v4+ recommended)"
    fi
  fi
else
  echo -e "${RED}✗${NC} tailwindcss NOT installed"
  echo -e "  ${YELLOW}→${NC} Run: npm install -D tailwindcss @tailwindcss/vite"
  ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check CSS has Tailwind import
echo "Checking CSS configuration..."
CSS_FILES=$(find src -name "*.css" 2>/dev/null)
TAILWIND_IMPORT_FOUND=false

for file in $CSS_FILES; do
  if grep -q "@import.*tailwindcss" "$file" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Tailwind import found in $file"
    TAILWIND_IMPORT_FOUND=true
    
    # Check for CSS variables (theme tokens)
    if grep -q "\-\-background" "$file" 2>/dev/null; then
      echo -e "${GREEN}✓${NC} CSS variables (theme tokens) found in $file"
    else
      echo -e "${YELLOW}⚠${NC} CSS variables NOT found in $file"
      echo -e "  ${YELLOW}→${NC} shadcn init should have added these"
    fi
    break
  fi
done

if [ "$TAILWIND_IMPORT_FOUND" = false ]; then
  echo -e "${RED}✗${NC} Tailwind import NOT found in CSS files"
  echo -e "  ${YELLOW}→${NC} Add '@import \"tailwindcss\";' to your CSS file"
  ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check path aliases in tsconfig
echo "Checking TypeScript path aliases..."
TSCONFIG_FILES=("tsconfig.json" "tsconfig.app.json")
PATH_ALIAS_FOUND=false

for config in "${TSCONFIG_FILES[@]}"; do
  if [ -f "$config" ]; then
    if grep -q '"@/\*"' "$config" 2>/dev/null; then
      echo -e "${GREEN}✓${NC} Path aliases configured in $config"
      PATH_ALIAS_FOUND=true
    fi
  fi
done

if [ "$PATH_ALIAS_FOUND" = false ]; then
  echo -e "${RED}✗${NC} Path aliases NOT configured"
  echo -e "  ${YELLOW}→${NC} Add to tsconfig.json compilerOptions:"
  echo -e '  "baseUrl": ".", "paths": { "@/*": ["./src/*"] }'
  ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check vite.config.ts for Vite projects
if [ -f "vite.config.ts" ] || [ -f "vite.config.js" ]; then
  echo "Checking Vite configuration..."
  VITE_CONFIG="vite.config.ts"
  [ ! -f "$VITE_CONFIG" ] && VITE_CONFIG="vite.config.js"
  
  if grep -q "tailwindcss" "$VITE_CONFIG" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Tailwind plugin found in $VITE_CONFIG"
  else
    echo -e "${YELLOW}⚠${NC} Tailwind plugin NOT found in $VITE_CONFIG"
    echo -e "  ${YELLOW}→${NC} Add: import tailwindcss from '@tailwindcss/vite'"
    echo -e "  ${YELLOW}→${NC} plugins: [react(), tailwindcss()]"
  fi
  
  if grep -q "resolve.*alias" "$VITE_CONFIG" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Path alias resolver found in $VITE_CONFIG"
  else
    echo -e "${YELLOW}⚠${NC} Path alias resolver NOT found in $VITE_CONFIG"
    echo -e "  ${YELLOW}→${NC} Add: resolve: { alias: { '@': '/src' } }"
  fi
fi

# Check for any installed components
echo "Checking installed components..."
if [ -d "src/components/ui" ]; then
  COMPONENT_COUNT=$(find src/components/ui -name "*.tsx" -o -name "*.ts" 2>/dev/null | wc -l)
  if [ "$COMPONENT_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Found $COMPONENT_COUNT component(s) in src/components/ui"
    echo -e "  ${YELLOW}→${NC} Components: $(ls -1 src/components/ui | head -3 | tr '\n' ' ')"
  else
    echo -e "${YELLOW}⚠${NC} No components installed yet"
    echo -e "  ${YELLOW}→${NC} Add components with: npx shadcn@latest add button"
  fi
else
  echo -e "${YELLOW}⚠${NC} src/components/ui directory not found"
  echo -e "  ${YELLOW}→${NC} Components will be created when you add them"
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERROR_COUNT -eq 0 ]; then
  echo -e "${GREEN}✓ All critical checks passed!${NC}"
  echo "shadcn/ui is properly installed and configured."
else
  echo -e "${RED}✗ Found $ERROR_COUNT error(s)${NC}"
  echo "Review the errors above and fix them before using shadcn/ui."
  exit 1
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
