# catTree

`catTree` is a pair of simple scripts (Bash and PowerShell) designed to **collect and concatenate the contents of files in a directory tree into a single text file**.

The primary use case is preparing **project source code or selected files as plain text**, so they can be easily:
- copied (CTRL+C / CTRL+V),
- attached,
- or pasted directly into **any AI model or text-based tool**.

Because the output is just a `.txt` file, it is model-agnostic and works everywhere.

---

## Features

- Recursively scans a directory tree
- Selectively **includes files by extension**
- Allows **excluding directories** (e.g. `.git`, `node_modules`)
- Allows **excluding specific files or glob patterns**
- Outputs everything into **one structured text file**
- Clearly marks:
  - included files
  - skipped directories
  - skipped files
  - files without allowed extensions

---

## Included Scripts

| Script | Platform |
|------|---------|
| `catTree.sh` | Linux / macOS / WSL (Bash) |
| `catTree.ps1` | Windows (PowerShell) |

Both scripts serve the same purpose and behave similarly.

---

## Output Format

The output is saved to:

```
output.txt
```

Each included file is wrapped like this:

```
===== ./path/to/file.ext =====
<file contents here>
```

Skipped items are clearly marked:

```
[SKIP_DIR] ./node_modules
[SKIP_FILE] ./secret.env
[NO_CAT] ./image.png
```

This makes the result easy to read for both humans and AI models.

---

## Configuration

Before running the script, open it and edit these arrays:

### Excluded directories

Directories that should **never be scanned**:

```bash
EXCLUDE_DIRS=(
  .git
  node_modules
  dist
)
```

```powershell
$ExcludeDirs = @(
  ".git"
  "node_modules"
  "dist"
)
```

---

### Excluded files

Specific files or glob patterns to skip:

```bash
EXCLUDE_FILES=(
  secrets.env
  "*.log"
)
```

```powershell
$ExcludeFiles = @(
  "secrets.env"
  "*.log"
)
```

---

### Allowed extensions

Only files with these extensions will be concatenated:

```bash
ALLOWED_EXTENSIONS=(
  .c
  .h
  .cpp
  .py
  .js
  .ts
  .md
)
```

```powershell
$AllowedExtensions = @(
  ".c"
  ".h"
  ".cpp"
  ".py"
  ".js"
  ".ts"
  ".md"
)
```

Files without these extensions will be listed as `[NO_CAT]`.

---

## Usage

### Bash (Linux / macOS / WSL)

```bash
chmod +x catTree.sh
./catTree.sh
```

---

### PowerShell (Windows)

```powershell
.\catTree.ps1
```

If script execution is blocked, you may need:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

---

## Typical Use Case (AI Context)

1. Configure allowed extensions and exclusions
2. Run the script in your project root
3. Open `output.txt`
4. Copy its contents
5. Paste into your AI tool of choice
6. Ask questions like:
   - “Review this code”
   - “Explain this project”
   - “Find bugs or security issues”
   - “Refactor this module”

No plugins, no uploads, no special formats required.

---

## Notes

- The scripts **do not modify any files**
- Binary files are never concatenated
- Large projects can produce large output files — adjust filters accordingly
- Directory skip notices are written only once per directory to reduce noise

---

## License

Use, modify, and distribute freely. No warranty.
