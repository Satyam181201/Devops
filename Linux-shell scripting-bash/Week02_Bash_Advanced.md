# Week 2 - Bash Advanced (Part A)

Week 1 gave you the Bash foundation (variables, if, loops, functions). This week you make Bash **useful for real DevOps work** - scripts that take arguments, report success/failure correctly, run on a schedule, and talk to the internet.

**Where to run commands:** Git Bash or WSL2 (Ubuntu) for Bash.

---

## Videos to Watch
1. **Abhishek Veeramalla - Shell Scripting (Day 4-6 of his DevOps playlist)** - arguments, exit codes, real scripts. Look for: `$1`/`$@`, `$?`, and how a script signals failure.

Rule: ~1 hour of video max, then terminal. The labs below teach more than any video.

---

## Why Bash Matters

**Bash - why it's still everywhere.** Before scripting, ops work was manual: an admin typed the same commands by hand on each server, every time. That didn't scale and wasn't repeatable - two admins did it two different ways. Shell scripts made a sequence of steps **repeatable and shareable**: write it once, run it anywhere, commit it to Git. 

Newer tools layered on top (Make, Python, Ansible, now pipeline YAML), but none of them replaced Bash - they *call* it. Every CI step, container entrypoint, and `kubectl exec` debug session bottoms out in a shell. Bash is the glue that never went away; the key idea it gives you is the **exit code** (0 = success), which is how every pipeline on earth decides pass or fail.

---

## A.1 Command-line Arguments

Arguments are the words you type after the script name. They let one script do different things without editing it.

```bash
#!/bin/bash
echo "Script name : $0"
echo "First arg   : $1"
echo "Second arg  : $2"
echo "All args    : $@"
echo "How many    : $#"
```

Run it:
```bash
./args.sh deploy prod
# Script name : ./args.sh
# First arg   : deploy
# Second arg  : prod
# All args    : deploy prod
# How many    : 2
```

**Explanation:**
- `$0` = the script's own name.
- `$1`, `$2`, ... = first, second argument, and so on.
- `$@` = **all** arguments as a list (great for loops).
- `$#` = the **count** of arguments (use it to check the user passed enough).

*Plain English:* Think of a script like a coffee machine with buttons. `$1`, `$2` are the buttons the user pressed - "latte", "large". The same machine behaves differently based on what you pass it, so you don't build a new machine for every order. 

In DevOps you'll write `./deploy.sh staging` and `./deploy.sh prod` - one script, the environment is the argument.

**Always validate arguments:**
```bash
#!/bin/bash
if [ $# -lt 1 ]; then
    echo "Usage: $0 <environment>"
    exit 1                      # stop with an error code
fi
echo "Deploying to $1"
```

`$# -lt 1` means "fewer than 1 argument given" - so print how to use it and quit. This is the mark of a real script, not a toy.

---

## A.2 Exit Codes ($? and exit)

Every command returns a number when it finishes: **0 = success, anything else = failure.** This is how scripts and CI pipelines know whether to continue or stop.

```bash
ls /tmp
echo $?        # 0  -> the ls worked

ls /does-not-exist
echo $?        # non-zero (e.g. 2) -> it failed
```

Use it in your own scripts:
```bash
#!/bin/bash
mkdir /tmp/mydir
if [ $? -eq 0 ]; then
    echo "created"
else
    echo "failed to create"
    exit 1
fi
```

And set your script's own exit code:
```bash
exit 0     # tell the caller "success"
exit 1     # tell the caller "something went wrong"
```

**Explanation:**
- `$?` = the exit code of the **last** command that ran. Check it immediately; the next command overwrites it.
- `exit 0` / `exit 1` = the code YOUR script hands back to whoever called it.

*Plain English:* Exit codes are a thumbs-up / thumbs-down that programs give each other. You can't see it on screen, but the next program can. This is the single most important Bash concept for DevOps: **a Jenkins or GitHub Actions stage passes or fails based on the exit code of the command it ran.** 

If your test script `exit 1`s, the pipeline goes red. If it `exit 0`s, the pipeline moves on. Get this wrong and a broken build looks "green."

**Chaining on success/failure:**
```bash
mvn clean package && echo "build ok"      # && runs only if the left side succeeded (exit 0)
mvn clean package || echo "build FAILED"  # || runs only if the left side failed
```

