# Week 2 - Git Complete Guide (Part B)

You probably already `git add / commit / push`. This is the other 80%: branches, merge vs rebase, conflicts, and undo. These are the questions interviewers love because they reveal whether you've worked in a team.

**Where to run commands:** Git Bash, WSL, or PowerShell - Git works in all of them.

---

## Videos to Watch
1. **TechWorld with Nana - "Git Tutorial for Beginners"** (the ~1 hr one). Look for: branching, merge vs rebase, and resolving a conflict.
2. (Optional) **Abhishek Veeramalla - "Git & GitHub for DevOps"** - branching strategy in a team.

Rule: ~1 hour of video max, then terminal. The Git labs below teach more than any video.

---

## Why Git Matters

**Git - what came before and why it won.** Early version control was centralized: CVS, then SVN. One central server held history; you needed network access to commit, branching was painful and expensive, and if the server died, history was at risk. 

Git (2005, built for the Linux kernel) flipped the model to **distributed** - every clone is a full copy of history, commits are local and instant, and branching is cheap and fast. That cheap branching is what made the modern "feature branch → Pull Request → review → merge" workflow possible, which is what CI/CD and GitOps are built on. 

Today Git is the undisputed standard; the debate has moved to *workflow* (trunk-based vs Git Flow), not *tool*.

---

## B.1 The Mental Model

Git has three areas. Know them cold:
- **Working directory** = your actual files on disk (what you edit).
- **Staging area (index)** = a holding zone for the next commit (`git add` puts files here).
- **Repository** = the saved history of commits (`git commit` writes here).

```bash
git status            # what changed, what's staged - run this constantly
git add file.sh       # stage one file
git add .             # stage everything changed
git commit -m "msg"   # save staged changes as a commit
git log --oneline     # compact history
```

*Plain English:* Think of shipping a parcel. **Working directory** = stuff on your desk you're still editing. **Staging** = the box you've packed but not sealed (`git add`). **Commit** = sealing and labeling the box so it's part of permanent history. 

`git status` is you looking at the desk to see what's packed and what isn't. Run `git status` before and after everything until it's second nature.

---

## B.2 Branching (The Heart of Team Work)

A branch is an independent line of work. You build a feature on its own branch so you never break the main code.

```bash
git branch                      # list branches (* = current)
git branch feature-login        # create a branch
git checkout feature-login      # switch to it
git checkout -b feature-login   # create AND switch in one step (common)
git switch -c feature-login     # newer equivalent of checkout -b

# ... edit files, add, commit on the branch ...

git checkout main               # go back to main
git merge feature-login         # bring the feature into main
git branch -d feature-login     # delete the branch after merging
```

