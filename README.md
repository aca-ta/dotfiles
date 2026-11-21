# dotfiles

## Install

```bash
cat << EOS > etc/gitconfig_local
[user]
    name = xxx
    email = xxx@xxx.com
EOS

./install.sh
```

## Runtime setup

Homebrew must already be available. Run from the repository root:

```bash
./setup.sh --help
./setup.sh runtimes
# Or update one runtime:
./setup.sh node
./setup.sh python
./setup.sh go
```

`./setup.sh` with no arguments retains the full setup behavior, including shell,
editor, Git and other tool configuration. Use a named target on an existing machine.

`tool-versions.sh` is the shared version list. Review and update these pins when
adopting a new release; setup does not follow the moving `lts/*` alias.

- Node.js: 24.22.1, with nvm 0.40.8 or newer. The installed version becomes `default`.
- Go: 1.27.3, installed through goenv. Existing installations are retained.
- Python: 3.13.17, with pip >= 26.2.2 and certifi >= 2026.10.19.

Python setup creates a versioned `nvim-<version>` environment. It updates pip and
installs the Neovim provider before switching `pyenv global` and the
`versions/nvim-current` symlink. The legacy `nvim` environment is never uninstalled.
Neovim uses the new symlink when present and falls back to the legacy environment.
Repeated setup reuses the versioned environment. `PYENV_ROOT`, `GOENV_ROOT`, and
`NVM_DIR` are respected.

The Python build definition in `python-build/` is a checksum-pinned copy of the
upstream definition, used only if the installed pyenv does not know that release.
Remove it after the packaged pyenv includes the version. Runtime setup updates the
Homebrew CA bundle first and uses it for its downloads and pip installation;
it does not change the system CA store or persist global TLS overrides.

Open a new terminal after setup, or run `nvm use default` for Node.js. Project
`.nvmrc`, `.python-version`, `.go-version`, lockfiles and already-running processes
can still select other versions and need separate review.

## Maintenance

- [October 2026 eMudhra response](docs/maintenance/2026-10-emudhra.md)
- `bash tests/runtime-setup.sh` checks repeat setup and failure handling using mocks.
- `bash tests/check-emudhra.sh` checks TLS probe result classification using mocks.

The maintenance guide covers CA stores and prebuilt CLIs separately from the
normal runtime setup. Updating Go alone does not rebuild existing Go binaries.
