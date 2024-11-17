local ls = require('luasnip')  -- LuaSnip module

-- Define your custom Markdown snippets
ls.snippets = {
  markdown = {
    -- Snippet for a Markdown header
    ls.parser.parse_snippet("h1", "# ${1:Header}\n\n${0}"),
    -- Snippet for a Markdown link
    ls.parser.parse_snippet("link", "[${1:link text}](https://example.com)"),
    -- Snippet for a code block
    ls.parser.parse_snippet("code", "``` ${1:language}\n${2:code}\n```"),
  }
}

