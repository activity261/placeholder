-- Core Neovim settings
do
        -- Enable faster startup by caching compiled Lua modules
        vim.loader.enable()

        -- disable space in normal mode and use as leader
        vim.g.mapleader = " "
        vim.g.maplocalleader = " "

        -- using nerd font
        vim.g.have_nerd_font = true

        -- don't inherit colors from terminal
        vim.o.termguicolors = false

        -- enable line number + relative line number
        vim.o.number = true
        vim.o.relativenumber = true

        -- set tab size to 4 width and shift amount to 4 width
        vim.o.tabstop = 4
        vim.o.shiftwidth = 4

        -- Sync clipboard between OS and Neovim.
        vim.schedule(function()
                vim.o.clipboard = "unnamedplus"
        end)

        vim.o.breakindent = true

        -- use undo even after leaving buffer
        vim.o.undofile = true

        vim.o.ignorecase = true
        vim.o.smartcase = true

        -- show signs on number column
        vim.o.signcolumn = "yes"

        -- Decrease update time
        vim.o.updatetime = 250

        -- Decrease mapped sequence wait time
        vim.o.timeoutlen = 300

        vim.o.list = true
        vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

        -- Preview substitutions live, as you type!
        vim.o.inccommand = "split"

        -- Show which line your cursor is on
        vim.o.cursorline = true

        -- Minimal number of screen lines to keep above and below the cursor.
        vim.o.scrolloff = 10

        -- confirm dialog
        vim.o.confirm = true
end

-- vim.pack
do
        -- Install Packages
        vim.pack.add({
                "https://github.com/navarasu/onedark.nvim.git",
                "https://github.com/cocopon/iceberg.vim.git",
                "https://github.com/nvim-mini/mini.icons.git",
                "https://github.com/nvim-tree/nvim-web-devicons.git",
                "https://github.com/nvim-lualine/lualine.nvim",
                "https://github.com/nvim-mini/mini.pairs.git",
                "https://github.com/nvim-mini/mini.comment",
                "https://github.com/NMAC427/guess-indent.nvim.git",
                "https://github.com/lewis6991/gitsigns.nvim.git",
                "https://github.com/folke/todo-comments.nvim.git",
                "https://github.com/stevearc/conform.nvim.git",
                {
                        src = "https://github.com/saghen/blink.cmp.git",
                        version = "1.*",
                },
                "https://github.com/j-morano/buffer_manager.nvim.git",
                "https://github.com/stevearc/oil.nvim",
                "https://github.com/nvim-lua/plenary.nvim",
                "https://github.com/nvim-telescope/telescope.nvim.git",
                "https://github.com/kdheepak/lazygit.nvim",
                "https://github.com/folke/which-key.nvim.git",
                {
                        src = "https://github.com/nvim-treesitter/nvim-treesitter.git",
                        lazy = false,
                        build = ":TSUpdate",
                },
                "https://github.com/seblyng/roslyn.nvim.git",
                "https://github.com/ionide/Ionide-vim.git",
        })

        -- Setup Packages
        require("onedark").setup({
                style = "dark",
        })
        require("onedark").load()
        require("lualine").setup({
                options = {
                        -- Disable angled separators
                        component_separators = "",
                        section_separators = "",
                },
        })
        require("mini.pairs").setup()
        require("mini.comment").setup()
        require("guess-indent").setup({})
        require("gitsigns").setup()
        require("todo-comments").setup()
        require("conform").setup({
                formatters_by_ft = {
                        lua = { "stylua" },
                        python = { "ruff_organize_imports", "ruff_format" },
                        rust = { "rustfmt" },
                        javascript = { "oxfmt", "oxlint" },
                        javascriptreact = { "oxfmt", "oxlint" },
                        typescript = { "oxfmt", "oxlint" },
                        typescriptreact = { "oxfmt", "oxlint" },
                        csharp = { "csharpier" },
                        go = { "gofmt" },
                        sql = { "sqlfluff" },
                        pgsql = { "sqlfluff" },
                        sqlite3 = { "sqlfluff" },
                        sh = { "shfmt" },
                },
                formatters = {
                        sqlfluff = {
                                command = "sqlfluff",
                                args = { "format", "--dialect=postgres", "-" },
                                stdin = true,
                                cwd = function()
                                        return vim.fn.getcwd()
                                end,
                        },
                },
                format_on_save = {
                        -- These options will be passed to conform.format()
                        timeout_ms = 500,
                        lsp_format = "fallback",
                },
        })
        require("blink.cmp").setup({
                keymap = { preset = "super-tab" },
        })
        require("buffer_manager").setup({})
        require("oil").setup({
                view_options = {
                        show_hidden = true,
                },
                keymaps = {
                        ["q"] = { "actions.close", mode = "n" },
                },
                float = {
                        -- Padding around the floating window
                        padding = 2,
                        -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                        max_width = math.floor(vim.o.columns * 0.5),
                        max_height = math.floor(vim.o.lines * 0.5),
                        border = "rounded",
                        win_options = {
                                winblend = 0,
                        },
                        -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
                        get_win_title = nil,
                        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
                        preview_split = "auto",
                        -- This is the config that will be passed to nvim_open_win.
                        -- Change values here to customize the layout
                        override = function(conf)
                                return conf
                        end,
                },
        })
        require("telescope").setup()
        require("which-key").setup({
                delay = 0,
                icons = { mappings = vim.g.have_nerd_font },
                preset = "modern",
                triggers = {
                        --{ "<auto>", mode = "nixsotc" },
                        { "<leader>", mode = { "n", "v" } },
                },
        })
        require("nvim-treesitter").install({
                "lua",
                "javascript",
                "typescript",
                "c_sharp",
                "python",
                "go",
                "rust",
                "fsharp",
        })
