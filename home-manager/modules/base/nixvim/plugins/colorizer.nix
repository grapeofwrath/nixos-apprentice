{...}: {
    programs.nixvim.plugins.colorizer = {
        enable = true;
        settings.user_default_options.tailwind = "both";
    };
}
