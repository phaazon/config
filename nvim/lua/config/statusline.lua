-- The statusline requires some plugins to be installed:
--
-- - tpope/fugitive
-- - airblade/vim-gitgutter
-- - neovim/nvim-lspconfig
-- - kyazdani42/nvim-web-devicons
local M = {}

function M.create_highlights()
  vim.api.nvim_exec([[
    hi StatusLineBg guibg=#23272e guifg=#efefef
    hi StatusLineBg2 guibg=#23272e guifg=#efefef
    hi StatusLineBg2b guibg=#23272e guifg=#5B6268
    hi StatusLineBg2c guibg=#5B6268 guifg=#23272e

    hi StatusLineLinNbr guibg=#23272e guifg=#51afef
    hi StatusLineColNbr guibg=#23272e guifg=#98be65

    hi StatusLineGitBranchSymbol guibg=#23272e guifg=#ff6c6b
    hi StatusLineGitBranchName guibg=#23272e guifg=#da8548
    hi StatusLineGitDiffNone guibg=#23272e guifg=#98be65
    hi StatusLineGitDiffAdd guibg=#23272e guifg=#98be65
    hi StatusLineGitDiffMod guibg=#23272e guifg=#51afef
    hi StatusLineGitDiffDel guibg=#23272e guifg=#ff6c6b

    hi StatusLineLSPOk guibg=#23272e guifg=#98be65
    hi StatusLineLSPErrors guibg=#23272e guifg=#ff6c6b
    hi StatusLineLSPWarnings guibg=#23272e guifg=#ECBE7B
    hi StatusLineLSPInfo guibg=#23272e guifg=#51afef
    hi StatusLineLSPHints guibg=#23272e guifg=#c678dd

    hi StatusLineCurrentSymbolName guibg=#23272e guifg=#c678dd
    hi StatusLineCurrentSymbolType guibg=#23272e guifg=#98be65 gui=italic
    hi StatusLineCurrentSymbolBracket guibg=#23272e guifg=#5B6268 gui=italic

    hi StatusLineNormalMode guibg=#51afef guifg=#23272e
    hi StatusLineNormalModeItalic guibg=#51afef guifg=#23272e gui=italic
    hi StatusLineNormalModeWinNr guibg=#316a91 guifg=#23272e

    hi StatusLineInsertMode guibg=#98be65 guifg=#23272e
    hi StatusLineInsertModeItalic guibg=#98be65 guifg=#23272e gui=italic
    hi StatusLineInsertModeWinNr guibg=#62803b guifg=#23272e

    hi StatusLineReplaceMode guibg=#ff6c6b guifg=#23272e
    hi StatusLineReplaceModeItalic guibg=#ff6c6b guifg=#23272e
    hi StatusLineReplaceModeWinNr guibg=#b64a49 guifg=#23272e

    hi StatusLineVisualMode guibg=#46D9FF guifg=#23272e
    hi StatusLineVisualModeItalic guibg=#46D9FF guifg=#23272e gui=italic
    hi StatusLineVisualModeWinNr guibg=#37a2be guifg=#23272e

    hi StatusLineVisualBlockMode guibg=#46D9FF guifg=#23272e
    hi StatusLineVisualBlockModeItalic guibg=#46D9FF guifg=#23272e gui=italic
    hi StatusLineVisualBlockModeWinNr guibg=#37a2be guifg=#23272e

    hi StatusLineVisualLineMode guibg=#46D9FF guifg=#23272e
    hi StatusLineVisualLineModeItalic guibg=#46D9FF guifg=#23272e gui=italic
    hi StatusLineVisualLineModeWinNr guibg=#37a2be guifg=#23272e

    hi StatusLineSelectMode guibg=#46D9FF guifg=#23272e
    hi StatusLineSelectModeItalic guibg=#46D9FF guifg=#23272e gui=italic
    hi StatusLineSelectModeWinNr guibg=#37a2be guifg=#23272e

    hi StatusLineSelectLineMode guibg=#46D9FF guifg=#23272e
    hi StatusLineSelectLineModeItalic guibg=#46D9FF guifg=#23272e gui=italic
    hi StatusLineSelectLineModeWinNr guibg=#37a2be guifg=#23272e

    hi StatusLineSelectBlockMode guibg=#46D9FF guifg=#23272e
    hi StatusLineSelectBlockModeItalic guibg=#46D9FF guifg=#23272e gui=italic
    hi StatusLineSelectBlockModeWinNr guibg=#37a2be guifg=#23272e

    hi StatusLineCommandMode guibg=#5B6268 guifg=#23272e
    hi StatusLineCommandModeItalic guibg=#5B6268 guifg=#23272e gui=italic
    hi StatusLineCommandModeWinNr guibg=#42474b guifg=#23272e

    hi StatusLineHitEnterPromptMode guibg=#ff6c6b guifg=#23272e
    hi StatusLineHitEnterPromptModeItalic guibg=#ff6c6b guifg=#23272e gui=italic
    hi StatusLineHitEnterPromptModeWinNr guibg=#b64a49 guifg=#23272e
  ]], false)
