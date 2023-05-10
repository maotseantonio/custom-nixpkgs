{ lib
, nimPackages
, fetchFromGitHub
}:

nimPackages.buildNimPackage rec {
  pname = "nitch";
  # version = "0.1.6";
  version = "081e9f67404babae7d5c23c9c63af307688b971f";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "lwndhrst";
    repo = "nitch";
    rev = "${version}";
    sha256 = "0ZQpTDfobTwrEh/vOd2ertXrix117HMCE8Q/uIVFNBg=";
  };

  meta = with lib; {
    description = "Incredibly fast system fetch written in nim";
    homepage = "https://github.com/unxsh/nitch";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ michaelBelsanti ];
    mainProgram = "nitch";
  };
}
