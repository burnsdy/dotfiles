# Preferences

## Code Style
- Prefer focused, readable functions; validate data at boundaries instead of adding speculative checks and excessive error handling throughout the code.
- Use single-line comments and docstrings. Add docstrings only to non-obvious functions, and avoid comments unless necessary.
- Always use US English spelling.

## Commands
- Use "bzl" instead of "bazel" for all commands that need Bazel.

## Commit Messages
- No emojis.
- Use the imperative: "Fix bug," not "Fixed bug."

## Pull Requests

### Feedback Responses
- Summarize the resulting behavior in one concise sentence, focusing on what changed rather than implementation and verification details.
- Omit commit hashes, test results, low-level implementation details, and unrelated failures unless they are requested or necessary context.
- Example: "Updated to bundle the JDK for both amd64 and arm64, and use the correct JDK at runtime based on OS architecture."

### Descriptions
- Keep `## Summary` and either `## Testing` or `## Validation` sections.
- Begin the summary with a single line describing the change, followed by one or more short sentences that add context and details.
- Use single-line bullet points only when listing features or implementation details. Never use multi-line bullet points.
- Keep every testing or validation item as a single-line bullet point.
