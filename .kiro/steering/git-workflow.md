---
inclusion: always
---

# Git Workflow for Spec Execution

## Branching
- Each spec MUST be developed on its own branch created from `main`.
- Branch name MUST match the spec directory name (e.g., spec at `.kiro/specs/document-upload-storage/` → branch `document-upload-storage`).
- BEFORE creating any spec files (requirements.md, design.md, tasks.md), verify the correct branch is checked out. If not, create it from `main` and switch to it.
- Before starting any top-level task, verify the correct branch is checked out. If not, switch to it (create it from `main` if it doesn't exist yet).

## Commits
- Each top-level task (and its sub-tasks) MUST be committed once all sub-tasks are complete.
- Commit message format: `feat(<spec-name>): <task description>`
- Example: `feat(document-upload-storage): create shared backend modules`
- Stage only the files relevant to the task — avoid `git add .` unless all changes belong to the task.

## Push & Pull Request
- Once ALL tasks in the spec are complete, push the branch to GitHub.
- Open a Pull Request targeting `main` using `gh pr create`.
- PR title: the spec/feature name in human-readable form.
- PR description: brief summary of what was implemented, referencing the spec.
- After creating the PR, always share the PR URL in the chat response so the user can review it directly.
