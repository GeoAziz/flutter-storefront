#!/usr/bin/env bash
set -euo pipefail

# Phase 1 Setup script for Flutter Storefront
# - ensures repo exists
# - ensures project exists
# - creates project columns (best-effort)
# - creates Phase-1 issues if missing
# Usage: ./scripts/phase1_setup.sh

REPO_OWNER="GeoAziz"
REPO_NAME="flutter-storefront"
REPO="$REPO_OWNER/$REPO_NAME"
PROJECT_NAME="Flutter Storefront – Phase 1"
PROJECT_BODY="Phase 1 Kanban board for $REPO"

USERNAME="$(gh api user --jq .login)"

echo "Running Phase 1 setup for repo: $REPO as $USERNAME"

# Ensure repo exists (idempotent)
if gh repo view "$REPO" >/dev/null 2>&1; then
  echo "Repository $REPO already exists."
else
  echo "Creating repository $REPO..."
  gh repo create "$REPO" --public --description "Production-ready Flutter UI template for a single-vendor e-commerce app. Includes onboarding, home/discovery, product pages, cart, and profile with Riverpod wiring and a mock backend scaffold. Phase 1 focuses on CI, routing, state management, cart persistence, checkout skeleton, and initial tests." --confirm
fi

# Ensure project exists (idempotent)
echo "Checking for existing project named: $PROJECT_NAME"
# Try to find project id by listing projects for owner and matching title
PROJECT_ID=$(gh project list --owner "$REPO_OWNER" --limit 200 --json id,title --jq '.[] | select(.title=="'"$PROJECT_NAME"'") | .id' 2>/dev/null || true)
if [ -n "$PROJECT_ID" ]; then
  echo "Found existing project: $PROJECT_NAME (ID: $PROJECT_ID)"
else
  echo "Creating project '$PROJECT_NAME' for owner $REPO_OWNER..."
  # Use --title flag (gh project create expects --title); avoid using --body for compatibility
  PROJECT_ID=$(gh project create --owner "$REPO_OWNER" --title "$PROJECT_NAME" --format json --jq .id)
  echo "Created project with ID: $PROJECT_ID"
fi

echo "Project ID: $PROJECT_ID"

# Best-effort: Create columns. For classic projects we create columns via API; for newer GH CLI, try 'gh project column create'.
columns=("Backlog" "Ready / Aligned" "In Progress" "In Review / QA" "Done")
for col in "${columns[@]}"; do
  echo "Ensuring column: $col"
  # Try gh project column create (if available)
  if gh project column create --help >/dev/null 2>&1; then
    gh project column create "$PROJECT_NAME" --repo "$REPO" --name "$col" 2>/dev/null || true
  else
    # Fallback to API for classic projects
    # Attempt to list existing columns and create if missing
    if gh api projects/"$PROJECT_ID"/columns --jq ".[] | select(.name==\"$col\") | .id" >/dev/null 2>&1; then
      echo "Column $col already exists"
    else
      gh api -X POST /projects/"$PROJECT_ID"/columns -H "Accept: application/vnd.github.inertia-preview+json" -f name="$col" 2>/dev/null || true
    fi
  fi
done

# Helper: create issue if not exists
create_issue_if_missing() {
  local title="$1"; shift
  local labels="$1"; shift
  local body="$1"; shift
  echo "Checking issue: $title"
  existing=$(gh issue list --repo "$REPO" --state all --limit 200 --json title --jq '.[] | select(.title=="'"$title"'") | .title' 2>/dev/null || true)
  if [ -n "$existing" ]; then
    echo " -> Issue exists: $title"
  else
    echo " -> Creating: $title"
    gh issue create --repo "$REPO" --title "$title" --body "$body" --label "$labels" --assignee "$USERNAME" || true
  fi
}

# Phase 1 issues (titles, labels, bodies)
create_issue_if_missing "Harden CI & Analyzer" "infra,critical,tests" $'## Description\nVerify and enhance the CI/CD pipeline to ensure code quality standards.\n\n## Acceptance Criteria\n- [ ] Verify .github/workflows/flutter-ci.yml workflow completeness\n- [ ] Run `flutter analyze` in all PRs (add to CI)\n- [ ] Fix any warnings/deprecations detected\n- [ ] Ensure CI passes green on all PRs\n\n## Technical Notes\n- File: .github/workflows/flutter-ci.yml\n- Check: flutter test, flutter analyze, dart format\n'

create_issue_if_missing "Route Name Standardization" "infra,critical" $'## Description\nFix "onbording" → "onboarding" across project and standardize route names.\n\n## Acceptance Criteria\n- [ ] Replace "onbording" typos across codebase\n- [ ] Update imports/routes in `lib/route/router.dart` and `lib/main.dart`\n- [ ] Verify navigation flows work after rename\n'

