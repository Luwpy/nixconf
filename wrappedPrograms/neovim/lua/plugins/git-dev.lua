return {
    "moyiz/git-dev.nvim",
    lazy = true,
    cmd = {
        "GitDevOpen",
        "GitDevCloseBuffers",
        "GitDevClean",
        "GitDevCleanAll",
        "GitDevPersist",
        "GitDevHistory",
        "GitDevToggleUI",
    },
    after = function()
        require("git-dev").setup({
            ephemeral = true,
            read_only = true,
            cd_type = "tab",
            opener = function(dir, _, selected_path)
                require("mini.files").open(dir, false)
                if selected_path then
                    vim.cmd("edit " .. selected_path)
                end
            end,
            git = {
                clone_args = "--jobs=2 --single-branch --recurse-submodules --shallow-submodules --progress",
                fetch_args = "--jobs=2 --no-all --update-shallow -f --prune --no-tags",
                checkout_args = "-f --recurse-submodules",
            },
            ui = {
                enabled = true,
                auto_close = true,
                close_after_ms = 3000,
                mode = "floating",
            },
            history = {
                n = 32,
            },
            clean = {
                close_buffers = true,
                delete_repo_dir = "current",
            },
            pickers = {
                type = "snacks",
            },
        })
    end,
    keys = {
        {
            "<leader>gdo",
            function()
                local repo = vim.fn.input("Repository: ")
                if repo ~= "" then
                    require("git-dev").open(repo)
                end
            end,
            desc = "Open remote git repository",
        },
        {
            "<leader>gdc",
            function() require("git-dev").close_buffers() end,
            desc = "Close git-dev buffers",
        },
        {
            "<leader>gdC",
            function() require("git-dev").clean() end,
            desc = "Clean git-dev repository",
        },
        {
            "<leader>gdH",
            function() require("git-dev").pickers.history() end,
            desc = "Git-dev history",
        },
        {
            "<leader>gdp",
            function() require("git-dev").persist() end,
            desc = "Persist git-dev repository",
        },
    },
}
