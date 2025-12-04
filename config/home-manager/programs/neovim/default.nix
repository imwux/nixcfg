{
    ...
}:
{
    home.file.".config/nvim" = {
        source = ./config;
        recursive = true;
    };

    programs.neovim = {
        defaultEditor = true;
        extraLuaConfig = ''
            vim.o.tabstop = 4
            vim.o.softtabstop = 4
            vim.o.shiftwidth = 4
            vim.o.expandtab = true
            vim.o.number = true
            vim.o.guicursor = "n-v-i-c-ci-ve-sm:ver25,r-cr-o:hor20"
            vim.o.undodir = os.getenv("HOME") .. "/.cache/vim-undodir"
            vim.o.undofile = true
            vim.o.termguicolors = true
            vim.g.mapleader = " "
        '';
        withNodeJs = true;
    };
}
