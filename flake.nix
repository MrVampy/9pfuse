{
  description = "Standalone plan9port 9pfuse build";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "9pfuse";
        version = "2026-05-11";
        src = self;

        nativeBuildInputs = [ pkgs.plan9port ];

        dontConfigure = true;

        buildPhase = ''
          runHook preBuild
          (
            export PLAN9=${pkgs.plan9port}/plan9
            export PATH="$PLAN9/bin:$PATH"
            mk
          )
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          install -D -m 0755 o.9pfuse "$out/bin/9pfuse"
          install -D -m 0644 COPYRIGHT "$out/share/doc/9pfuse/COPYRIGHT"
          runHook postInstall
        '';

        meta = {
          description = "FUSE bridge for mounting 9P services";
          homepage = "https://github.com/MrVampy/9pfuse";
          license = pkgs.lib.licenses.mit;
          mainProgram = "9pfuse";
          platforms = pkgs.lib.platforms.linux;
        };
      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/9pfuse";
      };
    };
}
