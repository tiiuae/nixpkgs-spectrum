{
  mkDerivation, lib, fetchurl, fetchpatch,
  gettext, pkg-config,
  qtbase,
  alsa-lib, curl, faad2, ffmpeg, flac, fluidsynth, gdk-pixbuf, lame, libbs2b,
  libcddb, libcdio, libcdio-paranoia, libcue, libjack2, libmad, libmms, libmodplug,
  libmowgli, libnotify, libogg, libpulseaudio, libsamplerate, libsidplayfp,
  libsndfile, libvorbis, libxml2, lirc, mpg123, neon, qtmultimedia, soxr,
  wavpack, libopenmpt
}:

mkDerivation rec {
  pname = "audacious";
  version = "4.1";

  src = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-${version}.tar.bz2";
    sha256 = "0p734psjjvjcmla2hg5h6a9v1prvy63jj9xm2g2ngs49jy7qan0z";
  };
  pluginsSrc = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-plugins-${version}.tar.bz2";
    sha256 = "0k0xnqmxi5lna034i2cnzvfzrykxmv4fbs1nkrc9sd2ma1igrmns";
  };

  nativeBuildInputs = [ gettext pkg-config ];

  buildInputs = [
    # Core dependencies
    qtbase

    # Plugin dependencies
    alsa-lib curl faad2 ffmpeg flac fluidsynth gdk-pixbuf lame libbs2b libcddb
    libcdio libcdio-paranoia libcue libjack2 libmad libmms libmodplug libmowgli
    libnotify libogg libpulseaudio libsamplerate libsidplayfp libsndfile
    libvorbis libxml2 lirc mpg123 neon qtmultimedia soxr wavpack
    libopenmpt
  ];

  configureFlags = [ "--disable-gtk" ];

  # Here we build both audacious and audacious-plugins in one
  # derivation, since they really expect to be in the same prefix.
  # This is slighly tricky.
  builder = builtins.toFile "builder.sh" ''
    # First build audacious.
    (
      source $stdenv/setup
      genericBuild
    )
    # Then build the plugins.
    (
      nativeBuildInputs="$out $nativeBuildInputs" # to find audacious
      source $stdenv/setup
      rm -rfv audacious-*
      src=$pluginsSrc
      genericBuild
    )
  '';

  meta = with lib; {
    description = "Audio player";
    homepage = "https://audacious-media-player.org/";
    maintainers = with maintainers; [ eelco ramkromberg ttuegel ];
    platforms = with platforms; linux;
    license = with licenses; [
      bsd2 bsd3 #https://github.com/audacious-media-player/audacious/blob/master/COPYING
      gpl2 gpl3 lgpl2Plus #http://redmine.audacious-media-player.org/issues/46
    ];
  };
}