**Explanation:**
- `checkout -b name` = make a branch and jump onto it (you'll use this most).
- Commits you make now land on the branch, not on `main`.
- `merge` pulls the branch's commits into whatever branch you're currently on.

*Plain English:* `main` is the clean, shippable copy. A branch is a **sandbox copy** where you try your change. If it works, you merge it back; if it's a mess, you throw the branch away and `main` was never touched. 

In a team, everyone works on their own branch so you don't overwrite each other. This is why "just commit to main" doesn't scale.

---

## B.3 Merge vs Rebase (Classic Interview Question)

Both combine work from two branches. The difference is the **history they produce**.

---

### 📖 Simple Explanation with 2 Examples

**Situation:** You're working on `feature` branch. Meanwhile, your teammate added new commits to `main`. Now you want to combine them.

---

### Example 1: Using MERGE

**Before:**
```
main:     A─→B─→C─→D (teammate's new work)
               └─→E─→F (your feature branch work)
```

**Command:**
```bash
git checkout feature
git merge main
```

**After:**
```
main:     A─→B─→C─→D
               └─→E─→F─→M (merge commit)
                     ├────┘
```

**What happened:**
- Git creates a **merge commit (M)** that combines both branches
- History shows your branch split off, then joined back
- You can see the branch existed
- Commits keep their original IDs

**Think of it as:** Joining two roads together with a bridge.

---

### Example 2: Using REBASE

**Before:**
```
main:     A─→B─→C─→D (teammate's new work)
               └─→E─→F (your feature branch work)
```

**Command:**
```bash
git checkout feature
git rebase main
```

**After:**
```
main:     A─→B─→C─→D─→E'─→F' (your work moved on top)
```

**What happened:**
- Git **picks up** your commits E and F
- **Replays** them on top of D (latest main)
- They become E' and F' (new commit IDs!)
- Looks like you started work from D, not B
- Clean, straight line - no merge commit

**Think of it as:** Erasing your work, then redrawing it on top of new work.

---

### 🎯 Key Difference

| MERGE | REBASE |
|-------|--------|
| Keeps both timelines | Makes one straight line |
| Adds merge commit | No merge commit |
| Honest history | Rewrites history |
| Safe for shared branches | Only for your private branches |

---

### 🚨 Golden Rule

- **REBASE** = Your own branch (not shared yet)
- **MERGE** = Shared branches (others are using)

**Why?** Rebase changes commit IDs. If others already have your old commits, the new IDs will confuse Git!

---

### The Interview Answer
> "Merge preserves history and creates a merge commit - safe for shared branches. Rebase rewrites commits to give a clean, linear history - great for tidying up my own feature branch before merging, but I never rebase a branch others are already using, because it rewrites shared history."

---

## B.4 Resolving a Merge Conflict (You WILL Be Asked This)

A conflict happens when two branches changed the **same lines** and Git can't decide which to keep.

```bash
git merge feature-x
# CONFLICT (content): Merge conflict in app.txt
```

Open the file - Git marks the clash:
```
<<<<<<< HEAD
the version on your current branch
=======
the version from the branch you're merging
>>>>>>> feature-x
```

### Fix it by hand:
1. Edit the file: delete the `<<<<<<<`, `=======`, `>>>>>>>` markers and keep the correct final content (maybe a mix of both).
2. Stage the resolved file: `git add app.txt`
3. Finish the merge: `git commit` (or `git rebase --continue` if you were rebasing).

```bash
git merge --abort      # bail out and go back to before the merge, if you panic
```

*Plain English:* Two people edited the same sentence in a shared doc. Git won't guess who's right, so it shows you both versions between the `<<<<<<<` / `>>>>>>>` markers and says "you decide." 

You pick the correct final sentence, remove the markers, `git add`, and commit. A conflict is not an error - it's Git asking a question. 

Interviewers want to hear that you stay calm, edit the file, remove the markers, add, and commit.

---

## B.5 Undoing Mistakes (revert vs reset)

```bash
git revert <commit>     # make a NEW commit that undoes an old one - SAFE for shared history
git reset --soft HEAD~1 # undo last commit, KEEP changes staged
git reset --mixed HEAD~1 # undo last commit, keep changes but unstaged (default)
git reset --hard HEAD~1 # undo last commit AND throw away the changes - DANGEROUS
git checkout -- file.sh # discard unsaved changes in one file
git restore file.sh      # newer equivalent of the line above
```

**Explanation:**
- `revert` = safe undo: it adds a new commit that reverses a bad one, so history stays intact. Use this on `main` / shared branches.
- `reset` = moves the branch pointer back. `--soft` keeps your work staged, `--mixed` keeps it as edits, `--hard` deletes it. Use only on your own local, unpushed commits.

*Plain English:* **revert** is "undo" that leaves a paper trail - the mistake and its fix are both in history, which is honest and safe when others share the branch. 

**reset** is "pretend it never happened" by rewinding the branch; powerful but risky, so keep `--hard` for local-only commits you're sure about. 

Golden rule: **shared/pushed → revert; local/private → reset.**

Shared/Pushed = Commits you already sent to GitHub (git push). Others might have them, so DON'T rewrite history.

Local/Private = Commits only on your computer (not pushed yet). Nobody else has them, so it's SAFE to rewrite.
---

## B.6 Branching Strategy (One Sentence Per Strategy)

- **Feature branching:** One branch per feature, merged into `main` via a Pull Request. Simplest, most common.
- **Git Flow:** `main` (releases) + `develop` + `feature/*` + `release/*` + `hotfix/*`. Heavier, for scheduled releases.
- **Trunk-based:** Everyone commits to `main` frequently behind feature flags; short-lived branches. Favored for fast CI/CD.

*Plain English:* A branching strategy is just the team's agreed rules for how branches are named and merged. For your project and most interviews, **feature branch → Pull Request → review → merge to main** is the answer to give. Mention trunk-based if they push on CI/CD speed.

---

## B.7 Clone vs Fork (Quick Difference)

Both download a repository, but for different purposes:

### Clone
**What it does:** Downloads a repository to your computer.

```bash
git clone https://github.com/username/repo.git
```

**Use when:**
- You have **write access** to the repository
- It's your own repo or your team's repo
- You'll push changes directly

**Think of it as:** Making a local copy to work on.

---

### Fork
**What it does:** Creates **your own copy** of someone else's repository on GitHub.

**Steps:**
1. Click "Fork" button on GitHub (creates copy under YOUR account)
2. Clone YOUR fork to your computer
3. Make changes, push to YOUR fork
4. Open Pull Request to original repo

**Use when:**
- You DON'T have write access to the original repo
- You want to contribute to someone else's project
- You want your own version of a project

**Think of it as:** Photocopying someone's book so you can write in it, then asking them to include your notes.

---

### Quick Comparison

| Feature | Clone | Fork |
|---------|-------|------|
| **Where?** | Local copy on your computer | Copy on YOUR GitHub account |
| **Access?** | Need write permission | No permission needed |
| **Push to?** | Original repository | Your forked copy |
| **Contribute?** | Direct push | Via Pull Request |

---

### Real Example

**Clone (Your Team's Repo):**
```bash
git clone https://github.com/myteam/project.git
# Make changes
git push    # ✅ Works! You have access
```

**Fork (Someone Else's Repo):**
1. Fork on GitHub → Now you have `github.com/YOU/project`
2. Clone YOUR fork:
   ```bash
   git clone https://github.com/YOU/project.git
   ```
3. Make changes, push to YOUR fork
4. Open PR to original repo

---

### Interview Answer
> "**Clone** downloads a repo to work on locally - I use it for repos I have access to. **Fork** creates my own copy on GitHub - I use it to contribute to repos I don't own. After forking, I clone my fork, make changes, push to my fork, then open a Pull Request to the original."

---

## B.8 Pull Requests (The GitHub Part)

A Pull Request (PR) = "please review my branch and merge it into main." It's where code review and CI run.

```bash
git checkout -b feature/add-healthcheck
# ...edit, commit...
git push -u origin feature/add-healthcheck   # push the branch to GitHub
# then on GitHub: click "Compare & pull request", describe it, merge it
```

- `-u origin <branch>` sets the upstream so future `git push` needs no arguments.
- After merge, delete the branch on GitHub and locally (`git branch -d`).

*Plain English:* A PR is the doorway from "my sandbox branch" into `main`, with a checkpoint (review + automated tests) in between. Even working solo, using PRs gives your repo the clean, professional history - and it's exactly how real teams merge code.

---

## Hands-On Labs (Do These!)

### Git Labs

- **Lab 1:** Make a repo `devops-git-practice`, add some files, commit in **small, meaningful commits** (not one giant commit).

- **Lab 2:** Create a branch `feature/healthcheck`, add a script there, commit, switch back to `main`, and `merge` it. Then delete the branch.

- **Lab 3 (make a conflict on purpose):** Create two branches that both edit the same line of a `README.md`. Merge one, then merge the other and **resolve the conflict** by hand. This is the most valuable lab of the week.

- **Lab 4:** Make a bad commit, then `git revert` it. Look at `git log --oneline` and see both commits.

- **Lab 5:** Push the repo to GitHub, create a `feature/*` branch, open a **Pull Request**, and merge it on GitHub. Your repo now has real branch + PR history.

---

## Interview Q&A - Git

- **Q: Merge vs rebase?** 
  Merge keeps history and adds a merge commit (safe for shared branches); rebase rewrites commits into a linear history (clean, for private branches only). Never rebase shared history.

- **Q: How do you resolve a merge conflict?** 
  Open the conflicted file, choose the correct content between the `<<<<<<<`/`>>>>>>>` markers, remove the markers, `git add` the file, then commit.

- **Q: revert vs reset?** 
  `revert` creates a new commit that undoes a change (safe for pushed/shared history); `reset` moves the branch pointer back (use only on local, unpushed commits; `--hard` discards changes).

- **Q: What are the three areas in Git?** 
  Working directory (your files), staging area (next commit), and the repository (committed history).

- **Q: What's your branching strategy?** 
  Feature branch per change, Pull Request for review, merge into `main` - trunk-based with short-lived branches when CI/CD speed matters.

- **Q: What does `git checkout -b` do?** 
  Creates a new branch and switches to it in one step.

- **Q: How do you undo the last local commit but keep your changes?** 
  `git reset --soft HEAD~1` (keeps them staged) or `--mixed` (keeps them as edits).

---

## Experienced-Level Q&A (2 YOE Level)

### Q: Walk me through your team's Git workflow.
"We're feature-branch + PR. I cut a branch off main, and because our CI watches branches, that branch automatically gets its own pipeline and an isolated Kubernetes namespace to deploy into - so I validate my change in a real environment before it ever reaches shared ones. Then I open a PR for review, and on merge it tears the ephemeral environment down. Image tags are the commit SHA, so every running container traces back to an exact commit."

### Q: Merge or rebase - what do you actually do?
"Rebase my own feature branch to keep it current with main and keep history linear, but merge (never rebase) anything shared, because rebasing rewrites commit IDs and that wrecks history teammates already pulled. Practically: rebase locally to tidy up, merge via PR to integrate."

### Q: Tell me about a time you resolved a nasty merge conflict.
"Conflicts usually hit us in shared config - two branches touching the same `kustomization.yml` or env block. I open the file, look at both sides between the markers, and I don't blindly pick one - I reason about which env values are actually correct, often keeping a mix, then `git add` and complete the merge. The trick is treating a conflict as a question to answer carefully, not an error to rush past - config mistakes there become prod incidents."

### Q: Something bad got merged to main. revert or reset?
"Revert, every time, on a shared branch. `git revert` adds a new commit that undoes the change, so history stays honest and the fix is auditable - which matters when the branch is tied to deployments. `reset --hard` is only for my own local, unpushed commits. On main, rewriting history to 'hide' a bad commit is how you desync everyone."

### Q: How do you keep secrets out of Git?
"Secrets don't live in the repo as plaintext - they're injected as env vars at deploy time via our Kustomize overlays, and `.gitignore` keeps local `.env`/keys out. If a secret ever lands in history, rotating it is the real fix - removing the commit isn't enough once it's pushed."

---

## Common Mistakes - And Fixes

- **`git add .` blindly** - you commit junk (`.class`, logs, `node_modules`). Use a `.gitignore` and stage specific files.
- **Rebasing a shared branch** - rewrites history others have; causes painful conflicts. Rebase only your own local branches.
- **`git reset --hard` on pushed commits** - you lose work and diverge from the remote. Use `git revert` on anything already pushed.
- **Committing secrets** (`.pem`, passwords, `.env`) - never. Add them to `.gitignore` first.
- **Panicking at a merge conflict** - it's normal. Edit, remove markers, `git add`, commit.

---

## Cheat Sheet

### Git Basics
```bash
git status                      # see what changed
git add file.txt                # stage specific file
git add .                       # stage all changes
git commit -m "message"         # commit staged changes
git log --oneline               # compact history
git diff                        # see unstaged changes
```

### Branching
```bash
git branch                      # list branches
git branch feature-name         # create branch
git checkout -b feature-name    # create and switch
git switch -c feature-name      # newer way to create and switch
git checkout main               # switch to main
git merge feature-name          # merge branch into current
git branch -d feature-name      # delete branch
```

### Remote Operations
```bash
git remote -v                   # show remotes
git remote add origin URL       # add remote
git push -u origin main         # push and set upstream
git push                        # push to tracked remote
git pull                        # fetch and merge
git fetch                       # download without merging
git clone URL                   # download a repository
```

### Undoing
```bash
git revert <commit>             # safe undo (new commit)
git reset --soft HEAD~1         # undo commit, keep staged
git reset --mixed HEAD~1        # undo commit, keep as edits
git reset --hard HEAD~1         # undo commit, discard changes
git checkout -- file.txt        # discard changes in file
git restore file.txt            # newer way to discard changes
```

### Merge Conflicts
```bash
# When conflict occurs:
# 1. Open file, see markers: <<<<<<< ======= >>>>>>>
# 2. Edit to keep correct content, remove markers
# 3. git add file.txt
# 4. git commit

git merge --abort               # cancel merge if stuck
git rebase --abort              # cancel rebase if stuck
```

### Advanced
```bash
git log --graph --oneline       # visual history
git log --all --decorate        # all branches
git stash                       # temporarily save changes
git stash pop                   # restore stashed changes
git cherry-pick <commit>        # apply specific commit
git rebase -i HEAD~3            # interactive rebase (squash commits)
```

---

## Week 2 Deliverable

1. **Git repository on GitHub** with your bash scripts
2. The repo shows a **clean branch + PR history** (at least one feature branch merged via PR, and one resolved conflict somewhere in the history).

---

**Practice these Git workflows daily and they'll become second nature!** 🚀

**Remember:** Git is about **thinking in branches and commits**, not memorizing commands. Once the mental model clicks, the commands make sense! 💡
