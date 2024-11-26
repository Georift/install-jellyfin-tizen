# Install Jellyfin on your Samsung TV

This project makes it easy to install a native Jellyfin application on your
Samsung TV. Samsung TV's since 2015 run an operating system called Tizen,
Jellyfin has an officially supported application, however they haven't yet made
it onto the [Samsung app store](https://github.com/jellyfin/jellyfin-tizen/issues/94).

In this repo I've made it easier to install this on your TV, without needing to
spend too long setting up a full development environment.

For documentation about the Jellyfin app, see [here](https://github.com/jellyfin/jellyfin-tizen).

## Usage

#### Prerequisites
- Install [Docker](https://www.docker.com/get-started/) & have any necessary [Virtualization](https://support.microsoft.com/en-us/windows/enable-virtualization-on-windows-11-pcs-c5578302-6e43-4b4b-a449-8ced115f58e1) features enabled.
- Ensure you are on the same network as the TV you are trying to install the app to.
#### Installation
1. [Ensure your Samsung TV is in developer mode](https://developer.samsung.com/smarttv/develop/getting-started/using-sdk/tv-device.html#Connecting-the-TV-and-SDK)

   - If you're having trouble entering the developer screen, open the number pad using the "123" button before typing "12345" with the on-screen keyboard.

   - Enter the `Host PC IP` address of the device you're running this container on.
     > Troubleshooting Tip: If the on-screen keyboard will not pop up or if it does pop up but nothing is being entered while typing then please use either an external bluetooth keyboard or add the TV on the Samsung SmartThings app (available on iOS or Android). Once signed in, add your device (it may hang during pairing but still work if you go back to home, else try pairing again). Select the devices tab on the bottom and then tap your device; the widget may display 'downloading' however the virtual remote should appear. Swipe up to maximize the virtual device - you should see a bottom section appear. Swipe on the bottom section of the virtual device to the numeric keypad. You will now be able to enter the Host PC IP address with the virtual numeric keyboard. Enter the IP address and then hit okay as before. Now run the docker command described below. This behavior has been documented on the (UN43TU7000GXZD & UN55AU8000BXZA and likely exists on other models as well).

> [!NOTE]
> If the TV is set to use a Right-to-left language (Arabic, Hebrew, etc). You need to enter the IP address on the TV backwards. [Read more.](https://github.com/Georift/install-jellyfin-tizen/issues/30)

2. Make sure to uninstall Jellyfin application from the Samsung TV first

3. Run the command below, replacing first argument with the IP of your Samsung TV

   - If you just want to install the default build, do not put anything after the IP address.
   - (Optional) You can provide preferred [jellyfin-tizen-builds](https://github.com/jeppevinkel/jellyfin-tizen-builds) option (Jellyfin / Jellyfin-TrueHD / Jellyfin-master / Jellyfin-master-TrueHD / Jellyfin-secondary) as second argument. By default, Jellyfin option is used.
   - (Optional) You can provide preferred [jellyfin-tizen-builds releases](https://github.com/jeppevinkel/jellyfin-tizen-builds/releases) release tag URL as third argument. By default, latest version is used. This is useful if you want to install older Jellyfin Tizen Client version.
   

```bash
**docker run --rm ghcr.io/georift/install-jellyfin-tizen** <u>samsung tv ip</u> [build option] [tag url]
```

Example:

```bash
docker run --rm ghcr.io/georift/install-jellyfin-tizen 192.168.0.10 Jellyfin-TrueHD "https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/tag/2024-05-13-0139"
```

### Validating Success

If everything went well, you should see docker output something like the following

```txt
Installed the package: Id(AprZAARz4r.Jellyfin)
Tizen application is successfully installed.
Total time: 00:00:12.205
```

At this point you can find jellyfin on your TV by navigating to Apps -> Downloaded (scroll down), where you'll find jellyfin.

## Supported platforms

At the moment, these steps should work on any amd64 based system. Platforms
like the Raspberry Pi, which run ARM chips, are not yet supported, but
[we might have some progress soon.](https://github.com/Georift/install-jellyfin-tizen/issues/10).

## Errors

- `library initialization failed - unable to allocate file descriptor table - out of memory`

  Add `--ulimit nofile=1024:65536` to the `docker run` command:

  ```bash
  docker run --ulimit nofile=1024:65536 --rm ghcr.io/georift/install-jellyfin-tizen <samsung tv ip> <build option> <tag url>
  ```

- `install failed[118, -11], reason: Author certificate not match :`

  Uninstall the Jellyfin application from your Samsung TV, and run the installation again.

## Credits

This is possible thanks to these projects, this repo is just a quick pulling together
of all their hard work into a simple command:

- [jellyfin-tizen](https://github.com/jellyfin/jellyfin-tizen)
- [jeppevinkel/jellyfin-tizen-builds](https://github.com/jeppevinkel/jellyfin-tizen-builds) for providing development builds
- [vitalets/docker-tizen-webos-sdk](https://github.com/vitalets/docker-tizen-webos-sdk) for a docker container preinstalled with the Tizen SDK