end

-- Keymaps
do
        local map = vim.keymap.set

        -- General keymaps
        map("n", "<Esc>", "<cmd>nohlsearch<CR>")

        -- Buffer
        local bmui = require("buffer_manager.ui")
        map({ "t", "n" }, "<leader>bm", bmui.toggle_quick_menu, { desc = "[b]uffer [m]anager", noremap = true })
        map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "[b]uffer [d]elete" })

        -- Oil
        map("n", "<leader>fd", "<cmd>Oil --float<CR>", { desc = "[f]ind [d]irectory" })

        -- Telescope builtins
        local builtin = require("telescope.builtin")
        map("n", "<leader>fb", builtin.buffers, { desc = "[f]ind [b]uffers" })
        map("n", "<leader>ff", builtin.find_files, { desc = "[f]ind [f]iles" })
        map("n", "<leader>fg", builtin.git_files, { desc = "[f]ind [g]it files" })
        map("n", "<leader>fp", builtin.live_grep, { desc = "[f]ind ripgre[p]" })
        map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "[f]ind [t]odo" })
        map("n", "<leader>fw", builtin.lsp_workspace_symbols, { desc = "[f]ind [w]orkspace symbols" })
        map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "[f]ind document [s]ymbols" })
        map("n", "<leader>fr", builtin.lsp_references, { desc = "[f]ind [r]eferences" })

        -- Go To
        map("n", "<leader>gd", builtin.lsp_definitions, { desc = "[g]o to [d]efinitions" })
        map("n", "<leader>gt", builtin.lsp_type_definitions, { desc = "[g]o to [t]ype definitions" })
        map("n", "<leader>gi", builtin.lsp_implementations, { desc = "[g]o to [i]mplementations" })

        -- Code
        local buf = require("vim.lsp.buf")
        map("n", "<leader>ca", buf.code_action, { desc = "[c]ode [a]ction" })
        map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "[c]ode [d]iagnostic" })
        map("n", "<leader>cf", buf.format, { desc = "[c]ode [f]ormat" })
        map("n", "<leader>ch", function()
                buf.hover({ border = "rounded" })
        end, { desc = "[c]ode [h]over tooltips" })
        map("n", "<leader>ci", function()
                local current = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
                vim.lsp.inlay_hint.enable(not current, { bufnr = 0 })
        end, { desc = "[code] [i]nlay hints" })
        map("n", "<leader>cl", function()
                local codelens = vim.lsp.codelens
                codelens.enable(not codelens.is_enabled())
                if codelens.is_enabled() then
                        print("codelens activated")
                else
                        print("codelens deactivated")
                end
                vim.defer_fn(function()
                        -- Clear the current message by echoing a space or empty string
                        -- The 'silent' flag prevents the clear action from being logged
                        vim.api.nvim_echo({ { " ", "None" } }, false, {})
                end, 1000)
        end, { desc = "[c]ode[l]ens toggle" })
        map("n", "<leader>cr", buf.rename, { desc = "[c]ode [r]ename" })

        -- Misc
        map("n", "<leader>l", "<cmd>LazyGit<CR>", { desc = "lazygit" })
        map("n", "<leader>j", function()
                local width = math.floor(vim.o.columns * 0.8)
                local height = math.floor(vim.o.lines * 0.8)

                local create_buf = vim.api.nvim_create_buf(false, true)

                local win = vim.api.nvim_open_win(create_buf, true, {
                        relative = "editor",
                        width = width,
                        height = height,
                        col = math.floor((vim.o.columns - width) / 2),
                        row = math.floor((vim.o.lines - height) / 2),
                        style = "minimal",
                        border = "rounded",
                })
                vim.fn.jobstart("jjui", {
                        term = true,
                        on_exit = function()
                                vim.schedule(function()
                                        if vim.api.nvim_win_is_valid(win) then
                                                vim.api.nvim_win_close(win, true)
                                        end

                                        if vim.api.nvim_buf_is_valid(create_buf) then
                                                vim.api.nvim_buf_delete(create_buf, { force = true })
                                        end
                                end)
                        end,
                })
                vim.cmd("startinsert")
        end, { desc = "jjui" })

        -- WhichKey Groups
        local wk = require("which-key")
        wk.add({
                { "<leader>b", group = "buffers" },
                { "<leader>f", group = "find" },
                { "<leader>g", group = "go to" },
                { "<leader>c", group = "code" },
        })
