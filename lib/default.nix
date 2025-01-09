{lib, ...}: {
    scanPaths = path:
        map (f: (path + "/${f}"))
        (builtins.attrNames
         (lib.attrsets.filterAttrs
          ( path: _type: (_type == "directory") || (
                (path != "default.nix") && (lib.strings.hasSuffix ".nix" path)
              )
          ) (builtins.readDir path)));
    scanFiles = path:
        map (f: (path + "/${f}")) (builtins.attrNames (builtins.readDir path));
}
