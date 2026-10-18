# Week 1 (Oct 12-18) - Linux/Networking Check + Bash Basics

You already did Linux + networking, so the first half of this week is a **check**, not a redo. Pass the self-check, patch only your weak spots, then start Bash. Type every command yourself and run it - do not just read.

**Where to run commands:** on Windows, use **Git Bash** or **WSL2 (Ubuntu)** for a real Linux-style shell. Install Git Bash with Git (next section) or run `wsl --install` in PowerShell as admin to get Ubuntu.

---

## Videos to watch this week
1. **Abhishek Veeramalla - "Shell Scripting for DevOps" / "Shell Scripting Zero to Hero"** (his DevOps playlist). Watch the first 2-3 videos. Look for: shebang, variables, if conditions, loops.
2. (Optional refresher) **TechWorld with Nana - "Bash Scripting Full Course"**. Look for: how `$1`, `$2` arguments work and exit codes.

Rule: watch max ~1 hour, then open the terminal and type. Watching without doing does not count.

---

# PART A - Linux + Networking self-check

Try these from memory, no Google. Score yourself. **8+/10 = move on to Bash.** Below 8 = spend 2-3 days only on the ones you missed, then continue. Do NOT re-watch everything.

### The 10 questions
1. SSH into a remote server using a private key file.
2. Explain what `chmod 755` and `chmod 644` mean.
3. Find which process is using port 8080 and kill it.
4. Use `grep` to find all "ERROR" lines in a log file and count them.
5. Check disk space, free memory, and CPU usage.
6. Start, stop, and check the status of a service.
7. Explain what happens when you type a URL in a browser (DNS -> TCP -> HTTP).
8. Explain the difference between a port, an IP address, and a subnet like `/24`.
9. Test a REST API endpoint from the command line.
10. Explain the difference between an AWS Security Group and a traditional firewall.

### Answer key (check yourself)

Each answer has two parts: the short **interview version**, then a slower **plain-English** explanation with a real-life comparison. Read the plain-English to understand, then practice saying the interview version out loud.

**1. SSH with a key**
```bash
ssh -i mykey.pem ubuntu@13.234.56.78
```
- `-i mykey.pem` = identity file, your private key.
- `ubuntu` = the username on the server (Ubuntu AMIs use `ubuntu`, Amazon Linux uses `ec2-user`).
- `13.234.56.78` = the server's public IP.
- The key file must be locked down or SSH refuses it: `chmod 400 mykey.pem`.

*Plain English:* SSH = "Secure Shell." It's how you log into a far-away computer (like an AWS server) from your laptop's terminal, over an encrypted connection. Instead of a password, you use a **key file** (a `.pem`). Think of it as a physical key: the server has the lock, you hold the key. Read the command as a sentence: "Connect (`ssh`) using my key (`-i mykey.pem`) as user `ubuntu` to the machine at `13.234.56.78`." SSH refuses a key other people could read, so you lock it once with `chmod 400 mykey.pem`. **When you use it:** every time you get onto a cloud server to check logs, restart a service, or deploy.

**2. File permissions**
Permissions are read(4) + write(2) + execute(1), for three groups: owner, group, others.
- `chmod 755` = owner `rwx` (7), group `r-x` (5), others `r-x` (5). Common for scripts and folders.
- `chmod 644` = owner `rw-` (6), group `r--` (4), others `r--` (4). Common for normal files.
- `755` = 4+2+1 / 4+0+1 / 4+0+1.

*Plain English:* Every Linux file has permissions - who can **read**, **write**, or **run** it. There are 3 groups of people (owner, group, others) and 3 permissions with numbers: read = 4, write = 2, run = 1. Add the numbers per group to get each digit. `755` -> owner 7 (4+2+1 = full control), group 5 (4+1 = read+run), others 5 (read+run): owner does everything, everyone else can read and run but not change - used for **scripts and folders**. `644` -> owner 6 (4+2 = read+write), group 4 (read), others 4 (read): owner edits, everyone else only reads - used for **normal files**. Memory trick: **7 = full, 5 = read+run, 4 = read-only.**

**3. Find and kill what's using a port**
```bash
sudo lsof -i :8080        # list the process using port 8080
# or:
sudo netstat -tulpn | grep 8080
kill -9 <PID>             # force-kill by process id
```

