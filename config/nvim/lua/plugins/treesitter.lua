return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {"bash", "bibtex", "c", "css", "csv", "diff", "dockerfile", "jinja", "json", "latex",
                                "lua", "markdown", "python", "sql", "ssh_config", "toml", "tsx", "typescript", "vim",
                                "vimdoc", "yaml","elixir", "javascript", "html", "python", "typescript"},
            sync_install = false,
            highlight = {
                enable = true
            },
            indent = {
                enable = true
            }
        })
    end
}
