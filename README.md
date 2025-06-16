# helpful-scripts

A collection of small automation utilities.  Currently contains:

## gh-weekly-prs.sh
Generates a weekly Markdown report of pull-requests **you** updated (opened, pushed, or merged) in the previous work-week (Monday–Friday).

The report is saved to iCloud Drive in the path:
```
~/Library/Mobile Documents/com~apple~CloudDocs/Documents/Markdown/Limble/Weekly/<year>/<month>/<yy>-W<week>.md
```
where `<week>` is the ISO week number.

### Usage
```bash
chmod +x gh-weekly-prs.sh     # once
./gh-weekly-prs.sh            # run any time
```

The script relies on GitHub CLI (`gh`) and your logged-in credentials (`gh auth login`).

### How it works
1. Calculates the last completed Monday–Friday window.
2. Runs a GitHub search:
   ```text
   author:@me updated:<start>..<end> is:pr
   ```
3. Writes a Markdown list (one line per PR) to the weekly file.
