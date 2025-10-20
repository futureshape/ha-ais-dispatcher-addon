# AIS Dispatcher Home Assistant Add-on

This Home Assistant add-on packages the official [AIS Dispatcher](https://www.aishub.net/ais-dispatcher) utility, providing a web UI through Home Assistant ingress so you can manage AIS data forwarding without leaving the Supervisor panel.

## Features

- Ships the vendor provided AIS Dispatcher binaries for amd64, aarch64, and armv7
- Runs the AIS Dispatcher control UI behind Home Assistant ingress (no separate port exposure required)
- Persists configuration in the add-on data folder so settings survive upgrades
- Exposes USB/UART hardware to allow direct serial AIS receiver connections

## Getting Started

1. Add this repository to your Home Assistant add-on store (Supervisor ➜ Add-on Store ➜ "⋮" menu ➜ *Repositories*).
2. Install the **AIS Dispatcher** add-on.
3. Start the add-on and open the web UI via **Open Web UI** (ingress) or the left sidebar panel.
4. Sign in with the default credentials:
   - Username: `admin`
   - Password: `admin`

> **Important:** Change the default password immediately after the first login (Configuration ➜ Settings ➜ *Change password*).

## Configuration

The add-on exposes a single option:

| Option      | Description                                                  | Default |
|-------------|--------------------------------------------------------------|---------|
| `log_level` | Controls Supervisor log verbosity (`debug`, `info`, `warning`, `error`). | `info`  |

Serial and USB devices attached to the host are made available inside the container, allowing you to select the correct interface within AIS Dispatcher.

## Networking

The add-on relies on Home Assistant ingress and does not expose host ports directly. Internally, AIS Dispatcher listens on port `8080`; ingress handles routing and authentication. WebSocket access (port `8081`) is proxied automatically.

## Updates

On first start the add-on copies the vendor package into the persistent data directory. Subsequent add-on updates refresh the bundled binaries while preserving your configuration.

## Troubleshooting

- Check the Supervisor logs for entries tagged `AIS Dispatcher` to review startup progress.
- Ensure your AIS receiver appears under **View devices** in the AIS Dispatcher UI; if not, verify the device is passed through to the host.
- If the UI fails to load, restart the add-on to regenerate architecture-specific binaries.

## License

AIS Dispatcher is distributed by AISHub under their proprietary terms. This repository only packages the official binaries for use within Home Assistant.
