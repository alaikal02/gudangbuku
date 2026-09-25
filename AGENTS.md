# Repository Guidelines

## 🛑 MANDATORY GIT WORKFLOW (STRICT RULE)
Whenever working on any feature, improvement, bugfix, or refactoring:
1. **NEVER commit or push directly to `master` (or `main`).**
2. **ALWAYS create and switch to a new branch first**:
   - `feature/<name>` for new features or additions
   - `fix/<name>` for bug fixes and patches
   - `refactor/<name>` for structural refactoring
3. **Commit and test within the branch**.
4. **Push the branch to origin**: `git push -u origin <branch-name>`.
5. Only merge or integrate into `master` after thorough verification.
