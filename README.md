# Install development builds of Jellyfin Tizen on your TV

This docker container will attempt to download the latest release
of [jellyfin-tizen](https://github.com/jellyfin/jellyfin-tizen) and
install it on the Samsung TV you specify.

Soon Jellyfin will hopefully [be on the Samsung TV app store](https://github.com/jellyfin/jellyfin-tizen/issues/94), but until
then this is a quick way to install the builds.

## Usage

1. [Ensure your Samsung TV is in developer mode](https://developer.samsung.com/smarttv/develop/getting-started/using-sdk/tv-device.html#Connecting-the-TV-and-SDK)
	- If you're having trouble, make sure you're using the "123" button on the remote when typing in "12345".
	
2. Run this command replacing the final argument with the IP of your Samsung TV

```bash
docker run --rm georift/install-jellyfin-tizen <samsung tv ip>
```

## Credits

Possible thanks to these projects, I just quickly packaged up all their work
into a single container:

- [jeppevinkel/jellyfin-tizen-builds](https://github.com/jeppevinkel/jellyfin-tizen-builds) for providing development builds
- [vitalets/docker-tizen-webos-sdk](https://github.com/vitalets/docker-tizen-webos-sdk) for a docker container preinstalled with the Tizen SDK