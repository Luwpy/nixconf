return {
    "git-dev.nvim",
    cmd = {
        "GitDevClean",
        "GitDevCleanAll",
        "GitDevCloseBuffers",
        "GitDevHistory",
        "GitDevOpen",
        "GitDevPersist",
        "GitDevToggleUI",
        "GitDevXDGHandle",
    },
    after = function()
        require("git-dev").setup({})
    end,
    keys = {
        {
            "gro",
            function()
                local repo = vim.fn.input "Repository name / URI: "
                if repo ~= "" then
                    require("git-dev").open(repo)
                end
            end,
            desc = "Open a remote git repository",
        },
        {
            "grc",
            function()
                require("git-dev").close_buffers()
            end,
            desc = "Close buffers of current repository",
        },
        {
            "grC",
            function()
                require("git-dev").clean()
            end,
            desc = "Clean current repository",
        },
    },
}