*Plain English:* Real problem - you start your app and it says "port 8080 already in use." Something is already on that port; find it and stop it. Step 1: `sudo lsof -i :8080` (`lsof` = "list open files", `-i :8080` = "what's using port 8080"). It gives you a **PID** (process ID), a number that identifies the program. Step 2: `kill -9 <PID>` forces it to stop now. Flow: **find the PID -> kill the PID.** Like finding which car blocks your driveway (its plate), then having it towed.

**4. grep ERROR and count**
```bash
grep "ERROR" app.log          # show matching lines
grep -c "ERROR" app.log       # count matching lines
grep -i "error" app.log       # case-insensitive
```
- `-c` = count, `-i` = ignore case.

*Plain English:* A log file can have thousands of lines. `grep` filters to only the lines you care about - like Ctrl+F in a document, but it can also just give you the count. `grep "ERROR" app.log` shows the error lines, `-c` counts them instead of showing them, `-i` ignores case so it matches ERROR, Error, and error.

**5. Disk, memory, CPU**
```bash
df -h      # disk space, human-readable
free -m    # memory in MB
top        # live CPU/memory per process (press q to quit)
```

*Plain English:* Three "how healthy is this server" commands. `df -h` = how full are the drives (`-h` = human readable, GB not bytes). `free -m` = how much RAM is used/free, in MB. `top` = live view of CPU and memory per program (press `q` to quit). You run these when a server feels slow, to see if it's out of disk, out of RAM, or a program is eating the CPU.

**6. Service control (systemd)**
```bash
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl status nginx
sudo systemctl enable nginx    # start automatically on boot
```

*Plain English:* A "service" is a background program (like nginx or your app) managed by **systemd**, controlled with `systemctl`. `start`/`stop` turn it on/off now, `status` tells you if it's running and shows recent logs, `enable` makes it auto-start on every reboot. `sudo` = run as admin (services need admin rights). `status` is the one you'll use most when debugging "is it even running?"

**7. URL to page (say this in an interview)**
Browser checks DNS to turn the domain into an IP (cache, then DNS server). It opens a TCP connection to that IP on port 443 (HTTPS), does a TLS handshake, sends an HTTP request, the server responds, the browser renders it.

*Plain English:* You type `www.google.com` and press Enter. (1) **DNS - find the address:** the name is for humans, computers need a number (IP), so the browser asks a DNS server "what's the IP for google.com?" DNS is like a phone book. (2) **TCP - connect:** now it knows the IP, so it opens a connection, like dialing the number and the other side answering - the hello-hello-okay is the "TCP handshake." (3) **HTTP - ask for the page:** the browser says "send me the homepage" (HTTP, or HTTPS when encrypted); the server replies. (4) **Render:** the browser draws the page.

**8. Port vs IP vs subnet**
- **IP** = address of a machine (e.g. 172.16.3.10).
- **Port** = which service on that machine (8080 = your app, 22 = SSH, 443 = HTTPS).
- **Subnet `/24`** = a range of IPs sharing the first 24 bits. `172.16.3.0/24` = addresses `172.16.3.0` to `172.16.3.255` (256 addresses). The `/24` is the CIDR mask.

*Plain English:* Think of an apartment building. **IP** = the building's street address (identifies one machine, e.g. `172.16.3.10`). **Port** = the apartment number inside (identifies which service: 22 = SSH, 443 = HTTPS, 8080 = your app - same machine, many services). **Subnet `/24`** = a whole neighborhood, a group of IPs that belong together. `172.16.3.0/24` means all addresses from `172.16.3.0` to `172.16.3.255` (256 addresses); the `/24` says the first three numbers (`172.16.3`) are fixed and only the last changes. Smaller number after the slash = bigger neighborhood (`/16` is huge, `/32` is a single address).

**9. Test an API**
```bash
curl https://api.github.com                 # GET
curl -i https://api.github.com              # include response headers
curl -X POST -H "Content-Type: application/json" -d '{"name":"test"}' http://localhost:8080/tasks
```
- `-X` = HTTP method, `-H` = header, `-d` = request body, `-i` = show headers.

