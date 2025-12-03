{
  config,
  pkgs,
  ...
}: {
  env = {
    GPG_FINGERPRINT = "F18796882312EA12DCF09981742AB2CAF5AD15A6";
  };

  packages = with pkgs; [
    # Development
    just
    tree
    zsh

    # Go tools
    goreleaser
    golangci-lint

    # Formatters
    alejandra
    gotools
    nodePackages.prettier
    shfmt
    treefmt
  ];

  languages.go = {
    enable = true;
    package = pkgs.go_1_24;
  };
}
