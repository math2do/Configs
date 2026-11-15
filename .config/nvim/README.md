# Neovim Config Guide

A reference for this Neovim setup: how it's organized, which plugins it loads, and every custom key shortcut.

> **Leader key:** `<Space>` (written as `<leader>` below). Press `<Space>` and wait — **which-key** pops up instantly and shows what comes next.
> **Find any keymap live:** `<leader>sk` (Telescope keymap search).

---

## Table of contents

1. [How the config is organized](#how-the-config-is-organized)
2. [Editor options](#editor-options)
3. [Key shortcuts](#key-shortcuts)
   - [General editing](#general-editing)
   - [Buffers, windows and tabs](#buffers-windows-and-tabs)
   - [Search with Telescope](#search-with-telescope)
   - [LSP (code intelligence)](#lsp-code-intelligence)
   - [Diagnostics](#diagnostics)
   - [Completion and Copilot](#completion-and-copilot)
   - [Text objects and surround](#text-objects-and-surround)
   - [Git](#git)
   - [File explorer (Neo-tree)](#file-explorer-neo-tree)
   - [Terminal and Lazygit](#terminal-and-lazygit)
   - [Debugging (DAP)](#debugging-dap)
   - [REST client (Kulala)](#rest-client-kulala)
   - [Java only](#java-only)
   - [Tmux navigation](#tmux-navigation)
4. [Plugins](#plugins)
5. [Language support](#language-support)
6. [Useful commands](#useful-commands)
7. [Known quirks](#known-quirks)

---

## How the config is organized

```text
~/.config/nvim/
├── init.lua                     # Entry point: options, keymaps, core plugins (Kickstart-based)
├── ftplugin/
│   └── java.lua                 # Java: jdtls (LSP) + Lombok + debug/test bundles
└── lua/
    ├── kickstart/plugins/       # Near-upstream Kickstart plugins (enabled from init.lua)
    │   ├── autopairs.lua
    │   ├── debug.lua            # nvim-dap (Go + Java)
    │   ├── gitsigns.lua         # Git hunk keymaps
    │   ├── indent_line.lua      # (disabled)
    │   ├── lint.lua             # nvim-lint (markdownlint)
    │   └── neo-tree.lua         # File explorer
    └── custom/plugins/          # Your own plugins — auto-imported by lazy.nvim
        ├── alpha.lua            # Start screen
        ├── coc.lua              # coc.nvim
        ├── comment.lua          # ts-comments (JS/TS/HTML)
        ├── copilot.lua          # GitHub Copilot
        ├── frontend.lua         # Auto-close/rename HTML/JSX tags
        ├── helm-ls.lua          # Helm filetype support
        ├── kulala.lua           # REST/HTTP client
        ├── lualine.lua          # Statusline
        ├── markdown.lua         # render-markdown
        ├── noice.lua            # Fancy cmdline/messages UI
        ├── nvim-tmux-navigator.lua
        ├── papercolor.lua       # (empty / disabled theme)
        └── toggleterm.lua       # Floating terminal + lazygit
```

- **Plugin manager:** [lazy.nvim](https://github.com/folke/lazy.nvim). It bootstraps itself on first launch.
- **Adding a plugin:** create a new file in `lua/custom/plugins/` that returns a plugin spec.
  It is picked up automatically via `{ import = 'custom.plugins' }`.
- **Managed via GNU Stow:** this directory lives in `~/Configs/.config/nvim` and is symlinked
  to `~/.config/nvim`.

---

## Editor options

| Setting | Value | Meaning |
| --- | --- | --- |
| Line numbers | `number` + `relativenumber` | Absolute number on current line, relative elsewhere |
| Indentation | 2 spaces (`expandtab`, `shiftwidth=2`, `tabstop=2`) | Tabs become spaces; `guess-indent` adapts per file |
| Wrapping | `wrap = false` | Long lines scroll horizontally (toggle with `<leader>lw`) |
| Clipboard | `unnamedplus` | Yank/paste uses the system clipboard |
| Search | `ignorecase` + `smartcase`, `hlsearch = false` | Case-insensitive unless you type a capital |
| Undo | `undofile = true` | Undo history survives closing the file |
| Swap/backup | disabled | No `.swp` or backup files |
| Scrolling | `scrolloff=4`, `sidescrolloff=8` | Keeps context around the cursor |
| Splits | `splitright`, `splitbelow` | New splits open right / below |
| Timeouts | `timeoutlen=300`, `updatetime=250` | Faster key-sequence and CursorHold response |
| Mouse | enabled | Handy for resizing splits |
| `confirm` | on | `:q` on unsaved changes asks instead of failing |
| Keywords | `-` is part of a word | `foo-bar` counts as one word for `w`, `*`, etc. |
| Comments | `formatoptions -= cro` | No auto comment leader on new lines |
| End of line | `fixendofline = false` | Files are saved without forcing a trailing newline |
| Theme | `tokyonight-night`, transparent background | Comments/line numbers set to `#737aa2` |

**Autocommand:** yanked text is briefly highlighted.

---

## Key shortcuts

Mode legend: **n** = normal, **i** = insert, **v** = visual, **t** = terminal.

### General editing

| Keys | Mode | Action |
| --- | --- | --- |
| `<C-s>` | n | Save file |
| `<C-q>` | n | Save **and** quit (`:wq`) |
| `<A-j>` / `<A-k>` | n, i, v | Move line (or selection) down / up |
| `<` / `>` | v | Indent left / right and keep selection |
| `p` | v | Paste over selection **without** overwriting the yank register |
| `x` | n | Delete char without copying it to a register (see [quirks](#known-quirks)) |
| `<C-d>` / `<C-u>` | n | Half-page down / up, cursor centered |
| `n` / `N` | n | Next / previous search match, centered |
| `<Esc>` | n | Clear search highlight |
| `<leader>lw` | n | Toggle line wrap |
| `<leader>f` | n, v | Format buffer (conform.nvim) |
| Arrow keys | n | **Disabled** — prints "Use h/j/k/l to move!!" |

Formatting also runs automatically **on save** (see [Language support](#language-support)).

### Buffers, windows and tabs

| Keys | Mode | Action |
| --- | --- | --- |
| `<Tab>` / `<S-Tab>` | n | Next / previous buffer |
| `<leader><leader>` | n | Fuzzy-pick an open buffer |
| `<leader>nb` | n | New empty buffer |
| `<leader>xb` | n | Close (force-delete) current buffer |
| `<leader>v` | n | Split vertically |
| `<leader>h` | n | Split horizontally |
| `<leader>se` | n | Make all splits equal size |
| `<leader>xw` | n | Close current split |
| `<C-h/j/k/l>` | n | Move to split left/down/up/right (also crosses into tmux panes) |
| `<leader>to` | n | New tab |
| `<leader>tx` | n | Close tab |
| `<leader>tn` / `<leader>tp` | n | Next / previous tab |

> The tab line is hidden (`showtabline=0`), so tabs are invisible unless you check `:tabs`.

### Search with Telescope

| Keys | Action |
| --- | --- |
| `<leader>sf` | Find files |
| `<leader>sg` | Live grep across the project |
| `<leader>sw` | Grep the word under the cursor |
| `<leader>s/` | Live grep only in open files |
| `<leader>/` | Fuzzy search in the current buffer |
| `<leader>s.` | Recent files |
| `<leader><leader>` | Open buffers |
| `<leader>sd` | Diagnostics |
| `<leader>sh` | Help tags |
| `<leader>sk` | Keymaps |
| `<leader>ss` | List all Telescope pickers |
| `<leader>sr` | Resume last search |
| `<leader>sn` | Search files in your Neovim config |

**Inside Telescope:** `<C-/>` (insert) or `?` (normal) shows the picker's own keymaps. `<C-n>`/`<C-p>` move, `<CR>` opens,
`<C-x>`/`<C-v>` open in horizontal/vertical split.

### LSP (code intelligence)

Available in any buffer where a language server is attached.

| Keys | Action |
| --- | --- |
| `grd` | Go to definition (jump back with `<C-t>` or `<C-o>`) |
| `grD` | Go to declaration (e.g. C header) |
| `grr` | Find references |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `grn` | Rename symbol |
| `gra` | Code action (n and v) |
| `gO` | Document symbols |
| `gW` | Workspace symbols |
| `K` | Hover documentation (Neovim default) |
| `<leader>th` | Toggle inlay hints (if the server supports them) |

Hovering the cursor on a symbol highlights its other references in the buffer.

### Diagnostics

| Keys | Action |
| --- | --- |
| `]d` / `[d` | Next / previous diagnostic |
| `<leader>d` | Show diagnostic under cursor in a float |
| `<leader>q` | Send diagnostics to the location list |
| `<leader>sd` | Search all diagnostics with Telescope |

### Completion and Copilot

**blink.cmp** (LSP, paths, snippets, Lua API) — insert mode:

| Keys | Action |
| --- | --- |
| `<C-space>` | Open menu / toggle docs |
| `<C-n>` / `<C-p>` (or `<Up>`/`<Down>`) | Next / previous item |
| `<C-y>` | Accept (auto-imports and expands snippets) |
| `<C-e>` | Close menu |
| `<C-k>` | Toggle signature help |

**GitHub Copilot** — insert mode:

| Keys | Action |
| --- | --- |
| `<Tab>` | Accept full Copilot suggestion (falls back to a normal Tab) |
| `<C-f>` | Accept next word of the suggestion |

Run `:Copilot setup` once to authenticate, `:Copilot status` to check it.

### Text objects and surround

From **mini.ai** and **mini.surround**:

| Keys | Example meaning |
| --- | --- |
| `va)` | Select **a**round parentheses |
| `ci'` | Change **i**nside single quotes |
| `yinq` | Yank inside **n**ext quote |
| `saiw)` | **S**urround **a**dd: wrap inner word in `()` |
| `sd'` | **S**urround **d**elete: remove surrounding `'` |
| `sr)'` | **S**urround **r**eplace: `()` → `''` |

**Autopairs** closes brackets/quotes as you type, and **nvim-ts-autotag** auto-closes/renames HTML & JSX tags.
Commenting uses Neovim's built-in `gcc` (line) and `gc{motion}` / `gc` (visual), with **ts-comments** fixing comment style in JSX/TSX.

### Git

**Gitsigns** (gutter shows `+`, `~`, `_`):

| Keys | Mode | Action |
| --- | --- | --- |
| `]c` / `[c` | n | Next / previous changed hunk |
| `<leader>gp` | n | Preview hunk |
| `<leader>gs` | n | Stage hunk |
| `<leader>hs` | v | Stage selected lines |
| `<leader>gr` | n, v | Reset hunk (or selected lines) |
| `<leader>gS` | n | Stage whole buffer |
| `<leader>gR` | n | Reset whole buffer |
| `<leader>gu` | n | "Undo stage hunk" (see [quirks](#known-quirks)) |
| `<leader>gb` | n | Blame current line (popup) |
| `<leader>gd` | n | Diff against index |
| `<leader>gD` | n | Diff against last commit |
| `<leader>tb` | n | Toggle inline blame for current line |
| `<leader>tD` | n | Preview deleted lines inline |
| `<leader>gg` | n | Open **Lazygit** in a floating terminal (saves file first) |

### File explorer (Neo-tree)

| Keys | Action |
| --- | --- |
| `\` | Open Neo-tree and reveal the current file |
| `\` (inside tree) | Close Neo-tree |
| `?` (inside tree) | Show all Neo-tree keys |

Common in-tree keys: `<CR>` open, `a` add file (end with `/` for a folder), `d` delete, `r` rename, `c` copy, `m` move, `H` toggle hidden.
Dotfiles and gitignored files are shown by default.

### Terminal and Lazygit

| Keys | Mode | Action |
| --- | --- | --- |
| `<C-\>` | n, i, v, t | Save current file and toggle a floating terminal |
| `<Esc><Esc>` | t | Leave terminal mode (back to normal mode) |
| `<leader>gg` | n | Toggle Lazygit |

### Debugging (DAP)

Supports **Go** (delve) and **Java** (java-debug-adapter). The DAP UI opens automatically when a session starts.

| Keys | Action |
| --- | --- |
| `<F5>` | Start / continue |
| `<F1>` | Step into |
| `<F2>` | Step over |
| `<F3>` | Step out |
| `<F7>` | Toggle DAP UI (see last session output) |
| `<leader>b` | Toggle breakpoint |
| `<leader>B` | Conditional breakpoint (prompts for condition) |
| `<leader>dc` | Java: run/debug test class |
| `<leader>dm` | Java: run/debug nearest test method |

Java debug configurations: **Attach** to `127.0.0.1:5005`, or **Launch** current file (prompts for main class).

### REST client (Kulala)

Works in `.http` / `.rest` files. Prefix: `<leader>R`.

| Keys | Action |
| --- | --- |
| `<leader>Rs` | Send request under cursor |
| `<leader>Ra` | Send all requests in file |
| `<leader>Rb` | Open scratchpad |

Press `<leader>R` and wait for which-key to see the rest of Kulala's keys.

### Java only

Set up in `ftplugin/java.lua` (runs when a `.java` file opens):

- Starts **jdtls** with the **Lombok** agent, rooted at the nearest `.git`, `mvnw`, `gradlew`, `pom.xml` or `build.gradle`.
- Loads debug + test bundles so `<leader>dc` / `<leader>dm` work.
- `<leader>ai` — code action (e.g. organize imports, generate getters).
- Formats with **google-java-format** on save.

### Tmux navigation

With **vim-tmux-navigator** and the matching config in `~/.tmux.conf`, `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` move seamlessly
between Neovim splits **and** tmux panes.

---

## Plugins

### Core (in `init.lua`)

| Plugin | Purpose |
| --- | --- |
| `lazy.nvim` | Plugin manager (`:Lazy`) |
| `guess-indent.nvim` | Auto-detect indentation per file |
| `which-key.nvim` | Popup showing available key continuations |
| `telescope.nvim` (+ fzf-native, ui-select) | Fuzzy finder for files, grep, LSP, etc. |
| `nvim-lspconfig` + `mason.nvim` + `mason-lspconfig` + `mason-tool-installer` | Language servers, auto-installed |
| `fidget.nvim` | LSP progress spinner |
| `lazydev.nvim` | Lua LSP knows Neovim APIs |
| `nvim-jdtls` | Java language server integration |
| `conform.nvim` | Formatting (manual + on save) |
| `blink.cmp` + `LuaSnip` | Autocompletion and snippets |
| `tokyonight.nvim` | Colorscheme (night, transparent) |
| `todo-comments.nvim` | Highlights `TODO`, `NOTE`, `FIX`, `WARN` in comments |
| `mini.nvim` | `mini.ai`, `mini.surround`, `mini.statusline` |
| `nvim-treesitter` | Syntax highlighting & indentation |
| `gitsigns.nvim` | Git signs + hunk actions |

### Kickstart extras (`lua/kickstart/plugins/`)

| Plugin | Purpose |
| --- | --- |
| `nvim-dap` + `nvim-dap-ui` + `mason-nvim-dap` + `nvim-dap-go` | Debugger |
| `nvim-lint` | Linting (markdownlint for Markdown) |
| `nvim-autopairs` | Auto-close brackets/quotes |
| `neo-tree.nvim` | File explorer |
| `indent-blankline.nvim` | **Disabled** (commented out in `init.lua`) |

### Custom (`lua/custom/plugins/`)

| Plugin | Purpose |
| --- | --- |
| `alpha-nvim` | Startify-style start screen with recent files |
| `coc.nvim` | Alternative completion/LSP engine (see [quirks](#known-quirks)) |
| `copilot.vim` | GitHub Copilot suggestions |
| `ts-comments.nvim` | Correct comment strings in JS/TS/JSX/HTML |
| `nvim-ts-autotag` | Auto-close and rename HTML/JSX tags |
| `helm-ls.nvim` | Helm chart support |
| `kulala.nvim` | HTTP/REST client |
| `lualine.nvim` | Statusline |
| `render-markdown.nvim` | Pretty in-buffer Markdown rendering |
| `noice.nvim` (+ nui, nvim-notify) | Modern cmdline, messages and notifications |
| `vim-tmux-navigator` | Seamless tmux/Neovim navigation |
| `toggleterm.nvim` | Floating terminal + Lazygit |

---

## Language support

| Language | LSP | Formatter (on save) | Debugger |
| --- | --- | --- | --- |
| Lua | `lua_ls` | `stylua` (single quotes) | — |
| Go | `gopls` | `goimports` → `gofmt` | delve |
| Python | `pyright` (basic type checking) | `black` | — |
| C / C++ | `clangd` | `clang-format` (Google style, 2-space indent, no column limit) | — |
| Java | `jdtls` (+ Lombok) | `google-java-format` | java-debug-adapter |
| JS / TS / JSX / TSX | `ts_ls` (+ `tailwindcss`, `eslint` installed) | `prettierd` / `prettier` (uses `~/Configs/.prettierrc`) | — |
| HTML / CSS / JSON | — | `prettierd` / `prettier` | — |
| YAML | `yaml-language-server` | `yamlfmt` | — |
| Helm | `helm_ls` (yamlls for `templates/**`) | — | — |
| Markdown | — (linted by `markdownlint`) | `markdownlint` (uses `~/Configs/.markdownlint.json`) | — |
| Shell | — | `shfmt` | — |

Everything above is auto-installed by Mason on startup (except `shfmt`, `prettier` and `markdownlint`, which must be on your `PATH`).

Treesitter parsers pre-installed: bash, c, diff, html, lua, luadoc, markdown, markdown_inline, query, vim, vimdoc, python, javascript,
typescript, tsx. Others auto-install when you open the file; if one doesn't, run `:TSInstall <lang>`.

---

## Useful commands

| Command | What it does |
| --- | --- |
| `:Lazy` | Plugin manager UI (`U` update, `S` sync, `?` help) |
| `:Mason` | Install/update LSPs, formatters, debuggers (`g?` help) |
| `:LspInfo` / `:checkhealth vim.lsp` | Show attached language servers |
| `:ConformInfo` | Show which formatters apply to the current buffer |
| `:checkhealth` | Diagnose config problems |
| `:TSInstall <lang>` / `:TSUpdate` | Install / update Treesitter parsers |
| `:Copilot setup` / `:Copilot status` | Authenticate / check Copilot |
| `:Telescope colorscheme` | Preview installed colorschemes |
| `:Noice` | Message history |
| `:Tutor` | Built-in Vim tutorial |

---

## Known quirks

Things noticed while documenting the config. Each one can be fixed if you want.

1. **`x` mapping has a stray quote** — `init.lua` maps `x` to `"_x"` (note the trailing `"`). After `x`, Neovim waits for a
   register name, so the **next key you press may be swallowed**. Fix: change it to `'"_x'`.
2. **Tmux navigator keymaps are malformed** — `nvim-tmux-navigator.lua` maps `'C-h'` instead of `'<C-h>'`. That maps the
   literal keys `C` `-` `h`, which makes the built-in `C` (change to end of line) pause for `timeoutlen` before acting.
   Navigation still works because the plugin provides `<C-h/j/k/l>` itself, so those four lines can just be deleted.
3. **`<leader>gu` doesn't undo** — it's labeled "undo stage hunk" but calls `stage_hunk` again (in recent gitsigns,
   calling `stage_hunk` on a staged hunk does unstage it, so it behaves like `<leader>gs`).
4. **Two completion engines** — both `coc.nvim` and `blink.cmp` + native LSP are loaded. They can show duplicate
   popups or diagnostics. Consider removing `coc.lua` if you don't actively use it.
5. **Two statuslines** — `mini.statusline` and `lualine` are both set up; lualine wins. You can drop the
   `mini.statusline` setup in `init.lua`.
6. **Leader prefix overlaps** — `<leader>h` (horizontal split) is also the which-key "Git Hunk" group; `<leader>d`
   (diagnostic float) overlaps with `<leader>dc`/`<leader>dm`; `<leader>t` is labeled "Toggle" but also holds tab
   commands. Overlapping keys fire after a 300 ms pause instead of instantly.
7. **`<Tab>` differs by mode** — in normal mode it's "next buffer", in insert mode it's "accept Copilot".