end

vim.api.nvim_command('augroup phaazon')
vim.api.nvim_command('  au!')
vim.api.nvim_command([[  au ColorScheme * lua require'config.statusline'.create_highlights()]])
vim.api.nvim_command('augroup END')

local function vcs_status()
  local branch = vim.fn['fugitive#head']()

  if #branch == 0 then
    return ''
  end

  local summary = vim.fn['GitGutterGetHunkSummary']()
  local ahl, mhl, rhl

  if summary[1] > 0 then
    ahl = '%#StatusLineGitDiffAdd#'
  else
    ahl = '%#StatusLineBg2b#'
  end

  if summary[2] > 0 then
    mhl = '%#StatusLineGitDiffMod#'
  else
    mhl = '%#StatusLineBg2b#'
  end

  if summary[3] > 0 then
    rhl = '%#StatusLineGitDiffDel#'
  else
    rhl = '%#StatusLineBg2b#'
  end

  return string.format('%s %i %s %i %s %i %%#StatusLineGitBranchSymbol# %%#StatusLineGitBranchName#%s',
    ahl,
    summary[1],
    mhl,
    summary[2],
    rhl,
    summary[3],
   branch:gsub('%s+', '')
  )
end

local function lsp_status()
  if #vim.lsp.buf_get_clients() > 0 then
    return require('lsp-status').status()
  end

  return ''
end

local function get_file_name()
  local max_width = vim.fn.winwidth(vim.g.statusline_winid) * 0.25
  local file_name = vim.fn.fnamemodify(vim.fn.bufname(vim.fn.winbufnr(vim.g.statusline_winid)), ':.')
  local width = vim.fn.strwidth(file_name)

  if width == 0 then
    file_name = '[scratch]'
  else
    -- If the file name is too big, we just write its tail part
    if width > max_width then
      file_name = vim.fn.fnamemodify(file_name, ':t')
    end

    local devicons = require'nvim-web-devicons'
    if devicons ~= nil then
      local ext = vim.fn.fnamemodify(file_name, ':e')
      local icon = devicons.get_icon(file_name, ext)

      if icon ~= nil then
        file_name = string.format('%s %s', icon, file_name)
      end
    end
  end

  return file_name
end

