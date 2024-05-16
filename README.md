# Install Jellyfin on your Samsung TV

This project makes it easy to install a native Jellyfin application on your
Samsung TV. Samsung TV's since 2015 run an operating system called Tizen,
Jellyfin has an officially supported application, however they haven't yet made
it onto the [Samsung app store](https://github.com/jellyfin/jellyfin-tizen/issues/94).

In this repo I've made it easier to install this on your TV, without needing to
spend too long setting up a full development environment.

For documentation about the Jellyfin app, see [here](https://github.com/jellyfin/jellyfin-tizen).

## Usage

1. [Ensure your Samsung TV is in developer mode](https://developer.samsung.com/smarttv/develop/getting-started/using-sdk/tv-device.html#Connecting-the-TV-and-SDK)

   - If you're having trouble entering the developer screen, make sure you're using the "123" button on the remote when typing in "12345".
   - Please make sure you enter `Host PC IP` address to the device you're running this container on.

2. Make sure to uninstall Jellyfin application from the Samsung TV first
3. Run this command replacing first argument with the IP of your Samsung
4. (Optional) You can provide preferred [jellyfin-tizen-builds](https://github.com/jeppevinkel/jellyfin-tizen-builds) option (Jellyfin / Jellyfin-TrueHD / Jellyfin-master / Jellyfin-master-TrueHD / Jellyfin-secondary) as second argument. By default, Jellyfin option is used.

```bash
docker run --rm georift/install-jellyfin-tizen <samsung tv ip> <build option>
```

## Supported platforms

At the moment, these steps should work on any amd64 based system. Platforms
like the Raspberry Pi, which run ARM chips, are not yet supported, but
[we might have some progress soon.](https://github.com/Georift/install-jellyfin-tizen/issues/10).

## Errors

- `library initialization failed - unable to allocate file descriptor table - out of memory`

  Add `--ulimit nofile=1024:65536` to the `docker run` command:

  ```bash
  docker run -ulimit nofile=1024:65536 --rm georift/install-jellyfin-tizen <samsung tv ip>
  ```

- `install failed[118, -11], reason: Author certificate not match :`

  Uninstall the Jellyfin application from your Samsung TV, and run the installation again.

## Credits

This is possible thanks to these projects, this repo is just a quick pulling together
of all their hard work into some simply steps:

- [jellyfin-tizen](https://github.com/jellyfin/jellyfin-tizen)
- [jeppevinkel/jellyfin-tizen-builds](https://github.com/jeppevinkel/jellyfin-tizen-builds) for providing development builds
- [vitalets/docker-tizen-webos-sdk](https://github.com/vitalets/docker-tizen-webos-sdk) for a docker container preinstalled with the Tizen SDK
