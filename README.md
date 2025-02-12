# Install Jellyfin for Samsung TV

This project simplifies the installation of [Jellyfin for Samsung TV](https://github.com/jellyfin/jellyfin-tizen) by automating the environment setup using Docker.

Samsung TVs have been using Tizen OS since 2015. While the Jellyfin app is stable and officially supported, [it has not been available in the Samsung App Store since 2021](https://github.com/jellyfin/jellyfin-tizen/issues/94).

With this script, you can install Jellyfin with just one command once your computer and TV are properly configured.

---

## Prerequisites

### 1. Prepare Your Computer
- [Install Docker](https://www.docker.com/get-started)
- If necessary, [enable virtualization](https://support.microsoft.com/en-us/windows/enable-virtualization-on-windows-11-pcs-c5578302-6e43-4b4b-a449-8ced115f58e1)
- Ensure that your computer is on the same network as your Samsung TV

### 2. Configure Your Samsung TV

#### a) Enable Developer Mode

> **Note:** If your TV uses a right-to-left language (e.g., Arabic or Hebrew), the IP address must be entered in reverse order. [More info here.](https://github.com/Georift/install-jellyfin-tizen/issues/30)

1. On your TV, go to "Apps".
2. Scroll down to "App Settings" and open it.
3. Enter "12345" using the virtual keyboard.
4. Enable Developer Mode (**On**).
5. Enter your computer's IP address.

If you experience issues entering the IP address:
- Use an external Bluetooth keyboard.
- Use the Samsung SmartThings app to enter the IP via the virtual keyboard.

#### b) Uninstall Previous Jellyfin Versions
If Jellyfin is already installed, [follow the official uninstallation guide](https://www.samsung.com/in/support/tv-audio-video/how-to-uninstall-an-app-on-samsung-smart-tv/).

#### c) Find Your TV’s IP Address
1. Open the network settings or "About This TV".
2. Note down the IP address as it will be needed later.

---

## Install Jellyfin

### Installation Command
Use the following command to install Jellyfin. Replace the placeholders accordingly:

```bash
docker run --rm ghcr.io/georift/install-jellyfin-tizen --ip <TV_IP> [--build <BUILD_OPTION>] [--tag <TAG_URL>] [--oneui8 --device-id <DEVICE_ID> --email <EMAIL>] [--cert-password <PASSWORD>]
```

### Arguments
- `--ip <TV_IP>` → IP address of the Samsung TV (**required**)
- `--build <BUILD_OPTION>` → Choose a build option (default: `Jellyfin` available: `Jellyfin, Jellyfin-TrueHD, Jellyfin-master, Jellyfin-master-TrueHD, Jellyfin-secondary`)
- `--tag <TAG_URL>` → URL of the release tag (optional, uses the latest version if not specified)
- `--oneui8` → Enables One UI 8 mode (see section below)
- `--device-id <DEVICE_ID>` → Device ID (required for `--oneui8`)
- `--email <EMAIL>` → Email address (required for `--oneui8`)
- `--cert-password <PASSWORD>` → Certificate password (optional)

### Examples

#### Standard Installation with the Latest Version:
```bash
docker run --rm ghcr.io/georift/install-jellyfin-tizen --ip 192.168.0.10
```

#### Install a Specific Version with TrueHD Support:
```bash
docker run --rm ghcr.io/georift/install-jellyfin-tizen --ip 192.168.0.10 --build Jellyfin-TrueHD --tag "https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/tag/2024-05-13-0139"
```

#### Install with a Custom Certificate:
```bash
docker run --rm -v "$(pwd)/author.p12":/certificates/author.p12 -v "$(pwd)/distributor.p12":/certificates/distributor.p12 ghcr.io/georift/install-jellyfin-tizen --ip 192.168.0.10 --cert-password 'CertPassw0rd!'
```

### Installation for One UI 8
If your TV uses One UI 8, follow these steps:

```bash
docker run -p 4794:4794 ghcr.io/georift/install-jellyfin-tizen --ip 192.168.0.10 --oneui8 --device-id GU43CU7179UXZG --email none@none.com
```

0. The starting process of the certificate generation script can take a while, so be patient.
1. Open `localhost:4794/auth/start` in your browser.
2. Follow the instructions on the webpage.
3. Wait for the installation to complete.

---

## Verify Installation

### Common Errors & Solutions

- **Error:** `library initialization failed - unable to allocate file descriptor table - out of memory`
  - **Solution:** Add `--ulimit nofile=1024:65536`:
    ```bash
    docker run --ulimit nofile=1024:65536 --rm ghcr.io/georift/install-jellyfin-tizen --ip 192.168.0.10
    ```

- **Error:** `install failed[118, -11], reason: Author certificate not match`
  - **Solution:** Uninstall the Jellyfin app and try again.

- **Error:** `install failed[118, -12], reason: Check certificate error: Invalid certificate chain`
  - **Solution:** Use a custom certificate as described [here](https://developer.samsung.com/smarttv/develop/getting-started/setting-up-sdk/creating-certificates.html).

### Successful Installation
If the installation is successful, you will see this message:
```txt
Installed the package: Id(AprZAARz4r.Jellyfin)
Tizen application is successfully installed.
Total time: 00:00:12.205
```

Jellyfin should now be available under `Apps -> Downloaded` on your TV.

---

## Supported Platforms

Currently, **amd64** is supported. ARM devices (such as Raspberry Pi or Mac M1/M2) require additional configuration.

### Installation on ARM (Mac M-Chips)
1. Enable the "Virtualization Framework".
2. Ensure that Docker supports `qemu`:
   ```bash
   docker run --rm --platform linux/amd64 alpine uname -m
   ```
   If `x86_64` is returned, everything is set up correctly.
3. Use `--platform linux/amd64`:
   ```bash
   docker run --rm --platform linux/amd64 ghcr.io/georift/install-jellyfin-tizen --ip 192.168.0.10
   ```

---

## Acknowledgments
This project would not be possible without the following:

- [jellyfin-tizen](https://github.com/jellyfin/jellyfin-tizen)
- [jeppevinkel/jellyfin-tizen-builds](https://github.com/jeppevinkel/jellyfin-tizen-builds)
- [vitalets/docker-tizen-webos-sdk](https://github.com/vitalets/docker-tizen-webos-sdk)
- [tizencertificates](https://github.com/sreyemnayr/tizencertificates)

