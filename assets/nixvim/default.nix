{
    inputs,
    pkgs,
    gLib,
    gVar,
    ...
}: {
    imports = (gLib.scanPaths ./.) ++ [inputs.nixvim.homeManagerModules.nixvim];

    home.packages = with pkgs; [
        wl-clipboard
    ];
    programs.nixvim = {
        enable = true;
        defaultEditor = true;
        globals = {
            mapleader = " ";
        };
        keymaps = [
            {
                mode = "n";
                key = "<leader>q";
                action = "<cmd>qa<CR>";
                options.desc = "Quit NeoVim";
            }
            {
                mode = "n";
                key = "<leader>w";
                action = "<cmd>w<CR>";
                options.desc = "Save Current Buffer";
            }
            {
                mode = "n";
                key = "<leader>wq";
                action = "<cmd>wqa<CR>";
                options.desc = "Save buffer and quite neovim";
            }
            {
                mode = "n";
                key = "<C-h>";
                action = "<C-w>h";
            }
            {
                mode = "n";
                key = "<C-j>";
                action = "<C-w>j";
            }
            {
                mode = "n";
                key = "<C-k>";
                action = "<C-w>k";
            }
            {
                mode = "n";
                key = "<C-l>";
                action = "<C-w>l";
            }
            {
                mode = "n";
                key = "<leader>ee";
                action = "o<Esc><cmd>norm Oif err != nil {log.Fatal(err)}<CR>";
                options.desc = "Go handle err";
            }
        ];
        clipboard = {
            register = "unnamedplus";
            providers.wl-copy.enable = true;
        };
        opts = {
            autoindent = true;
            cursorline = true;
            expandtab = true;
            hidden = true;
            helpheight = 9999;
            ignorecase = true;
            incsearch = true;
            list = true;
            listchars = "tab:>-,trail:●,nbsp:+";
            number = true;
            relativenumber = true;
            scrolloff = 5;
            shiftwidth = 4;
            signcolumn = "yes";
            smartcase = true;
            softtabstop = 4;
            spell = false;
            splitbelow = true;
            splitright = true;
            tabstop = 4;
            updatetime = 100;
        };
        autoCmd = [
            {
                event = "FileType";
                pattern = "nix";
                command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4";
            }
        ];
        colorschemes.rose-pine = let c = gVar.campfire; in {
            enable = true;
            settings = {
                highlight_groups = {
                    Include.fg = c.shore;
                    Integer.fg = c.moon;
                    Keyword.fg = c.dusk;
                    nixArgumentDefinition.fg = c.foam;
                    nixAttributeAssignment.fg = c.highlight;
                };
                palette.main = {
                    base = c.base;
                    surface = c.surface;
                    overlay = c.overlay;
                    muted = c.muted;
                    subtle = c.subtle;
                    text = c.text;
                    love = c.ember;
                    gold = c.evergreen;
                    rose = c.dawn;
                    pine = c.dusk;
                    foam = c.foam;
                    iris = c.fern;
                };
            };
        };
    };
}