*Plain English:* `curl` sends an HTTP request from the command line - no browser or Postman needed. Great for "is my app responding?" A plain `curl URL` does a GET (just fetch). `-i` also shows response headers (like the status code). `-X POST` uses the POST method to create something, `-H` adds a header (here "I'm sending JSON"), `-d` is the data/body you send. Think of it as a text-only way to hit your API and see the raw reply.

**10. Security Group vs firewall**
A Security Group is AWS's virtual firewall on an EC2 instance. Key differences: it's **stateful** (if you allow inbound, the response is automatically allowed out), it only has **allow** rules (no explicit deny), and it attaches to instances/ENIs rather than running on the OS.

*Plain English:* Both decide what network traffic is allowed in/out - like a guard at a building door. A traditional firewall usually runs on the machine's OS or a network device and can have both allow and deny rules. An AWS Security Group is AWS's firewall for an EC2 server, with 3 things to remember: (1) **Stateful** - allow traffic in and the reply is automatically allowed out, no second rule. (2) **Allow-only** - only "allow" rules; anything not allowed is blocked by default. (3) **Attached to the instance, not the OS** - managed in the AWS console. (This touches AWS, covered properly in Week 7, so don't worry if it's not fully solid yet.)

---

# PART B - Bash scripting basics

A Bash script is a text file of shell commands that runs top to bottom. In DevOps you use Bash constantly: build scripts, health checks, cleanup jobs, CI steps, container entrypoints.

## B.1 Your first script
Create a file `hello.sh`:
```bash
#!/bin/bash
echo "Hello, DevOps"
```
Run it:
```bash
chmod +x hello.sh    # make it executable (do this once)
./hello.sh           # run it
```
**Explanation line by line:**
- `#!/bin/bash` = the **shebang**. It tells the OS to run this file with the bash interpreter. Always the first line.
- `echo "Hello, DevOps"` = prints text to the screen.
- `chmod +x hello.sh` = adds execute permission so you can run it with `./`.
- `./hello.sh` = runs the script in the current folder (`./` means "here").

## B.2 Variables
```bash
#!/bin/bash
name="Satyam"              # NO spaces around = (name = "x" is an error)
count=5
echo "Hi $name, count is $count"      # $ reads the value
echo "Today is $(date)"               # $(...) runs a command, inserts its output
```
**Explanation:**
- `name="Satyam"` sets a variable. Bash is picky: no spaces around `=`.
- `$name` reads it back. Prefer `"${name}"` with quotes to be safe with spaces.
- `$(date)` is **command substitution** - it runs `date` and drops the result into the string.

## B.3 Conditions (if / else)
```bash
#!/bin/bash
num=10
if [ "$num" -gt 5 ]; then
    echo "big"
elif [ "$num" -eq 5 ]; then
    echo "five"
else
    echo "small"
fi
```
**Explanation:**
- `[ ... ]` is the test. Mind the spaces: `[ "$num" -gt 5 ]`, spaces required inside the brackets.
- Number comparisons: `-eq` equal, `-ne` not equal, `-gt` greater, `-lt` less, `-ge`, `-le`.
- String comparisons: `=` equal, `!=` not equal, `-z` empty, `-n` not empty.
- `then ... fi` wraps the body. `fi` is `if` backwards - it closes the block.

### Numeric Comparison Operators (complete list)
- `-eq` → equal to (==)
- `-ne` → not equal to (!=)
- `-gt` → greater than (>)
- `-lt` → less than (<)
- `-ge` → greater than or equal to (>=)
- `-le` → less than or equal to (<=)

**Memory trick:** Think of the letters - **eq**ual, **n**ot **e**qual, **g**reater **t**han, **l**ess **t**han, **g**reater or **e**qual, **l**ess or **e**qual.

Check if a file exists:
```bash
if [ -f "/etc/hosts" ]; then echo "file exists"; fi
if [ -d "/tmp" ]; then echo "dir exists"; fi
```
- `-f` = regular file exists, `-d` = directory exists.

## B.4 Loops
```bash
#!/bin/bash
# for loop over a list
for server in web1 web2 web3; do
    echo "Checking $server"
done

# for loop with a counter
for i in {1..5}; do
    echo "Attempt $i"
done

# while loop
count=1
while [ "$count" -le 3 ]; do
    echo "count=$count"
    count=$((count + 1))      # $(( )) does math
done
```
**Explanation:**
- `for x in a b c; do ... done` runs the body once per item.
- `{1..5}` expands to `1 2 3 4 5`.
- `while [ cond ]; do ... done` repeats while the condition is true.
- `$((count + 1))` is **arithmetic** - the only place Bash does math easily.

