# FFmpeg static build

Three scripts to make a static build of ffmpeg with all the latest codecs (webm + h264).

Just follow the instructions below. Once you have the build dependencies,
just run `./build.sh`, wait and you should get the ffmpeg binary in `./bin/`


## Build dependencies

  XCode


## Build & "install"

    $ `./build.sh`
    # ... wait ...
    # binaries can be found in `./bin/`

NOTE: If you're going to use the h264 presets, make sure to copy them along the binaries. For ease, you can put them in your home folder like this:

    $ `mkdir ~/.ffmpeg`
    $ `cp ./target/share/ffmpeg/*.ffpreset ~/.ffmpeg`


## Debug

On the top-level of the project, run:

  $ `. env.sh`

You can then enter the source folders and make the compilation yourself

  $ `cd build/ffmpeg-*`
  $ `./configure --prefix=$TARGET_DIR #...`
  # ...


## Remaining links

I'm not sure it's a good idea to statically link those, but it probably
means the executable won't work across distributions or even across releases.

    $ `otool -L ffmpeg`
    ffmpeg:
      /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 125.2.0)


## notes

```
brew uninstall glib
brew install glib --with-static
```
