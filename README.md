# Install Jellyfin for Samsung TV

This project makes it easy to install [Jellyfin for Samsung TV](https://github.com/jellyfin/jellyfin-tizen) by automating the environment configuration with Docker.

Samsung TVs have been running Tizen OS since 2015, and while the Jellyfin app is stable & officially supported, [the app has yet to make it onto the Samsung app store since efforts began in late 2021](https://github.com/jellyfin/jellyfin-tizen/issues/94).

Install Jellyfin to your TV with just one command once your computer and TV are configured as described below.

## Configure Computer (PC, Laptop, etc...)
- Follow [Docker Installation Instructions](https://www.docker.com/get-started/)
- Enable any necessary [Virtualization](https://support.microsoft.com/en-us/windows/enable-virtualization-on-windows-11-pcs-c5578302-6e43-4b4b-a449-8ced115f58e1) features.
- Ensure you are on the same network as the TV you are trying to install the app to.

## Configure Samsung TV

#### Place TV in Developer Mode

> [!NOTE]
> If the TV is set to use a Right-to-left language (Arabic, Hebrew, etc). You need to enter the IP address on the TV backwards. [Read more.](https://github.com/Georift/install-jellyfin-tizen/issues/30)
- On the TV, open the "Smart Hub".
- Select the "Apps" panel.
- Press the "123" button (or if your remote doesn't have this button, long press the Home button) before typing "12345" with the on-screen keyboard.
- Toggle the `Developer` button to `On`.
- Enter the `Host PC IP` address of the device you're running this container on.
    > Troubleshooting Tip: If the on-screen keyboard will not pop up or if it does pop up but nothing is being entered while typing then please use either an external Bluetooth keyboard or follow these instructions to utilize the virtual keyboard from the Samsung SmartThings app (available on iOS or Android). Download the SmartThings app from your app store. Sign into your Samsung account on your TV and SmartThings app. Open the SmartThings app. Grant the requested permissions. On the bottom toolbar select `Devices`, select the `+` icon, select `Samsung Devices Add`, select `TV` then wait and select your TV (it may hang during pairing but still work if you navigate back to `Devices`). Select your TV widget (the widget may briefly display 'downloading') and the virtual remote should appear shortly. Swipe up to maximize the virtual remote—you should see a bottom section appear. Swipe on the bottom section of the virtual device until you find the numeric keypad. Enter the Host PC IP address with the virtual numeric keyboard. Enter the IP address and then select `Okay`. Now run the docker command described below. (This issue has been documented on the UN43TU7000G/UN55AU8000B and likely exists on other models as well.)

#### Uninstall Existing Jellyfin Installations, If Required

Follow the [Samsung uninstall instructions](https://www.samsung.com/in/support/tv-audio-video/how-to-uninstall-an-app-on-samsung-smart-tv/)

#### Find IP Address

- Exact instructions will vary with the model of TV. In general you can find the TV's IP address in Settings under Networking or About. Plenty of guides are availble with a quick search, however for brevity a short guide with pictures can be found [here](https://www.techsolutions.support.com/how-to/how-to-check-connection-on-samsung-smart-tv-10925).

- Make a note of the IP address as it will be needed later. 

## Install Jellyfin

#### Installation
- Run the command below, replacing first argument with the IP of your Samsung TV
   - If you just want to install the default build, do not put anything after the IP address.
   - (Optional) You can provide preferred [jellyfin-tizen-builds](https://github.com/jeppevinkel/jellyfin-tizen-builds) option (Jellyfin / Jellyfin-TrueHD / Jellyfin-master / Jellyfin-master-TrueHD / Jellyfin-secondary) as second argument. By default, Jellyfin option is used.
   - (Optional) You can provide preferred [jellyfin-tizen-builds releases](https://github.com/jeppevinkel/jellyfin-tizen-builds/releases) release tag URL as third argument. By default, latest version is used. This is useful if you want to install older Jellyfin Tizen Client version.
   

```bash
docker run --rm ghcr.io/georift/install-jellyfin-tizen <samsung tv ip> [build option] [tag url]
```

Example:

```bash
docker run --rm ghcr.io/georift/install-jellyfin-tizen 192.168.0.10 Jellyfin-TrueHD "https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/tag/2024-05-13-0139"
```

#### Common Errors

- `library initialization failed - unable to allocate file descriptor table - out of memory`

  Add `--ulimit nofile=1024:65536` to the `docker run` command:

  ```bash
  docker run --ulimit nofile=1024:65536 --rm ghcr.io/georift/install-jellyfin-tizen <samsung tv ip> <build option> <tag url>
  ```

- `install failed[118, -11], reason: Author certificate not match :`

  Uninstall the Jellyfin application from your Samsung TV, and run the installation again.

#### Success

If everything went well, you should see docker output something like the following

```txt
Installed the package: Id(AprZAARz4r.Jellyfin)
Tizen application is successfully installed.
Total time: 00:00:12.205
```

At this point you can find jellyfin on your TV by navigating to Apps -> Downloaded (scroll down), where you'll find Jellyfin.

## Supported Platforms

At the moment, these steps should work on any amd64 based system. Platforms
like the Raspberry Pi, which run ARM chips, are not yet supported, but
[we might have some progress soon.](https://github.com/Georift/install-jellyfin-tizen/issues/10).

### Additional Required Commands: ARM (MacOS M Chips and higher)
- Firstly make sure that you have the Experimental "Virtualization Framework" enabled.
- Verify that docker on your M series has qemu installed. You can do this by running:
```docker run --rm --platform linux/amd64 alpine uname -m```

If it outputs: **x86_64** you're good. If not, reinstall docker, with the needed requirements.

Then use the ```--platform linux/amd64"``` argument on the original command. This should look something like this:
```docker run --rm --platform linux/amd64 ghcr.io/georift/install-jellyfin-tizen <samsung tv ip> <build option> <tag url>```

## Credits

This project is possible thanks to these projects:

- [jellyfin-tizen](https://github.com/jellyfin/jellyfin-tizen)
- [jeppevinkel/jellyfin-tizen-builds](https://github.com/jeppevinkel/jellyfin-tizen-builds) for providing development builds
- [vitalets/docker-tizen-webos-sdk](https://github.com/vitalets/docker-tizen-webos-sdk) for a docker container preinstalled with the Tizen SDK
