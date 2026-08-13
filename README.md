# NixOS Virtual Machine Setup Guide
<small> This is a pretty and easy to read guide, generated with AI, from my notes (because I'm not a writer)</small>

> **Environment Note:** This guide was performed and tested on **Linux Mint (Cinnamon)** using **Virt-Manager** (QEMU/KVM).

---

## 📋 Table of Contents
- [1. Prerequisites & Installation](#1-prerequisites--installation)
- [2. Virtual Machine Creation](#2-virtual-machine-creation)
- [3. NixOS Installation & Partitioning](#3-nixos-installation--partitioning)
- [4. Default Credentials](#4-default-credentials)
- [5. Post-Installation Configuration](#5-post-installation-configuration)
  - [Clipboard Sharing (SPICE Agent)](#clipboard-sharing-spice-agent)
- [6. Configuration Reference](#6-configuration-reference)

---

## 1. Prerequisites & Installation

Install **virt-manager** and its KVM/QEMU dependencies on your Linux Mint host:

```bash
sudo apt update
sudo apt install virt-manager qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
```

---

## 2. Virtual Machine Creation

Open Virtual Machine Manager (`virt-manager`) and create a new guest domain with the following resource allocations:

| Hardware Resource | Recommended Value |
| :--- | :--- |
| **OS Image / ISO** | Official NixOS Graphical ISO |
| **RAM** | `8000 MiB` (~8 GB) |
| **CPU Cores** | `3 vCPUs` |
| **Storage (Disk)** | `20 GB` |

---

## 3. NixOS Installation & Partitioning

1. **Boot Machine:** Power on the newly created VM and boot from the attached NixOS Graphical ISO.
2. **Disk Partitioning:** Select **Full Disk** automatic partitioning during the graphical installer setup.
3. **Finish Setup:** Complete the installation wizard and reboot the system into your fresh NixOS installation.

---

## 4. Default Credentials

The following initial user accounts were configured during installation:

| Username | Password | Privileges |
| :--- | :--- | :--- |
| `guest` | `guest` | Standard User |
| `root` | `root` | Superuser / Administrator |

> 💡 **Tip:** Log in as `root` directly for initial administrative configurations to omit typing `sudo` on every command.

---

## 5. Post-Installation Configuration

### Clipboard Sharing (SPICE Agent)

To enable seamless host-to-guest and guest-to-host clipboard sharing:

1. Log in as `root` and edit `/etc/nixos/configuration.nix`.
2. Add the `spice-vdagentd` service block inside your configuration file:

#### Single Line Syntax:
```nix
services.spice-vdagentd.enable = true;
```

#### Structured Syntax:
```nix
services = {
  spice-vdagentd.enable = true;
  # Additional service definitions can go here...
};
```

3. Apply the new NixOS system configuration:
```bash
nixos-rebuild switch
```

4. **Virt-Manager Host Setting:**
   - Power off the VM.
   - Open **Virtual Machine Details** (`i` icon).
   - Navigate to **Display Spice** $
ightarrow$ **Type** and verify it is set to **Spice server**.
   - Power on the VM. Guest-host clipboard sharing is now active.

---

## 6. Configuration Reference

For full module details and complete declarative setup files, refer to:
- `files/configuration.nix`
