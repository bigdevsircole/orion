Pushing this local project to GitHub

This document explains how to push the local folder (d:\CODINGS\orion) to a GitHub repository.

Option A — Quick push using the provided PowerShell script

1. Open PowerShell and change to the project folder:
   cd d:\CODINGS\orion

2. Run the helper script (replace the URL with your repo):
   .\push-to-github.ps1 -RemoteUrl "https://github.com/bigdevsircole/orion.git" -Branch main

Notes:

- The script will initialize git if necessary, commit any uncommitted changes, add/update the `origin` remote, and push to the specified branch.
- You will be prompted for credentials if required. For a smoother flow, see Option B.

Option B — Use GitHub CLI (recommended)

1. Install GitHub CLI: https://cli.github.com/
2. Authenticate: `gh auth login` (choose HTTPS and authenticate via browser or token)
3. From the project folder run:
   git init
   git add -A
   git commit -m "Initial commit"
   gh repo create bigdevsircole/orion --public --source=. --remote=origin
   git push -u origin main

Option C — Manually with Personal Access Token (PAT)

1. Create a repository on GitHub (https://github.com/new) named `orion` under your account `bigdevsircole`.
2. Create a PAT with repo scope: https://github.com/settings/tokens
3. In PowerShell run:
   git init
   git add -A
   git commit -m "Initial commit"
   git remote add origin https://<USERNAME>:<PAT>@github.com/bigdevsircole/orion.git
   git push -u origin main

Security note: avoid embedding PATs in scripts that remain on disk in plaintext. Prefer `gh auth login` or the Windows credential manager.

If you want me to run the push for you, provide an authenticated method (temporary PAT or gh oauth) — otherwise run the script locally as shown above.