local function make_active_status_line()
  local hls = {
    n = {
      n = 'StatusLineNormalMode',
      i = 'StatusLineNormalModeItalic',
      nr = 'StatusLineNormalModeWinNr',
    },
    no = {
      n = 'StatusLineReplaceMode',
      i = 'StatusLineReplaceModeItalic',
      nr = 'StatusLineReplaceModeWinNr',
    },
    nov = {
      n = 'StatusLineReplaceMode',
      i = 'StatusLineReplaceModeItalic',
      nr = 'StatusLineReplaceModeWinNr',
    },
    ['noV'] = {
      n = 'StatusLineReplaceMode',
      i = 'StatusLineReplaceModeItalic',
      nr = 'StatusLineReplaceModeWinNr',
    },
    ['no'] = {
      n = 'StatusLineReplaceMode',
      i = 'StatusLineReplaceModeItalic',
      nr = 'StatusLineReplaceModeWinNr',
    },
    i = {
      n = 'StatusLineInsertMode',
      i = 'StatusLineInsertModeItalic',
      nr = 'StatusLineInsertModeWinNr',
    },
    ic = {
      n = 'StatusLineInsertMode',
      i = 'StatusLineInsertModeItalic',
      nr = 'StatusLineInsertModeWinNr',
    },
    ix = {
      n = 'StatusLineInsertMode',
      i = 'StatusLineInsertModeItalic',
      nr = 'StatusLineInsertModeWinNr',
    },
    ['niI'] = {
      n = 'StatusLineInsertMode',
      i = 'StatusLineInsertModeItalic',
      nr = 'StatusLineInsertModeWinNr',
    },
    v = {
      n = 'StatusLineVisualMode',
      i = 'StatusLineVisualModeItalic',
      nr = 'StatusLineVisualModeWinNr',
    },
    V = {
      n = 'StatusLineVisualLineMode',
      i = 'StatusLineVisualLineModeItalic',
      nr = 'StatusLineVisualLineModeWinNr',
    },
    [''] = {
      n = 'StatusLineVisualBlockMode',
      i = 'StatusLineVisualBlockModeItalic',
      nr = 'StatusLineVisualBlockModeWinNr',
    },
    ['niV'] = {
      n = 'StatusLineVisualMode',
      i = 'StatusLineVisualModeItalic',
      nr = 'StatusLineVisualModeWinNr',
    },
    s = {
      n = 'StatusLineVisualMode',
      i = 'StatusLineVisualModeItalic',
      nr = 'StatusLineVisualModeWinNr',
    },
    S = {
      n = 'StatusLineVisualMode',
      i = 'StatusLineVisualModeItalic',
      nr = 'StatusLineVisualModeWinNr',
    },
    [''] = {
      n = 'StatusLineVisualMode',
      i = 'StatusLineVisualModeItalic',
      nr = 'StatusLineVisualModeWinNr',
    },
    R = {
      n = 'StatusLineReplaceMode',
      i = 'StatusLineReplaceModeItalic',
      nr = 'StatusLineReplaceModeWinNr',
    },
    Rc = {
      n = 'StatusLineReplaceMode',
      i = 'StatusLineReplaceModeItalic',
      nr = 'StatusLineReplaceModeWinNr',
    },
    Rv = {
      n = 'StatusLineReplaceMode',
      i = 'StatusLineReplaceModeItalic',
      nr = 'StatusLineReplaceModeWinNr',
    },
    Rx = {
      n = 'StatusLineReplaceMode',
      i = 'StatusLineReplaceModeItalic',
      nr = 'StatusLineReplaceModeWinNr',
    },
    ['niR'] = {
      n = 'StatusLineReplaceMode',
      i = 'StatusLineReplaceModeItalic',
      nr = 'StatusLineReplaceModeWinNr',
    },
    c = {
      n = 'StatusLineCommandMode',
      i = 'StatusLineCommandModeItalic',
      nr = 'StatusLineCommandModeWinNr',
    },
    cv = {
      n = 'StatusLineCommandMode',
      i = 'StatusLineCommandModeItalic',
      nr = 'StatusLineCommandModeWinNr',
    },
    ce = {
      n = 'StatusLineCommandMode',
      i = 'StatusLineCommandModeItalic',
      nr = 'StatusLineCommandModeWinNr',
    },
    r = {
      n = 'StatusLineHitEnterPromptMode',
      i = 'StatusLineHitEnterPromptModeItalic',
      nr = 'StatusLineHitEnterPromptModeWinNr',
    },
    rm = {
      n = 'StatusLineHitEnterPromptMode',
      i = 'StatusLineHitEnterPromptModeItalic',
      nr = 'StatusLineHitEnterPromptModeWinNr',
    },
    ['r?'] = {
      n = 'StatusLineHitEnterPromptMode',
      i = 'StatusLineHitEnterPromptModeItalic',
      nr = 'StatusLineHitEnterPromptModeWinNr',
    },
    ['!'] = {
      n = 'StatusLineHitEnterPromptMode',
      i = 'StatusLineHitEnterPromptModeItalic',
      nr = 'StatusLineHitEnterPromptModeWinNr',
    },
    t = {
      n = 'StatusLineReplaceMode',
      i = 'StatusLineReplaceModeItalic',
      nr = 'StatusLineReplaceModeWinNr',
    },
  }

  local hl = 'StatusLineBg'
  local hl2 = 'StatusLineBg2c'

  local mode = vim.fn.mode()
  if vim.fn.has_key(hls, mode) then
    if vim.bo.mod then
      hl = hls[mode]['i']
    else
      hl = hls[mode]['n']
    end

    hl2 = hls[mode]['nr']
  end

  local status_line = string.format('%%#%s# %d %%#%s# %s ',
    hl2,
    vim.fn.win_id2win(vim.g.statusline_winid),
    hl,
    get_file_name()
  )
  status_line = status_line .. '%#StatusLineLinNbr# %v%#StatusLineBg2b#:%#StatusLineColNbr#%l%< %#StatusLineBg2b#(%p%% %LL)'
  status_line = status_line .. string.format('%%=%%#StatusLineBg# %s %s ', lsp_status(), vcs_status())

  return status_line
end

local function make_inactive_status_line()
  local hl = 'StatusLineBg2c'
  local hlend = 'StatusLineBg'
  local status_line = string.format(' %d %%#%s# %s %%#%s#',
    vim.fn.win_id2win(vim.g.statusline_winid),
    hl,
    get_file_name(),
    hlend
  )

  return status_line
end

function M.make_status_line(active)
  if active then
    vim.wo.statusline = '%!v:lua.active_status_line()'
  else
    vim.wo.statusline = '%!v:lua.inactive_status_line()'
  end
end

local function create_au()
  vim.api.nvim_command("au BufEnter * lua require'config.statusline'.make_status_line(true)")
  vim.api.nvim_command("au BufLeave * lua require'config.statusline'.make_status_line(false)")
end

create_au()

M.make_status_line(true)
_G.active_status_line = make_active_status_line
_G.inactive_status_line = make_inactive_status_line

return M
