{ lib, stdenv, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "sconnect-host";
  version = "2.14.0.0";

  src = fetchurl {
    url = "file:///home/hammar/dotfiles/oak/sconnect-host-v${version}/sconnect_host_linux";
    sha256 = "1v8ngz3f6v5y7drl5qgpnf5l6n7fpkrlkzczcx72nawq81i9gm4l";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

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