- `&&` = "and then, only if it worked."
- `||` = "or else, if it failed."

---

## A.3 Reading Input and Safer Script Header

```bash
#!/bin/bash
set -euo pipefail      # make the script strict and safe

read -p "Enter service name: " svc
echo "Restarting ${svc}..."
```

**`set -euo pipefail` explained** (put it near the top of serious scripts):
- `-e` = exit immediately if any command fails (don't blindly keep going).
- `-u` = error if you use a variable that was never set (catches typos).
- `-o pipefail` = in a pipe `a | b`, fail if **any** part fails, not just the last.

*Plain English:* By default Bash is too forgiving - it keeps running even after a command fails, which can be dangerous (imagine a backup script that fails to copy but then deletes the original anyway). 

`set -euo pipefail` turns on "strict mode" so the script stops at the first sign of trouble. Use it in anything that touches real files or servers.

---

## A.4 curl and wget (Talk to the Internet / APIs)

Both fetch things over HTTP. `curl` is the Swiss-army knife for APIs; `wget` is best for downloading files.

```bash
# curl - test and talk to APIs
curl https://api.github.com                       # GET, print body
curl -s https://api.github.com                     # -s = silent (no progress bar)
curl -i https://api.github.com                     # -i = include response headers
curl -o out.json https://api.github.com            # -o = save body to a file
curl -X POST -H "Content-Type: application/json" \
     -d '{"name":"test"}' http://localhost:8080/tasks   # POST JSON

# wget - download files
wget https://example.com/app.tar.gz                # save the file to disk
wget -q https://example.com/app.tar.gz             # -q = quiet
```

**Explanation:**
- `-s` silent, `-i` include headers, `-o file` save output, `-X` method, `-H` header, `-d` body.
- `curl` prints to the screen by default (good for APIs); `wget` saves to a file by default (good for downloads).

*Plain English:* `curl` is how a script checks "is my API alive?" or sends data to it without a browser. `wget` is how a script grabs a file - like downloading a tool during a build. In pipelines you'll `curl` a health endpoint and check the exit code to decide if a deploy succeeded.

**Health-check pattern (very common in DevOps):**
```bash
#!/bin/bash
if curl -sf http://localhost:8080/health > /dev/null; then
    echo "App is healthy"
else
    echo "App is DOWN"
    exit 1
fi
```

- `-s` silent, `-f` = fail (return non-zero) on HTTP errors like 500. `> /dev/null` throws away the body; we only care about pass/fail.

---

## A.5 Cron Jobs (Run Scripts on a Schedule)

`cron` runs commands automatically at set times - backups at 2am, cleanups every hour, health checks every 5 minutes.

```bash
crontab -e      # edit your scheduled jobs (opens an editor)
crontab -l      # list your scheduled jobs
```

A cron line has **5 time fields + the command**:
```
* * * * *  command-to-run
│ │ │ │ │
│ │ │ │ └── day of week (0-6, Sun=0)
│ │ │ └──── month (1-12)
│ │ └────── day of month (1-31)
│ └──────── hour (0-23)
└────────── minute (0-59)
```

Examples:
```bash
0 2 * * *      /home/satyam/backup.sh        # every day at 02:00
*/5 * * * *    /home/satyam/healthcheck.sh    # every 5 minutes
0 0 * * 0      /home/satyam/weekly.sh         # every Sunday at midnight
30 9 * * 1-5   /home/satyam/report.sh         # 09:30, Monday to Friday
```

**Explanation:**
- `*` means "every". `*/5` means "every 5th". `1-5` is a range.
- Read left to right: minute, hour, day-of-month, month, day-of-week.

*Plain English:* Cron is an alarm clock for your server. You tell it "run this script at this time" and it does, forever, without you being logged in. 

`*/5 * * * *` = "every 5 minutes, all day, every day." 

Memory trick for the 5 fields: **"Min Hour Day Month Weekday"** - smallest unit of time first. 

Note: Git Bash on Windows has no cron; practice the syntax by reading it, and run it for real in WSL or on a Linux server.

---

## A.6 Useful Extras You'll Actually Use

```bash
# default value if a variable is empty
env="${1:-dev}"            # if $1 not given, use "dev"

# case statement - cleaner than many elif
case "$1" in
    start)  echo "starting";;
    stop)   echo "stopping";;
    *)      echo "usage: $0 {start|stop}"; exit 1;;
esac

# redirect output and errors to a log
./script.sh > out.log 2>&1   # stdout and stderr both into out.log
```

- `${1:-dev}` = "use `$1`, but if it's empty use `dev`." Great for optional arguments.
- `case` matches a value against patterns - the clean way to handle `start|stop|restart`.
- `2>&1` = "send errors (stream 2) to the same place as normal output (stream 1)."

---

## Hands-On Labs (Do These!)

### Bash Labs

- **Lab 1 - `deploy.sh`:** Takes an environment argument (`dev`/`staging`/`prod`). If none given, print `Usage: ...` and `exit 1`. Use a `case` statement to print a different message per environment.

- **Lab 2 - `healthcheck.sh`:** `curl` a URL passed as `$1`. Print "healthy" and `exit 0` if it responds, "DOWN" and `exit 1` if not. Default the URL to `http://localhost:8080` if no arg.

- **Lab 3 - `backup.sh` (stricter):** Start with `set -euo pipefail`. Make a timestamped folder `backup_$(date +%F)` and copy all `.md` files into it. Print how many files were copied.

- **Lab 4 - exit-code demo:** Write `check.sh` that runs a command, checks `$?`, and prints success/failure. Then chain two commands with `&&` and `||`.

- **Lab 5 (cron reading):** Write the cron lines for: every day 1am, every 10 minutes, every Monday 6pm. Put them in a file `cron-notes.txt` with a comment explaining each (no need to actually install cron on Windows).

---

## Interview Q&A - Bash

- **Q: What's the difference between `$1`, `$@`, and `$#`?** 
  `$1` is the first argument, `$@` is all arguments as a list, `$#` is the number of arguments.

- **Q: What is an exit code and why does it matter?** 
  A number a command returns - 0 for success, non-zero for failure. CI/CD pipelines decide pass/fail based on it.

- **Q: How do you check if the last command succeeded?** 
  Check `$?` immediately after it; `0` means success.

- **Q: What does `&&` vs `||` do?** 
  `&&` runs the next command only if the previous succeeded; `||` only if it failed.

- **Q: What does `set -euo pipefail` do?** 
  Exit on any error (`-e`), error on undefined variables (`-u`), and fail a pipeline if any part fails (`pipefail`). It makes scripts strict and safe.

- **Q: How do you schedule a script to run every 5 minutes?** 
  A cron entry `*/5 * * * * /path/script.sh`.

- **Q: Difference between curl and wget?** 
  `curl` is for talking to APIs and prints to stdout by default; `wget` is for downloading files and saves to disk by default.

---

## Common Mistakes - And Fixes

- **Not checking `$#`** before using `$1` - the script crashes or misbehaves on no input. Always validate.
- **Ignoring exit codes** - a script that always `exit 0`s hides failures from CI. Make failures `exit 1`.
- **Committing secrets** (`.pem`, passwords, `.env`) - never. Add them to `.gitignore` first.

---

## Cheat Sheet

### Bash Commands
```bash
$0 $1 $2        # script name, first arg, second arg
$@              # all args as a list
$#              # number of args
$?              # exit code of last command (0 = success)
exit 0 / exit 1 # your script's success / failure code

cmd1 && cmd2    # run cmd2 only if cmd1 succeeded
cmd1 || cmd2    # run cmd2 only if cmd1 failed

set -euo pipefail           # strict mode (top of serious scripts)
env="${1:-dev}"             # default value if arg missing

case "$1" in                # clean multi-way branch
  start) echo start;;
  stop)  echo stop;;
  *) echo "usage: $0 {start|stop}"; exit 1;;
esac

curl -sf URL > /dev/null    # silent, fail-on-error health check
wget -q URL                 # quiet download
./script.sh > out.log 2>&1  # log stdout + stderr

# cron: min hour day month weekday
*/5 * * * * script.sh       # every 5 minutes
0 2 * * *   backup.sh       # 2am daily
0 0 * * 0   weekly.sh       # Sunday midnight
```

---

**Practice these concepts daily and they'll become second nature!** 🚀