### Taking User Input Inside Loops
You can use `read` inside loops to get input on each iteration:

```bash
#!/bin/bash

# Example 1: Loop until user says "quit"
while true; do
    read -p "Enter a name (or 'quit' to exit): " name
    if [ "$name" = "quit" ]; then
        break
    fi
    echo "Hello, $name!"
done

# Example 2: Loop a fixed number of times, getting input each time
for i in {1..3}; do
    read -p "Enter server $i name: " server
    echo "You entered: $server"
done

# Example 3: Loop and ask multiple questions per iteration
count=1
while [ $count -le 3 ]; do
    read -p "Enter username $count: " username
    read -p "Enter email for $username: " email
    echo "User $count: $username ($email)"
    count=$((count + 1))
done
```
**Key points:**
- `read -p "prompt text: " variable` displays a prompt and stores input in the variable.
- `while true; do ... done` creates an infinite loop; use `break` to exit.
- You can ask multiple questions per loop iteration.

## B.5 Functions
```bash
#!/bin/bash
greet() {
    echo "Hello, $1"      # $1 = first argument passed to the function
}
greet "Satyam"            # prints: Hello, Satyam
greet "World"             # prints: Hello, World
```
**Explanation:**
- `name() { ... }` defines a function.
- Inside, `$1`, `$2`, ... are the arguments passed when you call it.
- Call it just by writing its name followed by arguments.

### Passing Multiple Arguments to Functions
Functions can accept **any number** of arguments. Access them with `$1`, `$2`, `$3`, etc., or use `$@` for all:

```bash
#!/bin/bash

# Example 1: Function with 3+ arguments
create_user() {
    username=$1
    email=$2
    role=$3
    department=$4
    echo "Creating user:"
    echo "  Name: $username"
    echo "  Email: $email"
    echo "  Role: $role"
    echo "  Department: $department"
}

# Call with 4 arguments
create_user "Satyam" "satyam@example.com" "DevOps" "Engineering"

# Example 2: Function that accepts any number of arguments
greet_all() {
    echo "Greeting everyone:"
    for name in "$@"; do
        echo "  Hello, $name!"
    done
}

# Call with different numbers of arguments
greet_all "Alice" "Bob" "Charlie"
greet_all "Dave" "Eve"

# Example 3: Using special argument variables
count_args() {
    echo "You passed $# arguments"
    echo "First: $1"
    echo "Second: $2"
    echo "All: $@"
}

count_args "arg1" "arg2" "arg3" "arg4" "arg5"
```

**Special Variables for Arguments:**
- `$1, $2, $3, ...` → individual arguments (1st, 2nd, 3rd, ...)
- `$@` → all arguments as separate words (use in loops)
- `$#` → total number of arguments
- `$0` → the script name itself

### Real-World Example: Combining Loops and Functions with Input
```bash
#!/bin/bash

# Function that creates a server configuration
create_config() {
    server_name=$1
    ip=$2
    port=$3
    env=$4
    
    echo "[$server_name]"
    echo "ip=$ip"
    echo "port=$port"
    echo "environment=$env"
    echo "---"
}

# Loop to get multiple server configurations from user
read -p "How many servers to configure? " count

for i in $(seq 1 $count); do
    echo "Server $i:"
    read -p "  Name: " name
    read -p "  IP: " ip
    read -p "  Port: " port
    read -p "  Environment (dev/prod): " env
    
    # Pass all 4 arguments to function
    create_config "$name" "$ip" "$port" "$env"
done
```

## B.6 Common mistakes
- **Spaces around `=`**: `x = 5` is wrong, use `x=5`.
- **Missing spaces inside `[ ]`**: `[$x -gt 5]` is wrong, use `[ "$x" -gt 5 ]`.
- **Forgetting the shebang** `#!/bin/bash` on line 1.
- **Not quoting variables**: unquoted `$name` breaks when the value has spaces. Use `"$name"`.
- **Forgetting `chmod +x`** before `./script.sh`.
- Editing on Windows and getting `\r` errors: save scripts with LF line endings (Git Bash/WSL handle this; in VS Code set end-of-line to LF).

