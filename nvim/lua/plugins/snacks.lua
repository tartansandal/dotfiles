-- Configure Snacks: picker, lazygit, indent (scope disabled)
-- Explorer disabled in favor of neo-tree
return {
  {
    "snacks.nvim",
    opts = {
      lazygit = { enabled = true },
      indent = { enabled = true, scope = { enabled = false } },
      image = {
        enabled = true,
        -- Snacks replaces list-valued options wholesale rather than merging
        -- them (`config.merge` in snacks/init.lua assigns when the incoming
        -- value is a list), so the defaults have to be restated to add one
        -- format. Only `svg` is new here -- it lets draw.io's editable-SVG
        -- exports render inline, and it is what makes the obsidian attachment
        -- picker emit `![[...]]` for them.
        formats = {
          "png",
          "jpg",
          "jpeg",
          "gif",
          "bmp",
          "webp",
          "tiff",
          "heic",
          "avif",
          "mp4",
          "mov",
          "avi",
          "mkv",
          "webm",
          "pdf",
          "icns",
          "svg",
        },
      },
      styles = {
        -- terminal = { keys = { term_normal = false } },
        lazygit = { keys = { term_normal = false } },
      },
      explorer = { enabled = false },
      bigfile = { enabled = true },
      picker = {
        enabled = true,
        matcher = {
          frequency = true, -- frecency bonus
          history_bonus = true, -- give more weight to chronological order
        },
        actions = {
          copy_notification = function(_, item)
            -- grab the message text, with fallbacks for field naming
            local text = item.msg or item.text or (item.notif and item.notif.msg) or ""
            vim.fn.setreg("+", text)
            vim.notify("Copied notification to clipboard")
          end,
        },
        sources = {
          -- <c-y> copies the highlighted notification (no default copy action)
          notifications = {
            win = {
              input = {
                keys = {
                  ["<c-y>"] = { "copy_notification", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
  },
}
