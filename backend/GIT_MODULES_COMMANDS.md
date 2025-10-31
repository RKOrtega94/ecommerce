# Git Submodules — Commands and one-line explanations

## Clone / Initialize

```bash
git clone --recursive <repository-url>
```

Clone repository and initialize all submodules.

```bash
git clone <repository-url>
cd <repository>
git submodule init
git submodule update
```

Clone without submodules then initialize and fetch them.

## Add / Remove Submodule

```bash
git submodule add <repository-url> <path>
```

Add and clone a submodule into `<path>` and update .gitmodules.

```bash
git submodule deinit -f <submodule-path>
git rm -f <submodule-path>
rm -rf .git/modules/<submodule-path>
```

Deinitialize and remove a submodule and its stored module data.

## Update Submodules

```bash
git submodule update
```

Checkout the commits recorded by the parent repository for each submodule.

```bash
git submodule update --remote
```

Update submodules to the latest commit on their configured remote branch.

```bash
git submodule update --remote <submodule-path>
```

Update a single submodule to the latest remote commit.

```bash
git submodule update --remote --merge
```

Fetch remote changes and merge into the current submodule branch.

## Work inside a Submodule

```bash
cd <submodule-path>
git checkout -b <branch-name>
```

Create a branch inside a submodule to avoid detached HEAD.

```bash
cd <submodule-path>
git push origin <branch-name>
```

Push submodule branch changes to the submodule remote.

## Status and Inspection

```bash
git submodule status --recursive
```

Show recorded commits and whether submodules are checked out (recursive).

```bash
git submodule foreach --recursive 'git status --short'
```

Run a command in every submodule to inspect local state (recursive).

## Batch Operations

```bash
git submodule foreach --recursive '<command>'
```

Run an arbitrary command in every submodule (recursive).

```bash
git submodule foreach --recursive git clean -xfd
git submodule foreach --recursive git reset --hard
```

Remove untracked files and reset changes in all submodules.

```bash
git submodule update --init --recursive
```

Initialize and update all nested submodules.

## Sync / Change Remote URL

```bash
git config --file=.gitmodules submodule.<submodule-path>.url <new-url>
git submodule sync --recursive
git submodule update --init --recursive
```

Change submodule URL in .gitmodules, sync config, and reinitialize.

## Track a Branch in a Submodule

```bash
git config -f .gitmodules submodule.<submodule-path>.branch <branch-name>
git submodule update --remote
```

Set a submodule to track a specific branch and update to it.

## Force / Recover / Rebuild

```bash
git submodule deinit --all -f
git submodule sync --recursive
git submodule update --init --recursive --force
```

Full reset: deinitialize all, sync configs, force reinitialize submodules.

```bash
rm -rf .git/modules
git submodule foreach --recursive 'git clean -xfd'
git submodule update --init --recursive --force
```

Nuclear rebuild: remove stored modules, clean, and force update.

## Push Options With Submodules

```bash
git push --recurse-submodules=check
git push --recurse-submodules=on-demand
```

Verify or automatically push referenced submodule commits when pushing parent.

## Useful Git Configs

```bash
git config submodule.recurse true
```

Make git commands like pull recurse into submodules by default.

```bash
git config status.submoduleSummary true
```

Show submodule summaries in git status.

```bash
git config diff.submodule log
```

Show submodule commit differences in git diff.

## Quick Recovery Commands

```bash
# If submodules are missing or empty after clone
git submodule update --init --recursive

# If submodule URLs changed
git submodule sync --recursive
git submodule update --init --recursive

# Clean and reset all submodules, then force update
git submodule foreach --recursive git clean -xfd
git submodule foreach --recursive git reset --hard
git submodule update --init --recursive --force
```

Common quick workflows to recover submodule state.

## One-line Quick Reference

```bash
git submodule add <url> <path>          # add submodule
git submodule init                      # initialize submodules
git submodule update                    # update to recorded commit
git submodule update --remote           # update to latest remote commit
git clone --recursive <url>             # clone with submodules
git submodule status                    # check submodule status
git submodule foreach <command>         # run command in each submodule
git submodule deinit <path>             # unregister a submodule
git submodule deinit --all -f           # deinitialize all submodules
git submodule sync --recursive          # sync URLs from .gitmodules
git submodule update --init --recursive --force  # force init/update
```

## Command Reference Table

| Command Template | Explanation |
|------------------|-------------|
| `git submodule add <url> <path>` | Add and clone a submodule into `<path>`, update `.gitmodules`. |
| `git submodule init` | Initialize submodules listed in `.gitmodules`. |
| `git submodule update` | Checkout submodules to the commit recorded in the parent repo. |
| `git submodule update --remote` | Update submodules to the latest commit on their remote branch. |
| `git clone --recursive <url>` | Clone repository and all submodules recursively. |
| `git submodule status` | Show current commit checked out for each submodule. |
| `git submodule foreach <command>` | Run a shell command in each submodule. |
| `git submodule deinit <path>` | Unregister a submodule from the working tree. |
| `git submodule deinit --all -f` | Deinitialize all submodules forcibly. |
| `git submodule sync --recursive` | Sync submodule URLs from `.gitmodules` to local config. |
| `git submodule update --init --recursive --force` | Force initialize and update all submodules recursively. |
| `git submodule foreach --recursive git clean -xfd` | Remove untracked files in all submodules. |
| `git submodule foreach --recursive git reset --hard` | Reset all submodules to HEAD, discarding changes. |
| `git config submodule.recurse true` | Make git commands recurse into submodules by default. |
| `git config status.submoduleSummary true` | Show submodule summaries in `git status`. |
| `git config diff.submodule log` | Show submodule commit diffs in `git diff`. |
