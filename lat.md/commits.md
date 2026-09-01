# Git commits

Commits must preserve a reviewable change and enough intent for a future maintainer to understand why it exists.

## Change scope

Each commit should be a coherent change that can be reviewed and understood on its own.

- Stage only files that belong to the stated change.
- Review the staged diff and run the relevant validation before committing.
- Split unrelated behavior or documentation into separate commits.

## Subject

The first line must identify the change clearly in history and summary views.

- Aim for 72 characters or fewer.
- Use the imperative mood: describe what applying the commit does.
- Name the affected port or area and the specific outcome; avoid vague subjects such as `fix bug` or `update files`.

## Body

Use the body to record context that cannot be recovered from the diff alone.

- Separate it from the subject with a blank line and wrap prose at 72 characters.
- Explain the prior state, the reason for changing it, and the intended outcome; emphasize why, not a line-by-line account of how.
- Use the repository's canonical terminology consistently so history remains searchable.
- Use Markdown for headings and lists when structure materially improves readability.

## Impact and decisions

Record consequences and design tradeoffs when they help reviewers or future maintainers evaluate the change.

- Identify affected stakeholders before describing impact, restate the goal from their perspective, and omit groups the change does not concern.
- Capture non-obvious alternatives, constraints, and tradeoffs in design notes.
- Incorporate durable answers from review or development discussions into the commit body.
- Call out compatibility breaks explicitly with a `BREAKING CHANGE:` paragraph that states what consumers must change.
