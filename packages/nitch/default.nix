{ lib
, nimPackages
, fetchFromGitHub
}:

nimPackages.buildNimPackage rec {
  pname = "nitch";
  version = "0.1.7";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "lwndhrst";
    repo = "nitch";
    rev = "${version}";
    sha256 = "r0r2r2FryjY02lD7RlXkUsChbePuzOJjCw234MjBdTI=";
  };

  meta = with lib; {
    description = "Incredibly fast system fetch written in nim";
    homepage = "https://github.com/lwndhrst/nitch";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "nitch";
  };
}
