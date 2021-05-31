swift test --parallel --xunit-output Tests/Results.xml
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" == "staging" || "$BRANCH" == "main" ]]; then
  # We only update TEST_RESULTS.md if run on staging or main branch.
  ./scripts/update_test_results_md.py
fi