## General Guidelines

- Make no mistakes!
- Follow XDG desktop standards
- Regularly reason about security implications of the code
- Use `$HOME/.claude/outputs` as a scratch directory.
- In the Bash tool use absolute paths over `cd`

## Available Tools

- fd, rg, dnsutils, lsof, gdb, binutils, ast-grep, graphicsmagic (gm)
- On Linux: strace/sysdig/bcc
- macOS: dtrace
- pexpect-cli: Persistent pexpect sessions for automating interactive terminal
  applications. Start a session with `pexpect-cli --start`, then send Python
  pexpect code via stdin to control programs. Example:
  `session=$(pexpect-cli
  --start); echo 'child = pexpect.spawn("bash"); child.sendline("pwd");
  child.expect("$"); print(child.before.decode())' | pexpect-cli $session`

## Nix-specific

- Use `--log-format bar-with-logs` with Nix for improved build log output.
- Add new untracked files in Nix flakes with `git add`.
- To get a rebuild of a nix package change the nix expression instead of
  `--rebuild`
- Prefer nix to fetch python dependencies
- When looking for build dependencies in a nix-shell/nix develop, check
  environment variables for store paths to find the correct dependency versions.
- On nix build failures:
  - use `nix log /nix/store/xxxx | grep <key-word`, figure out the root cause of
    a bug.
- My nix.conf has remote builders for aarch64-linux/aarch64-darwin/x86_64-linux
  by default, for NixOS tests. Therefore, use x86_64-linux on macOS machines
- Use nix-locate to find packages by path. i.e. `nix-locate bin/ip`
- Use `nix run` to execute applications that are not installed.
- Use `nix eval` instead of `nix flake show` to look up attributes in a flake.
- Generate/Update patch files for packages:
  1. git clone
  2. Optional: apply existing patch
  3. Use the Edit tool to do the change
  4. Use git format-patch to generate the new patch
- Do not use `nix flake check` on the whole flake; it is too slow. Instead,
  build individual tests.

## Code Quality & Testing

- practice TDD
- In flakes: format code with `flake-fmt`
- Write shell scripts that pass `shellcheck`.
- Write Python code for 3.13 that conforms to `ruff format`, `ruff check` and
  `mypy`
- Add debug output or unit tests when troubleshooting i.e. dbg!() in Rust
- When writing test use realistic inputs/outputs that test the actual code as
  opposed to mocked out versions
- Start fixing bugs by implementing a failing regression test first.
- When a linter is detecting dead code, remove the dead code.
- IMPORTANT: GOOD: When given a linter error, address the root cause of the
  linting error. BAD: silencing lint errors. Exhaustivly fix all linter errors.

## Output format

Respond like smart caveman. Cut all filler, keep technical substance.

- Drop articles (a, an, the), filler (just, really, basically, actually).
- Drop pleasantries (sure, certainly, happy to).
- No hedging. Fragments fine. Short synonyms.
- Technical terms stay exact. Code blocks unchanged.
- Pattern: [thing] [action] [reason]. [next step].

## Running programs

- CRITICAL: ALWAYS use pueue for ANY command that might take longer than 10
  seconds to avoid timeouts. This includes but is not limited to:
  - `nix build` commands
  - Any test runs that might be slow
  - Any build operations (make, ninja, cargo, uv run)

  To run and wait (note: quote the entire command to preserve argument quoting):
  ```bash
  pueue add -- 'command arg1 "arg with spaces"'
  pueue follow <task-id> | tail -n 10 # waits for the command to finish
  ```

## Git

- When writing commit messages/comments focus on the WHY rather than the WHAT.
- Always test/lint/format your code before committing.
- Use the gh tool to interact with GitHub i.e.: `gh run view 18256703410 --log`
- Use the tea CLI tool to interact with Gitea i.e.: `tea pr 5519 --comments`
- To get buildbot ci logs, use buildbot-pr-check on the pull request: i.e.
  `buildbot-pr-check https://github.com/numtide/nix-ai-tools/pull/993`

## Search

- Recommended: Use GitHub code search to find examples for libraries and APIs:
  `gh search code "foo lang:nix"`.
- Prefer cloning source code over web searches for more accurate results.
  Various projects are available in `$HOME/git`, including:
- `$HOME/git/nixpkgs`
- `$HOME/git/nix`

- When a linter complains about unused code, try to remove the code after making
  sure it's unused
- No #[allow(dead_code)], instead actually use the code
