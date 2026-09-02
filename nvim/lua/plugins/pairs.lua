-- LazyVim expands the third backtick on a line into a whole fenced block (see
-- `M.pairs` in lazyvim/util/mini.lua). Its guard is "the line starts with at
-- least two backticks", so a *fourth* backtick matches it too and expands a
-- second block into the fence being typed. Four is what the outer fence of a
-- ````markdown cbX draft needs when it wraps ``` code blocks -- see
-- after/ftplugin/markdown.lua -- so make a backtick following a run of three
-- literal instead, leaving the three-backtick expansion alone.
return {
  {
    "nvim-mini/mini.pairs",
    config = function(_, opts)
      LazyVim.mini.pairs(opts)
      -- Wrapped after LazyVim's own wrapper so this check runs ahead of its
      -- markdown branch rather than behind it.
      local mini_pairs = require("mini.pairs")
      local open = mini_pairs.open
      mini_pairs.open = function(pair, neigh_pattern)
        -- getcmdline() is how LazyVim spots the command line, where the window
        -- cursor says nothing about what is being typed.
        if
          vim.fn.getcmdline() == ""
          and pair:sub(1, 1) == "`"
          and vim.bo.filetype == "markdown"
        then
          local col = vim.api.nvim_win_get_cursor(0)[2]
          if vim.api.nvim_get_current_line():sub(1, col):match("```$") then
            return "`"
          end
        end
        return open(pair, neigh_pattern)
      end
    end,
  },
}
