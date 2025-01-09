{...}: {
    programs.nixvim.plugins.smartcolumn = {
        enable = true;
        settings = {
            disabled_filetypes = [
                "text"
                "markdown"
                "html"
                "help"
            ];
        };
    };
}
