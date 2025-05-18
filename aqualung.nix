{
  stdenv,
  autoreconfHook,
  pkg-config,
  fetchFromGitHub,

  gtk3,
  libxml2,

  lrdf,
  # libcdio, # the wrong one?
  libcddb,
  libsamplerate,
  lua,

  libsndfile,
  flac,
  libvorbis,
  liboggz,
  speex,
  libmad,
  lame,
  libmodplug,
  libmpcdec,
  mac,
  wavpack,
  ffmpeg,

  sndio,
  alsa-lib,
  libjack2,
  pulseaudio,
}:
stdenv.mkDerivation {
  pname = "aqualung";
  version = "2.0";
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    gtk3
    libxml2

    lrdf
    # libcdio ?
    libcddb
    libsamplerate
    # libifp ?
    lua

    libsndfile
    flac
    libvorbis
    liboggz
    speex
    libmad
    lame
    libmodplug
    libmpcdec
    mac
    wavpack
    ffmpeg

    sndio
    # soundcard.h ?
    alsa-lib
    libjack2
    pulseaudio
  ];
  src = fetchFromGitHub {
    owner = "jeremyevans";
    repo = "aqualung";
    rev = "ecb4cd11d6eefaf8b4a97d837a986623bcff653a";
    sha256 = "sha256-wU3PvRG0mWfd4+y3rcXX/nomU9f6X+TLaHPtDQF6a24=";
  };
}
