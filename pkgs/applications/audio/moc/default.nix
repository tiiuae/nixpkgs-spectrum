{ lib, stdenv, fetchurl, pkg-config
, ncurses, db , popt, libtool
, libiconv, CoreServices
# Sound sub-systems
, alsaSupport ? (!stdenv.isDarwin), alsa-lib
, pulseSupport ? true, libpulseaudio, autoreconfHook
, jackSupport ? true, libjack2
, ossSupport ? true
# Audio formats
, aacSupport ? true, faad2, libid3tag
, flacSupport ? true, flac
, midiSupport ? true, timidity
, modplugSupport ? true, libmodplug
, mp3Support ? true, libmad
, musepackSupport ? true, libmpc, libmpcdec, taglib
, vorbisSupport ? true, libvorbis
, speexSupport ? true, speex
, ffmpegSupport ? true, ffmpeg
, sndfileSupport ? true, libsndfile
, wavpackSupport ? true, wavpack
# Misc
, curlSupport ? true, curl
, samplerateSupport ? true, libsamplerate
, withDebug ? false
}:

let
  opt = lib.optional;
  mkFlag = c: f: if c then "--with-${f}" else "--without-${f}";

in stdenv.mkDerivation rec {

  pname = "moc";
  version = "2.5.2";

  src = fetchurl {
    url = "http://ftp.daper.net/pub/soft/moc/stable/moc-${version}.tar.bz2";
    sha256 = "026v977kwb0wbmlmf6mnik328plxg8wykfx9ryvqhirac0aq39pk";
  };

  patches = []
    ++ opt ffmpegSupport ./moc-ffmpeg4.patch
    ++ opt pulseSupport ./pulseaudio.patch;

  nativeBuildInputs = [ pkg-config ]
    ++ opt pulseSupport autoreconfHook;

  buildInputs = [ ncurses db popt libtool ]
    # Sound sub-systems
    ++ opt alsaSupport alsa-lib
    ++ opt pulseSupport libpulseaudio
    ++ opt jackSupport libjack2
    # Audio formats
    ++ opt (aacSupport || mp3Support) libid3tag
    ++ opt aacSupport faad2
    ++ opt flacSupport flac
    ++ opt midiSupport timidity
    ++ opt modplugSupport libmodplug
    ++ opt mp3Support libmad
    ++ lib.optionals musepackSupport [ libmpc libmpcdec taglib ]
    ++ opt vorbisSupport libvorbis
    ++ opt speexSupport speex
    ++ opt ffmpegSupport ffmpeg
    ++ opt sndfileSupport libsndfile
    ++ opt wavpackSupport wavpack
    # Misc
    ++ opt curlSupport curl
    ++ opt samplerateSupport libsamplerate
    ++ lib.optionals stdenv.isDarwin [ libiconv CoreServices ];

  configureFlags = [
    # Sound sub-systems
    (mkFlag alsaSupport "alsa")
    (mkFlag pulseSupport "pulse")
    (mkFlag jackSupport "jack")
    (mkFlag ossSupport "oss")
    # Audio formats
    (mkFlag aacSupport "aac")
    (mkFlag flacSupport "flac")
    (mkFlag midiSupport "timidity")
    (mkFlag modplugSupport "modplug")
    (mkFlag mp3Support "mp3")
    (mkFlag musepackSupport "musepack")
    (mkFlag vorbisSupport "vorbis")
    (mkFlag speexSupport "speex")
    (mkFlag ffmpegSupport "ffmpeg")
    (mkFlag sndfileSupport "sndfile")
    (mkFlag wavpackSupport "wavpack")
    # Misc
    (mkFlag curlSupport "curl")
    (mkFlag samplerateSupport "samplerate")
    ("--enable-debug=" + (if withDebug then "yes" else "no"))
    "--disable-cache"
    "--without-rcc"
  ];

  meta = with lib; {
    description = "An ncurses console audio player designed to be powerful and easy to use";
    homepage = "http://moc.daper.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ aethelz pSub jagajaga ];
    platforms = platforms.unix;
  };
}
