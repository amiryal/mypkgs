{
  lib,
  stdenv,
  autoreconfHook,
  pkg-config,
  fetchFromGitHub,

  # Mandatory
  gtk3,
  libxml2,

  # Optional
  enableLadspa ? true,
  lrdf,
  enableCdda ? true,
  libcdio,
  libcdio-paranoia,
  enableCddb ? true,
  libcddb,
  enableSrc ? true,
  libsamplerate,
  enableIfp ? false, # FIXME: find the right dependency if it exists in nixpkgs
  enableLua ? true,
  lua,

  # File I/O
  enableSndfile ? true,
  libsndfile,
  enableFlac ? true,
  flac,
  enableVorbis ? true,
  libvorbis,
  enableSpeex ? true,
  liboggz,
  speex,
  enableMpeg ? true,
  libmad,
  enableLame ? true,
  lame,
  enableMod ? true,
  libmodplug,
  enableMpc ? true,
  libmpcdec,
  enableMac ? true,
  mac,
  enableWavpack ? true,
  wavpack,
  enableLavc ? true,
  ffmpeg,

  # Output
  enableSndio ? true,
  sndio,
  enableAlsa ? true,
  alsa-lib,
  enableJack ? true,
  libjack2,
  enablePulse ? true,
  pulseaudio,
}:
stdenv.mkDerivation {
  pname = "aqualung";
  version = "2.0";
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs =
    [
      gtk3
      libxml2
    ]
    ++ lib.optional enableLadspa lrdf
    ++ lib.optionals enableCdda [
      libcdio
      libcdio-paranoia
    ]
    ++ lib.optional enableCddb libcddb
    ++ lib.optional enableSrc libsamplerate
    ++ lib.optional enableIfp (throw "unsupported option")
    ++ lib.optional enableLua lua

    ++ lib.optional enableSndfile libsndfile
    ++ lib.optional enableFlac flac
    ++ lib.optional enableVorbis libvorbis
    ++ lib.optionals enableSpeex [
      liboggz
      speex
    ]
    ++ lib.optional enableMpeg libmad
    ++ lib.optional enableLame lame
    ++ lib.optional enableMod libmodplug
    ++ lib.optional enableMpc libmpcdec
    ++ lib.optional enableMac mac
    ++ lib.optional enableWavpack wavpack
    ++ lib.optional enableLavc ffmpeg

    ++ lib.optional enableSndio sndio
    ++ lib.optional enableAlsa alsa-lib
    ++ lib.optional enableJack libjack2
    ++ lib.optional enablePulse pulseaudio;
  src = fetchFromGitHub {
    owner = "jeremyevans";
    repo = "aqualung";
    rev = "ecb4cd11d6eefaf8b4a97d837a986623bcff653a";
    sha256 = "sha256-wU3PvRG0mWfd4+y3rcXX/nomU9f6X+TLaHPtDQF6a24=";
  };
}