create_issue_if_missing "ProviderScope Wiring & ProductRepository Toggle" "backend,infra" $'## Description\nWrap app in ProviderScope and provide toggle for ProductRepository (Mock vs Remote).\n\n## Acceptance Criteria\n- [ ] Wrap ProviderScope in `lib/main.dart`\n- [ ] Add toggle for ProductRepository in `lib/providers/product_providers.dart`\n- [ ] Verify UI consumes providers correctly\n'

create_issue_if_missing "Cart Provider & Local Persistence" "backend,enhancement" $'## Description\nImplement an in-memory cart provider and local persistence using shared_preferences or hive.\n\n## Acceptance Criteria\n- [ ] Add in-memory cart provider\n- [ ] Implement local storage to persist cart across restarts\n- [ ] Cart persists and restores correctly on app restart\n'

create_issue_if_missing "Complete Home & Product Screens Provider Wiring" "backend,product" $'## Description\nWire remaining static screens (Home, Product Details, Discovery) to providers so they consume dynamic/mock data.\n\n## Acceptance Criteria\n- [ ] Wire Home, Product Details, Discovery screens to providers\n- [ ] Verify UI updates correctly with provider changes\n'

create_issue_if_missing "Checkout Skeleton & Payment Adapter" "backend,enhancement" $'## Description\nImplement a minimal checkout flow skeleton and a payment adapter interface (mock). No live payments.\n\n## Acceptance Criteria\n- [ ] Add checkout skeleton and navigation\n- [ ] Create payment adapter interface with mock implementation\n- [ ] Connect cart to checkout flow\n'

create_issue_if_missing "Add End-to-End Smoke Tests" "tests,critical" $'## Description\nCreate smoke tests for Home, Product Details, and Cart screens; ensure navigation and provider updates work.\n\n## Acceptance Criteria\n- [ ] Add widget/e2e smoke tests for major flows\n- [ ] Ensure tests run in CI\n'

create_issue_if_missing "Backend Contract: Products API" "backend,critical" $'## Description\nDefine JSON contract for Products API and prepare RemoteProductRepository to connect once API is live.\n\n## Acceptance Criteria\n- [ ] Document request/response JSON schema for products\n- [ ] Add sample responses in REMOTE_REPO_SETUP.md\n- [ ] Ensure RemoteProductRepository parsing matches contract\n'

# Add created issues to Project V2 (best-effort)
echo "Adding issues to Project V2 ($PROJECT_ID)"
for title in \
  "Harden CI & Analyzer" \
  "Route Name Standardization" \
  "ProviderScope Wiring & ProductRepository Toggle" \
  "Cart Provider & Local Persistence" \
  "Complete Home & Product Screens Provider Wiring" \
  "Checkout Skeleton & Payment Adapter" \
  "Add End-to-End Smoke Tests" \
  "Backend Contract: Products API"; do
  # find issue number by title
  issue_number=$(gh issue list --repo "$REPO" --limit 200 --json number,title --jq '.[] | select(.title=="'"$title"'") | .number' 2>/dev/null | head -n1 | tr -d '\r' || true)
  if [ -z "$issue_number" ]; then
    echo "Cannot find issue for title: $title (skipping add to project)"
    continue
  fi

  echo "Found issue #$issue_number for '$title' — adding to project"
  # Get the issue node id via GraphQL
  # Get issue node id via inline GraphQL (avoid variable typing issues)
  issue_node_id=$(gh api graphql -f query="query{ repository(owner:\"$REPO_OWNER\", name:\"$REPO_NAME\"){ issue(number:$issue_number){ id } } }" --jq '.data.repository.issue.id' 2>/dev/null || true)
  if [ -z "$issue_node_id" ]; then
    echo "Failed to get node id for issue #$issue_number"
    continue
  fi

  # Add item to project v2 using inline mutation (avoid variable typing issues)
  echo "Adding issue node $issue_node_id to project $PROJECT_ID"
  gh api graphql -f query="mutation{ addProjectV2ItemByContent(input:{projectId:\"$PROJECT_ID\", contentId:\"$issue_node_id\"}){ item{ id } } }" >/dev/null 2>&1 || true
done

echo "Phase 1 issue creation and project association complete."


echo "Phase 1 issue creation complete."

echo "Note: Project column/card linking is best-effort; please review the Project in the GitHub UI to verify columns and card placement. If you want, I can attempt to add issues to a specific column programmatically once you confirm the project's column IDs."

exit 0