end

-- Treesitter
do
        vim.api.nvim_create_autocmd("FileType", {
                pattern = { "<filetype>" },
                callback = function()
                        vim.treesitter.start()
                end,
        })
end

-- Snippets
do
end

-- LSP
do
        local lsp = vim.lsp

        -- Lua
        lsp.config["emmylua_ls"] = {
                -- Command and arguments to start the server.
                cmd = { "emmylua_ls" },
                -- Filetypes to automatically attach to.
                filetypes = { "lua" },
                -- Sets the workspace "root" to the directory where any of these files is found.
                -- Files sharing a root will reuse the LSP client/connection.
                -- Nested lists indicate equal priority, see |vim.lsp.Config|.
                root_markers = { { ".emmyrc.json", ".luarc.json" }, ".git" },
                -- Server-specific settings. https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/main/docs/config/emmyrc_json_EN.md
                settings = {
                        Lua = {
                                runtime = {
                                        version = "LuaJIT",
                                },
                                diagnostics = {
                                        -- Get the language server to recognize the `vim` global
                                        globals = { "vim" },
                                },
                                workspace = {
                                        -- Make the server aware of Neovim runtime files
                                        library = vim.api.nvim_get_runtime_file("", true),
                                },
                                -- Do not send telemetry data containing a randomized but unique identifier
                                telemetry = {
                                        enable = false,
                                },
                        },
                },
        }
        lsp.enable("emmylua_ls")

        -- Javascript/TypeScript
        lsp.config("vtsls", {
                cmd = { "vtsls", "--stdio" },
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                root_markers = { "package.json", ".git" },
        })
        lsp.enable("vtsls")

        -- C#
        lsp.config("roslyn", {
                settings = {
                        ["csharp|inlay_hints"] = {
                                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                        },
                        ["csharp|code_lens"] = {
                                dotnet_enable_references_code_lens = true,
                        },
                },
        })

        -- Python
        lsp.config("basedpyright", {
                cmd = { "basedpyright-langserver", "--stdio" },
                filetypes = { "python" },
                root_markers = { "pyproject.toml", ".git" },
                settings = {
                        basedpyright = {
                                -- Using Ruff's import organizer
                                disableOrganizeImports = true,
                        },
                        python = {
                                analysis = {
                                        -- Ignore all files for analysis to exclusively use Ruff for linting
                                        ignore = { "*" },
                                },
                        },
                },
        })
        lsp.enable("basedpyright")

        -- Go
        lsp.config("gopls", {
                cmd = { "gopls" },
                filetypes = { "go" },
                root_markers = { ".mod", ".git" },
        })
        lsp.enable("gopls")

        -- Rust
        lsp.config("rust-analyzer", {
                cmd = { "rust-analyzer" },
                filetypes = { "rust" },
                root_markers = { "Cargo.toml", ".git" },
                settings = {
                        ["rust-analyzer"] = {
                                imports = {
                                        granularity = {
                                                group = "module",
                                        },
                                        prefix = "self",
                                },
                                cargo = {
                                        buildScripts = {
                                                enable = true,
                                        },
                                },
                                procMacro = {
                                        enable = true,
                                },
                        },
                },
        })
        lsp.enable("rust-analyzer")
end
