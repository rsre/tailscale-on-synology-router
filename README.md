# Tailscale on Synology router

Download the [latest version for DSM7 ARMv8](https://pkgs.tailscale.com/stable/#spks).

Extract the files and again extract the files `tailscale` and `tailscaled` from `package.tzg`.

Copy `tailscale`, `tailscaled` and `tailscale.sh` to the router. You can use `scp -O` or any other tool.

SSH into the router and copy the binaries to their final destinations:
```sh
sudo mkdir /usr/local/bin/
sudo cp tailscale /usr/local/bin/
sudo cp tailscaled /usr/local/bin/
```

Copy the control script and make it executable:
```sh
sudo cp tailscale.sh /usr/local/etc/rc.d/tailscale.sh
sudo chmod +x /usr/local/etc/rc.d/tailscale.sh
```

Test the script works and start the service:
```sh
sudo /usr/local/etc/rc.d/tailscale.sh start
```

The first time you will need to copy a link and sign into Tailscale on a browser to start the service. You can find the link in the logs at `/var/log/tailscale.log`.
Check "Machines" in your Tailscale account to make sure the router was added. Edit the router's Route Settings to enable "Subset routes" and "Exit node".

Reboot and check tailscale is automatically started afterwards:
```sh
sudo reboot
```

```sh
tailscale status
```

# Uncharted territories

## Updates
The binaries or the script might dissapear after an SRM upgrade. I copied them to a USB drive on the router so I can have them easily accesible in this case.

## Accept routes

> --accept-routes is not supported on Synology; see https://github.com/tailscale/tailscale/issues/1995

## Updates

Tailscale updates do not work, you will need to replace the binaries manually.

```sh
$ sudo tailscale update
cannot find Synology package for os=dsm0 arch=armv8, please report a bug with your device model
```

# Acknowledgements
This guide was created based on an answer by user `Shelnian` in [this](https://www.reddit.com/r/Tailscale/comments/1f6qq7m/can_you_install_tailscale_client_on_synology/) reddit thread.
