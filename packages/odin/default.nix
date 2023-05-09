{ lib
, fetchFromGitHub
, llvmPackages
, makeWrapper
, which
}:

let
  inherit (llvmPackages) stdenv;

in stdenv.mkDerivation rec {
  pname = "odin";
  version = "dev-2023-05";
  dontConfigure = true;

  src = fetchFromGitHub {
    owner = "odin-lang";
    repo = "Odin";
    rev = "${version}";
    sha256 = "qEewo2h4dpivJ7D4RxxBZbtrsiMJ7AgqJcucmanbgxY=";
  };

  nativeBuildInputs = [
    makeWrapper
    which
  ];

  LLVM_CONFIG = "${llvmPackages.llvm.dev}/bin/llvm-config";

  postPatch = ''
    sed -i 's/^GIT_SHA=.*$/GIT_SHA=/' build_odin.sh
    sed -i 's/LLVM-C/LLVM/' build_odin.sh
    patchShebangs build_odin.sh
  '';

  buildFlags = [
    "release"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp odin $out/bin/odin
    cp -r core $out/bin/core
    cp -r vendor $out/bin/vendor

    wrapProgram $out/bin/odin --prefix PATH : ${lib.makeBinPath (with llvmPackages; [
      bintools
      llvm
      clang
      lld
    ])}
  '';

  meta = with lib; {
    description = "A fast, concise, readable, pragmatic and open sourced programming language";
    homepage = "https://odin-lang.org/";
    license = licenses.bsd3;
    platforms = platforms.x86_64;
  };
}
