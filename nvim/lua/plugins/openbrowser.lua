-- Use open-browser for 'gx' to open URLs (netrw disabled)
return {
  {
    "tyru/open-browser.vim",
    keys = {
      {
        "gx",
        "<Plug>(openbrowser-open)",
        mode = { "n", "v" },
        desc = "Open URL under cursor",
      },
    },
  },
}
