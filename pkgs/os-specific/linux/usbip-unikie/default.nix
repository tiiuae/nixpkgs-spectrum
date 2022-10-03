{ lib, stdenv, fetchpatch,  udev, autoconf, automake, libtool, hwdata }:

stdenv.mkDerivation {

  name = "usbip-unikie";
  nativeBuildInputs = [ autoconf automake libtool ];
  # buildInputs = [ libudev-zero ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=address-of-packed-member" ];

  preConfigure = ''
    cd tools/usb/usbip
    ./autogen.sh
  '';

  configureFlags = [ "--with-usbids-dir=${hwdata}/share/hwdata/" ];

  meta = with lib; {
    homepage = "https://github.com/torvalds/linux/tree/master/tools/usb/usbip";
    description = "allows to pass USB device from server to client over the network";
    license = with licenses; [ gpl2Only gpl2Plus ];
    platforms = platforms.linux;
  };
}
