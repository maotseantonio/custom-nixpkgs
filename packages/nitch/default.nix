{ lib
, nimPackages
, fetchFromGitHub
}:

nimPackages.buildNimPackage rec {
  pname = "nitch";
  version = "0.1.6";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "lwndhrst";
    repo = "nitch";
    rev = "v${version}";
    sha256 = "KDNNagSaLSttw0LmUKr6nsTzITr/MnZWDgpL5aIuWAA=";
  };

  meta = with lib; {
    description = "Incredibly fast system fetch written in nim";
    homepage = "https://github.com/lwndhrst/nitch";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "nitch";
  };
}
