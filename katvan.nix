{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  cmake,
  rustPlatform,
  rustc,
  cargo,
  qt6,
  libarchive,
  corrosion,
  hunspell,
  fetchCrate,
}:

let
  src = fetchFromGitHub {
    owner = "IgKh";
    repo = "katvan";
    tag = "v0.12.0";
    hash = "sha256-kjM7PqExD5YEB4wiHG/8IVLMj9OmhvCIfHYgQS3JZJY=";
  };

  # If Corrosion does not find `cxxbridge`, it tries to install it using
  # `cargo install --locked`. This fails in the derivation because the offline
  # registry created by `fetchCargoVendor` does not have all of the exact
  # locked versions. Instead, we build the same required version in Nix and
  # provide it via `nativeBuildInputs`.
  cargoToml = builtins.fromTOML (builtins.readFile "${src}/typstdriver/rust/Cargo.toml");
  cxxVersion = cargoToml.dependencies.cxx;
  cxxbridge-cmd = rustPlatform.buildRustPackage rec {
    pname = "cxxbridge-cmd";
    version = cxxVersion;
    src = fetchCrate {
      inherit pname version;
      hash = "sha256-IkJKMwfoV/1C4kLOmWVxqpzgeTfWcm7UQrwIo+WSwr4=";
    };
    cargoHash = "sha256-NsKTecxJBvF238dCNNIQc+l+8VyohKCxRXREf6/4YgE=";
    cargoBuildFlags = [
      "-p"
      "cxxbridge-cmd"
    ];
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "katvan";
  version = "0.12.0";

  strictDeps = true;
  __structuredAttrs = true;
  nativeBuildInputs = [
    pkg-config
    cmake
    rustPlatform.cargoSetupHook
    rustc
    cargo
    qt6.qttools
    cxxbridge-cmd
  ];

  buildInputs = [
    qt6.qtbase
    libarchive
    corrosion
    hunspell
  ];

  inherit src;

  cargoRoot = "typstdriver/rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-WBzU3kLJ+0gqFNwSsViafayRXF5UwQHNY9qOgeV8uNM=";
  };

  cmakeFlags = [
    # This custom option tells it to put `tpystdriver` in `$out/lib` instead of `$out/lib/katvan`
    # See https://github.com/IgKh/katvan/commit/e09641ebc86c86dc10e1e6d6acad6369c10dc686
    # FIXME: this has no effect on darwin environments; how to fix?
    "-DAPPIMAGE_INSTALL=ON"
  ];

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://katvan.app/";
    description = "Editor for Typst files with a bias for Right-to-Left languages";
    license = lib.licenses.gpl3Plus;
    mainProgram = "katvan";
    maintainers = with lib.maintainers; [ amiryal ];
    platforms = lib.platforms.linux;
  };
})
