"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"==> General setting
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a
set tabstop=4
set shiftwidth=4
set listchars=tab:\¦\ 		
set list
set foldmethod=indent
set foldlevelstart=99
set number 
set ignorecase

let mapleader = " "
" Disable backup
set nobackup
set nowb
set noswapfile

syntax on

" Enable copying from vim to clipboard
if has('win32')
	set clipboard=unnamed
else
	set clipboard=unnamedplus
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==> Plugin List
" Vim Plug
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin(stdpath('config'). '/plugged')
"Theme 
	Plug 'folke/tokyonight.nvim', { 'branch': 'main'}
" File browser
	Plug 'preservim/nerdTree' 						" File browser  
	Plug 'Xuyuanp/nerdtree-git-plugin' 				" Git status
	Plug 'ryanoasis/vim-devicons' 					" Icon
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plug 'unkiwii/vim-nerdtree-sync' 				" Sync current file 
"status line
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons' "icon
	Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*'}

" File search
	Plug 'junegunn/fzf', 
		\ { 'do': { -> fzf#install() } } 			" Fuzzy finder 
	Plug 'junegunn/fzf.vim'
" Terminal
	Plug 'akinsho/toggleterm.nvim', {'tag' : 'v2.*'}

" Code intellisense
	Plug 'neoclide/coc.nvim', {'branch': 'release'} " Language server 
	Plug 'jiangmiao/auto-pairs' 					" Parenthesis auto 
	Plug 'alvan/vim-closetag'
	Plug 'mattn/emmet-vim' 
	Plug 'preservim/nerdcommenter' 					" Comment code 
	Plug 'liuchengxu/vista.vim' 					" Function tag bar 
	Plug 'alvan/vim-closetag' 						" Auto close HTML/XML tag 

" Code syntax highlight
	Plug 'yuezk/vim-js' 							" Javascript
	Plug 'MaxMEllon/vim-jsx-pretty' 				" JSX/React
	Plug 'jackguo380/vim-lsp-cxx-highlight'			" C++ syntax
	Plug 'uiiaoo/java-syntax.vim' 					" Java
  
" Debugging
	Plug 'puremourning/vimspector' 					" Vimspector

" Source code version control 
	Plug 'tpope/vim-fugitive' 						" Git

" Notify
	Plug 'rcarriga/nvim-notify'



call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==> Plugin Setting
"
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
"Setting Theme 
let g:tokyonight_style = "night"
" Set theme
colorscheme tokyonight

" Disable automatic comment in newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Other setting 
for setting_file in split(glob(stdpath('config').'/settings/*.vim'))
	execute 'source' setting_file
endfor

"Status Line Setting
lua << END
local colors = require("tokyonight.colors").setup()

local config = {
    options = {
        -- Disable sections and component separators
        component_separators = '',
        section_separators = '',
        theme = {
            normal = {
                a = { fg = colors.fg, bg = colors.bg },
                x = { fg = colors.fg, bg = colors.bg },
            },
            inactive = {
                a = { fg = colors.fg, bg = colors.bg },
                x = { fg = colors.fg, bg = colors.bg },
            },
        },
        ignore_focus = {
            'NvimTree',
            'packer',
            'toggleterm',
            'dapui_scopes',
            'dapui_stacks',
            'dapui_breakpoints',
            'dapui_watches',
            'dap-repl',
        },
    },
    sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
}

local function ins_left(component)
    table.insert(config.sections.lualine_a, component)
end

local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
end

-- Focus
ins_left {
    function()
        return '▊'
    end,
    color = { fg = colors.blue },
    padding = { right = 1 },
}

ins_left {
  -- mode component
  function()
    return ''
  end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
}

ins_left {
    'filename',
    color = { fg = colors.magenta, gui = 'bold' },
}

ins_left {
    'filesize',
}

ins_left {
    'diagnostics',
    sources = { 'nvim_lsp' },
    sections = { 'error', 'warn', 'info', 'hint' },
    diagnostics_color = {
        error = { fg = colors.red },
        warn  = { fg = colors.yellow },
        info  = { fg = colors.cyan },
        hint  = { fg = colors.green },
    },
    symbols = { error = ' ', warn = ' ', info = ' ', hint = ' '},
}

ins_left {
    function()
        return '%='
    end,
}

ins_left {
  -- Lsp server name .
    function()
        local msg = 'No Active Lsp'
        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end,
    icon = ' LSP:',
    color = { fg = colors.fg, gui = 'bold' },
}

ins_right {
    'branch',
    icon = '',
    color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
    'diff',
    diff_color = {
        added    = { fg = colors.green },
        modified = { fg = colors.orange },
        removed  = { fg = colors.red },
    },
    symbols = { added = ' ', modified = '柳', removed = ' ' },
}

ins_right {
    'fileformat',
    color = { fg = colors.fg },
}

ins_right {
    'filetype',
}

ins_right {
    'progress',
    color = { fg = colors.fg, gui = 'bold' },
}

ins_right {
    'location',
    color = { fg = colors.fg, gui = 'bold' },
}

ins_right {
  function()
    return '▊'
  end,
  color = { fg = colors.blue },
  padding = { left = 1 },
}

require('lualine').setup(config)
END

"BufferLine
set termguicolors
lua <<EOF
require("bufferline").setup()
EOF

"buffers :bnext and :bprevious
"keymap('n', '<A-.>', ':BufferLineCycleNext<CR>', opts)
nmap <A-.> :BufferLineCycleNext<CR>
"keymap('n', '<A-,>', ':BufferLineCyclePrev<CR>', opts)
nmap <A-,> :BufferLineCycleNext<CR>

" move the current buffer backwards or forwards
"keymap('n', '<A->>', ':BufferLineMoveNext<CR>', opts)
nmap <A->> :BufferLineMoveNext<CR>
"keymap('n', '<A-<>', ':BufferLineMovePrev<CR>', opts)
nmap <A-<> :BufferLineMoveNext<CR>

" close buffer
"keymap('n', '<A-c>', ':BufferLinePickClose<CR>', opts)
nmap <A-c> :BufferLinePickClose<CR>

""Terminal
"Toggle terminal
lua <<EOF
require('toggleterm').setup {
    open_mapping = '<C-t>',
    -- Transparent terminal
    highlights = {
        Normal = {
            link = 'Normal',
        },
        NormalFloat = {
            link = 'NormalFloat',
        },
        FloatBorder = {
            link = 'FloatBorder',
        },
    },
    start_in_insert = false,
}
EOF

"Disable signcolumn & cursorline terminal
autocmd TermOpen * setlocal signcolumn=no
autocmd TermOpen * setlocal nocursorline

"keymap('n', '<leader>tb', ':ToggleTerm direction=horizontal<CR>', opts)
nmap <leader>tb :ToggleTerm direction=horizontal<CR>
"keymap('n', '<leader>tf', ':ToggleTerm direction=float<CR>', opts)
nmap <leader>tf :ToggleTerm direction=float<CR>


"Fullscreen 
function Neovide_fullscreen()
	if g:neovide_fullscreen==v:true
		let g:neovide_fullscreen=v:false
	else 
		let g:neovide_fullscreen=v:true
	endif
endfunction
nmap <F11> :call Neovide_fullscreen()<cr>

""""""Vietnamese
set keymap=vietnamese-telex

