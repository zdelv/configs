# Vim 9 configuration

Install directions:

```sh
chmod +x ./install-plugins
./install-plugins
/opt/homebrew/bin/vim
```

The installer copies the tracked configuration into `~/.config/vim`, installs
plugins under `~/.config/vim/pack/vendor/start`, and creates
`~/.vimrc -> ~/.config/vim/vimrc`. It only replaces that symlink when it already
points to this checkout or the installed configuration; other existing Vim
configurations are left untouched and reported as an error.

## External tools

The configuration registers a language server only when its executable is on
`PATH`. The translated server set is:

- `rust-analyzer`
- `oxfmt` (started with `--lsp`)

The Neovim setup used Mason to install these. Vim's LSP client deliberately does
not depend on Neovim's Mason directory; install them with Homebrew, Cargo, npm,
or another system-level tool manager. `clang-format` provide the same explicit
formatters as Conform. `rg`, `jq`, and `typst` enable live grep, `:FormatJson`,
and `:TypstPreview`, respectively.

Run `:LspServer show` to inspect active servers. Plugin revisions are pinned in
`.plugin-lock`; rerunning `./install-plugins` checks out those exact commits.
When a plugin has no lock entry yet, the installer installs or updates it once
and records the resulting commit. Remove or edit an entry deliberately when
you want to update that plugin.

The upstream Vim9 LSP client currently performs pull-diagnostics requests
synchronously. A slow server (notably rust-analyzer while indexing) can
therefore freeze Vim for several seconds when a buffer attaches. This setup
applies a small local patch that sends those requests asynchronously while
retaining normal diagnostic updates. `./install-plugins` removes the patch,
updates the plugin, and reapplies it automatically.

`:term` opens in the current window, matching Neovim. Use `:TermSplit` or
`:TermVSplit` when you explicitly want a horizontal or vertical terminal split.
Terminal programs use the Catppuccin Mocha ANSI palette instead of Vim's
high-saturation default colors. Terminal windows also suppress line numbers,
the sign-column gutter, and `~` end-of-buffer markers; ordinary file windows
restore those settings automatically.

On macOS, Vim's `+` and `*` registers use an explicit `pbcopy`/`pbpaste`
provider. Together with `clipboard=unnamedplus`, ordinary `y`, `d`, and `p`
operate on the macOS system clipboard in file and terminal buffers.

## LSP troubleshooting

From a source buffer, use `:LspServer show status` for that buffer's server or
`:LspShowAllServers` for every registered server. Vim-level errors remain in
`:messages`.

Server stdout and stderr are not recorded by default. To reproduce a startup
or initialization failure with logging enabled:

```vim
:LspServer debug on
:LspServer restart
```

Then open stderr with `:LspServer debug errors` and protocol/stdout messages
with `:LspServer debug messages`. On macOS these files are stored as
`/tmp/lsp-<server-name>.err` and `/tmp/lsp-<server-name>.log`. Use
`:LspServer debug off` when finished.

In an LSP completion popup, `<Tab>` accepts the selected suggestion. If no
suggestion is selected yet, it selects and accepts the first one, matching the
former `nvim-cmp` configuration. Outside a completion popup, `<Tab>` retains
its normal insertion behavior.
