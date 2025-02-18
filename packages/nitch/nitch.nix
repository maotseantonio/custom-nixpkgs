{ lib
 ,buildNimPackage
 ,fetchFromGitHub
}:

buildNimPackage rec {
  pname = "nitch";
  version = "0.1.6";
  src = fetchFromGitHub {
    owner = "maotseantonio";
    repo = "nitch";
    rev = "v${version}";
    sha256 = "17ibk7mx74i9wnkm3g1pfz75db4j9m4d2abs3lnr742ajy7xypl7";
  };
  meta = with lib; {
    description = "Incredibly fast system fetch written in nim";
    homepage = "https://github.com/maotseantonio/nitch";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "nitch";
  };
}
