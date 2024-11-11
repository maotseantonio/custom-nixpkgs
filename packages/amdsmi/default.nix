{ lib
, fetchFromGitHub
, rocmPackages
, cmake
, pkg-config
, python312Packages
, libdrm
}:

let
  esmi_ib_library = fetchFromGitHub {
    owner = "amd";
    repo = "esmi_ib_library";
    rev = "esmi_pkg_ver-3.0.3";
    sha256 = "q0w5c5c+CpXkklmSyfzc+sbkt4cHNxscGJA3AXwvHxQ=";
  };

in rocmPackages.llvm.rocmClangStdenv.mkDerivation rec {
  pname = "amdsmi";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "amdsmi";
    rev = "rocm-${version}";
    sha256 = "L/Eg7xbIrNQSDS5m5raS4UKIzW9yaPpvseiuBt0Aj8U=";
  };

  buildInputs = [
    libdrm
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python312Packages.wrapPython
  ];

  cmakeFlags = [
    "-DENABLE_ESMI_LIB=OFF"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];
  
  postInstall = ''
    wrapPythonProgramsIn $out
  '';

  meta = with lib; {
    description = "The AMD System Management Interface (SMI) Library, or AMD SMI library, is a C library for Linux that provides a user space interface for applications to monitor and control AMD devices.";
    homepage = "https://rocm.docs.amd.com/projects/amdsmi/en/latest";
    platforms = platforms.x86_64;
  };
}
