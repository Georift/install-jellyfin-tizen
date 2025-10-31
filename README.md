# Install Jellyfin for Samsung TV

This project makes it easy to install [Jellyfin for Samsung TV](https://github.com/jellyfin/jellyfin-tizen) with a single pre-configured docker container.

Jellyfin has yet to make it onto the Samsung App store, [but active effort is under way to get it there](https://github.com/jellyfin/jellyfin-tizen/issues/222#issuecomment-3459574549).

## Configure Computer (PC, Laptop, etc...)

- Install [Docker](https://www.docker.com/get-started/)
  * Enable any necessary [Virtualization](https://support.microsoft.com/en-us/windows/enable-virtualization-on-windows-11-pcs-c5578302-6e43-4b4b-a449-8ced115f58e1) features.

- Ensure you are connected to the same network as the TV.

## Configure Samsung TV

#### Place TV in Developer Mode

- On the TV, open the "Smart Hub".
- Select the "Apps" panel.
- Press the "123" button (or if your remote doesn't have this button, long press the Home button) before typing "12345" with the on-screen keyboard.
- Toggle the `Developer` button to `On`.
- Enter the `Host PC IP` address of the computer you're running this container on. [Need help?](docs/troubleshooting.md)

#### Uninstall Existing Jellyfin Installations, If Required

Follow the [Samsung uninstall instructions](https://www.samsung.com/in/support/tv-audio-video/how-to-uninstall-an-app-on-samsung-smart-tv/)

#### Find IP Address

- Exact instructions will vary with the model of TV. In general you can find the TV's IP address in Settings under Networking or About. Plenty of guides are available with a quick search, however for brevity a short guide with pictures can be found [here](https://www.techsolutions.support.com/how-to/how-to-check-connection-on-samsung-smart-tv-10925).

- Make a note of the IP address as it will be needed later. 

## Install Jellyfin

#### Installation
- Run the command below, replacing first argument with the IP of your Samsung TV
   - If you just want to install the default build, do not put anything after the IP address.
    - (Optional) You can provide preferred [jellyfin-tizen-builds](https://github.com/jeppevinkel/jellyfin-tizen-builds) option (Jellyfin / Jellyfin-TrueHD / Jellyfin-master / Jellyfin-master-TrueHD / Jellyfin-secondary) as second argument. By default, Jellyfin option is used.
    - (Optional) You can provide preferred [jellyfin-tizen-builds releases](https://github.com/jeppevinkel/jellyfin-tizen-builds/releases) release tag URL as third argument. By default, latest version is used. This is useful if you want to install older Jellyfin Tizen Client version.
    - (Optional) You can provide a custom Samsung certificate by mounting the `.p12` files at `/certificates/` and providing the certificate password as fourth argument.
   - If you do not want to use either of these options and just install the default build, do not put anything after the IP address.

```bash
docker run --rm ghcr.io/georift/install-jellyfin-tizen <samsung tv ip> [build option] [tag url] [certificate password]
```

Examples:

```bash
docker run --rm ghcr.io/georift/install-jellyfin-tizen 192.168.0.10 Jellyfin-TrueHD "https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/tag/2024-05-13-0139"
```

```bash
docker run --rm -v "$(pwd)/author.p12":/certificates/author.p12 -v "$(pwd)/distributor.p12":/certificates/distributor.p12 ghcr.io/georift/install-jellyfin-tizen 192.168.0.10 Jellyfin "" 'CertPassw0rd!' # Third argument empty to use latest tag
```

### Validating Success
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

At this point you can find Jellyfin on your TV by navigating to Apps -> Downloaded (scroll down), there you'll find Jellyfin.

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

- `install failed[118, -12], reason: Check certificate error : :Invalid certificate chain with certificate in signature.`

  Recent TV models require the installation packages to be signed with a custom certificate for your specific TV.

  See [official documentation](https://developer.samsung.com/smarttv/develop/getting-started/setting-up-sdk/creating-certificates.html) on creating your certificate and use the custom certificate arguments.

## Credits

This project is possible thanks to these projects:

- [jellyfin-tizen](https://github.com/jellyfin/jellyfin-tizen)
- [jeppevinkel/jellyfin-tizen-builds](https://github.com/jeppevinkel/jellyfin-tizen-builds) for providing development builds
- [vitalets/docker-tizen-webos-sdk](https://github.com/vitalets/docker-tizen-webos-sdk) for a docker container preinstalled with the Tizen SDK

## Similar Projects

Here are some similar projects we've been told of, links are provided here without
any endorsement for their quality.

- [PatrickSt1991/Samsung-Jellyfin-Installer](https://github.com/PatrickSt1991/Samsung-Jellyfin-Installer):
  * GUI based installed rather than Docker

Feel free to raise a PR with any additional projects.
