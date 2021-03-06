{ lib, stdenv, fetchFromGitHub, boost, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "pamixer";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "cdemoulins";
    repo = "pamixer";
    rev = version;
    sha256 = "sha256-7VNhHAQ1CecQPlqb8SMKK0U1SsFZxDuS+QkPqJfMqrQ=";
  };

  buildInputs = [ boost libpulseaudio ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Pulseaudio command line mixer";
    longDescription = ''
      Features:
        - Get the current volume of the default sink, the default source or a selected one by its id
        - Set the volume for the default sink, the default source or any other device
        - List the sinks
        - List the sources
        - Increase / Decrease the volume for a device
        - Mute or unmute a device
    '';
    homepage = "https://github.com/cdemoulins/pamixer";
    maintainers = with maintainers; [ thiagokokada ];
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "pamixer";
  };
}
