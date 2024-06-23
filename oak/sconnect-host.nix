{ lib, stdenv, autoPatchelfHook, gcc-unwrapped, glibc }:

stdenv.mkDerivation rec {
  pname = "sconnect-host";
  version = "2.15.1.0";

  src = ./sconnect-host-v${version}/sconnect_host_linux;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ gcc-unwrapped.lib glibc ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/sconnect_host_linux
    chmod +x $out/bin/sconnect_host_linux
  '';

  meta = with lib; {
    description = "SConnect Host Application";
    homepage = "https://www.gemalto.com/";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