---

## Hands-on labs (do these - this is the real learning)

Try each yourself first. Solutions are at the bottom.

- **Lab 1:** Write `greet.sh` that takes a name as an argument and prints `Hello, <name>`. Run it as `./greet.sh Satyam`.
- **Lab 2:** Write `evenodd.sh` that reads a number and prints whether it is even or odd.
- **Lab 3:** Write `countdown.sh` that counts down from 5 to 1 using a loop, then prints "Done".
- **Lab 4:** Write `checkfile.sh` that takes a filename argument and prints whether that file exists.
- **Lab 5:** Write `backup.sh` that copies all `.txt` files from the current folder into a new folder called `backup`.

### This week's deliverable
Push **2 of these scripts** (your choice) to a new GitHub repo called `devops-bash-scripts`. That's the "done" marker for Week 1.

---

## Connect to your TCS work
At work, Jenkins pipeline steps and container entrypoints are often Bash. When you write a `sh 'mvn clean package'` stage in a Jenkinsfile, that's Bash running on an agent. Knowing conditions and exit codes lets you make a pipeline fail or continue correctly - which is exactly what Week 5-6 builds on.

---

## Week 1 interview Q&A (say these out loud on Friday)
- **Q: What is a shebang?** The `#!/bin/bash` line at the top of a script that tells the OS which interpreter to run the file with.
- **Q: Difference between `$1` and `$@` in a script?** `$1` is the first argument; `$@` is all arguments as a list.
- **Q: What does `chmod +x` do?** Adds execute permission so the file can be run as a program.
- **Q: How do you do math in Bash?** With `$(( ))`, e.g. `sum=$((a + b))`.
- **Q: What is command substitution?** `$(command)` runs the command and substitutes its output into the line, e.g. `now=$(date)`.
- **Q: How do you check if a file exists in Bash?** `if [ -f "path" ]; then ... fi`.
- **Q: What does `chmod 755` mean?** Owner read/write/execute, group and others read/execute.
- **Q: How do you find and kill a process on a port?** `lsof -i :PORT` to find the PID, then `kill -9 PID`.

---

## Cheat sheet
```bash
#!/bin/bash              # shebang (line 1 always)
name="value"            # set variable (no spaces around =)
echo "$name"            # read variable
result=$(date)          # command substitution
sum=$((a + b))          # arithmetic

if [ "$x" -gt 5 ]; then ... elif [ ... ]; then ... else ... fi
for i in {1..5}; do ... done
while [ "$c" -le 3 ]; do ... done
myfunc() { echo "$1"; }   # $1 = first arg

# tests: -eq -ne -gt -lt -ge -le (numbers), = != -z -n (strings), -f -d (file/dir)

chmod +x script.sh       # make executable
./script.sh arg1 arg2    # run with arguments

# useful one-liners
grep -c "ERROR" app.log         # count errors
df -h ; free -m ; top           # disk, memory, cpu
lsof -i :8080                   # who's on port 8080
curl -i http://localhost:8080   # test an endpoint
```

---

## Lab solutions (try first, then check)

**Lab 1 - greet.sh**
```bash
#!/bin/bash
echo "Hello, $1"
```

**Lab 2 - evenodd.sh**
```bash
#!/bin/bash
read -p "Enter a number: " n
if [ $((n % 2)) -eq 0 ]; then
    echo "$n is even"
else
    echo "$n is odd"
fi
```
`read -p` prompts and stores input in `n`. `n % 2` is the remainder; 0 means even.

**Lab 3 - countdown.sh**
```bash
#!/bin/bash
for i in 5 4 3 2 1; do
    echo "$i"
done
echo "Done"
```

**Lab 4 - checkfile.sh**
```bash
#!/bin/bash
if [ -f "$1" ]; then
    echo "$1 exists"
else
    echo "$1 not found"
fi
```

**Lab 5 - backup.sh**
```bash
#!/bin/bash
mkdir -p backup           # -p: don't error if it already exists
cp *.txt backup/ 2>/dev/null
echo "Copied .txt files into backup/"
```
`mkdir -p` creates the folder safely. `2>/dev/null` hides the error if there are no `.txt` files.
