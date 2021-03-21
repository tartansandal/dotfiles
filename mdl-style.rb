# See https://github.com/markdownlint/markdownlint/blob/master/docs/RULES.md
#
# include all rules by default
all

# include a specific rule:
#
#   rule 'MD001'

# exclude_rule - exclude a previously included rule:
#
#   exclude_rule 'MD000'

# include all rules that are tagged with a specific value:
#
#   tag :whitespace

# exclude all rules tagged with the specified tag:
#
#   exclude_tag :line_length

# include a rule but set options:
#
#   rule 'MD030', :ol_multi => 2, :ul_multi => 3

# GitHub Pages
exclude_rule 'first-header-h1'
exclude_rule 'first-line-h1'
rule 'ul-indent', :indent => 2
rule 'ol-prefix', :style => ':ordered'
exclude_rule 'code-block-style'

# Need tabs for Makefile snippets
exclude_rule 'no-hard-tabs'

# Need angle brackets for keymaps
exclude_rule 'no-inline-html'

# I like to alternate prefixes for contrast
exclude_rule 'ul-style'

# GitLab and others don't like hard breaks
exclude_rule 'line-length'

# I use duplicated headings in my DIARY but nested differently
exclude_rule 'no-duplicate-header'
