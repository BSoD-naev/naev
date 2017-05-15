# NAEV README

Naev is a 2D space trading and combat game, taking inspiration from the Escape
Velocity series, among others.

You pilot a space ship from a top-down perspective, and are more or less free
to do what you want. As the genre name implies, you’re able to trade and engage
in combat at will. Beyond that, there’s an ever-growing number of storyline
missions, equipment, and ships; Even the galaxy itself grows larger with each
release. For the literarily-inclined, there are large amounts of lore
accompanying everything from planets to equipment.

## DEPENDENCIES

   Naev's dependencies are intended to be relatively common. In addition to
   an OpenGL-capable graphics card and driver, Naev requires the following:
      * SDL
      * libxml2
      * freetype2
      * libpng
      * OpenAL
      * libvorbis (>= 1.2.1 necessary for Replaygain)
      * binutils
      * libzip

   Note that several distributions ship outdated versions of libvorbis, and
   thus libvorbisfile is statically linked into the release binary.

   Compiling your own binary on many distributions will result in Replaygain
   being disabled.

   See http://wiki.naev.org/wiki/Compiling_Nix for package lists for several
   distributions.

   Mac Dependencies are different, see extras/macosx/COMPILE for details.

## COMPILING

   Run: 

   ./autogen.sh && ./configure
   make

   If you need special settings you should pass flags to configure, using -h
   will tell you what it supports.

   On Mac OS X, see extras/macosx/COMPILE for details. Uses Xcode, not gcc.


## INSTALLATION

   Naev currently supports make install which will install everything that
   is needed.

   If you wish to create a .desktop for your desktop environment, logos
   from 16x16 to 256x256 can be found in extras/logos

## CRASHES & PROBLEMS

   Please take a look at the FAQ (linked below) before submitting a new
   bug report, as it covers a number of common gameplay questions and
   common issues.

   If Naev is crashing during gameplay, please file a bug report after
   reading http://wiki.naev.org/wiki/Bugs

