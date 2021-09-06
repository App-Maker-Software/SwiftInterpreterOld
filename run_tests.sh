swift test --parallel --xunit-output Tests/Results.xml
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" == "binary" || "$BRANCH" == "main" ]]; then
  # We only update TEST_RESULTS.md if run on binary or main branch.
  ./scripts/update_test_results_md.py
fi
