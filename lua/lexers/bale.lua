-- Copyright 2018 Murray Calavera. See LICENSE.
-- LPeg lexer for bale schemas.

local l = require('lexer')
local token = l.token
local P, S = lpeg.P, lpeg.S

local function words(w)
  return l.word_match(w, ".-<>?!")
end

local ws = token(l.WHITESPACE, l.space^1)

local comment_pre = (P(1) - S'\n:')^0 * ':'
local comment_post = ';' * l.nonnewline^0
local comment = token(l.COMMENT, comment_pre + comment_post)

local include = token(l.PREPROCESSOR, words{'include'})

local str = token(l.STRING, l.delimited_range('"', true, true))

local keyword = token(l.KEYWORD, words{'tuple', 'union', 'array', 'let', 'be', 'end'})

local word = token(l.IDENTIFIER, (l.alnum + S'._-<>?!')^1)

local M = { _NAME = 'bale' }

M._rules = {
  {'whitespace', ws},
  {'comment', comment},
  {'include', include},
  {'string', str},
  {'keyword', keyword},
  {'word', word},
}

return M
