local api = vim.api

local buf, win
local terminal_open = false

local function create_terminal()
    buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(buf, 'buflisted', false)
    api.nvim_buf_set_option(buf, 'swapfile', false)
    api.nvim_buf_set_option(buf, 'modifiable', true)
end

local function open_terminal()
    if not buf then
        create_terminal()
    end

    local width = api.nvim_get_option("columns")
    local height = api.nvim_get_option("lines")
    local win_height = math.ceil(height * 0.8 - 4)
    local win_width = math.ceil(width * 0.8)
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "rounded"
    }

    win = api.nvim_open_win(buf, true, opts)
    api.nvim_win_set_option(win, 'winhl', 'Normal:Normal')
    api.nvim_win_set_option(win, 'winblend', 10)
    api.nvim_buf_set_option(buf, 'modified', false)

    -- Set the 'buflisted' option to false for the buffer
    api.nvim_buf_set_option(buf, 'buflisted', false)

    -- Create an autocommand to toggle the floating window when switching to a different window
    local cmd = string.format(
        [[autocmd WinEnter * ++nested if win_getid() != %d && nvim_win_is_valid(%d) | execute "FloatTerminalToggle" | endif]],
        win,
        win
    )
    vim.cmd(cmd)

    -- Set keymaps to close the terminal
    -- Only set the keymaps in the terminal buffer to avoid conflicts with other buffers
    opts = { noremap = true, silent = true }
    api.nvim_buf_set_keymap(buf, 't', '<esc>', '<C-\\><C-n><cmd>FloatTerminalToggle<cr>', opts)

    -- Open the terminal in the floating window's buffer
    if not terminal_open then
        vim.fn.termopen(vim.o.shell, {buffer = buf})
        terminal_open = true
    end

    vim.cmd('startinsert')
end

local function keep_cursor_in_window()
    if win and api.nvim_win_is_valid(win) then
        api.nvim_set_current_win(win)
    end
end

local function close_terminal()
    api.nvim_win_hide(win)
end

local function toggle_terminal()
    if win and api.nvim_win_is_valid(win) then
        if vim.fn.pumvisible() == 1 then
            vim.cmd('close')
        end
        api.nvim_win_hide(win)
    else
        if not buf then
            create_terminal()
        end
        open_terminal()
    end
end

local function delete_terminal()
    if buf and api.nvim_buf_is_valid(buf) then
        api.nvim_buf_delete(buf, {force = true})
        buf = nil
        win = nil
        terminal_open = false
        print('Deleted terminal')
    end
end

-- Define user commands
api.nvim_create_user_command('FloatTerminal', open_terminal, {})
api.nvim_create_user_command('FloatTerminalToggle', toggle_terminal, {})
api.nvim_create_user_command('FloatTerminalDelete', delete_terminal, {})

-- Define keymappings
local opts = { noremap = true, silent = true }
api.nvim_set_keymap('n', '<leader><leader>t', '<cmd>FloatTerminalToggle<cr>', opts)
api.nvim_set_keymap('n', '<leader><leader>d', '<cmd>FloatTerminalDelete<cr>', opts)

-- Export the module
return {
    toggle_terminal = toggle_terminal,
    keep_cursor_in_window = keep_cursor_in_window
}
