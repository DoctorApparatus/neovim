local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- INFO: Load all plugins from the files in the plugins folder
function TableConcat(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

local function scan_plugins_dir()
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls ' .. os.getenv("HOME") .. "/.config/nvim/lua/plugins/")
    if pfile ~= nil then
        for filename in pfile:lines() do
            i = i + 1
            if filename ~= "main.lua" then
                filename = filename:gsub(".lua", "")
                t[i] = filename
            end
        end
        pfile:close()
    end
    return t
end

local plugins_full = {}
for i, t in pairs(scan_plugins_dir()) do
    local plugin = require('plugins/' .. t)
    plugins_full = TableConcat(plugins_full, { plugin })
end

require('lazy').setup(plugins_full, {})
