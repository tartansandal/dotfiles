#!/usr/bin/bash

# VM writeback timeout
echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs'

# Enable SATA link power management for host1
echo 'med_power_with_dipm' > '/sys/class/scsi_host/host1/link_power_management_policy'

# Enable SATA link power management for host2
echo 'med_power_with_dipm' > '/sys/class/scsi_host/host2/link_power_management_policy'

# Enable SATA link power management for host0
echo 'med_power_with_dipm' > '/sys/class/scsi_host/host0/link_power_management_policy'

# Enable Audio codec power management
echo '1' > '/sys/module/snd_hda_intel/parameters/power_save'

# NMI watchdog should be turned off
echo '0' > '/proc/sys/kernel/nmi_watchdog'

# Runtime PM for I2C Adapter i2c-4 (i915 gmbus misc)
echo 'auto' > '/sys/bus/i2c/devices/i2c-4/device/power/control'

# Autosuspend for USB device USB Receiver [Logitech]
echo 'auto' > '/sys/bus/usb/devices/1-2/power/control'

# Runtime PM for I2C Adapter i2c-2 (i915 gmbus dpb)
echo 'auto' > '/sys/bus/i2c/devices/i2c-2/device/power/control'

# Runtime PM for I2C Adapter i2c-3 (i915 gmbus dpc)
echo 'auto' > '/sys/bus/i2c/devices/i2c-3/device/power/control'

# Runtime PM for I2C Adapter i2c-5 (i915 gmbus dpd)
echo 'auto' > '/sys/bus/i2c/devices/i2c-5/device/power/control'

# Runtime PM for port ata2 of PCI device: Intel Corporation Cannon Lake Mobile PCH SATA AHCI Controller
echo 'auto' > '/sys/bus/pci/devices/0000:00:17.0/ata2/power/control'

# Runtime PM for PCI Device Intel Corporation Cannon Lake PCH USB 3.1 xHCI Host Controller
echo 'auto' > '/sys/bus/pci/devices/0000:00:14.0/power/control'

# Runtime PM for PCI Device Intel Corporation CoffeeLake-H GT2 [UHD Graphics 630]
echo 'auto' > '/sys/bus/pci/devices/0000:00:02.0/power/control'

# Runtime PM for port ata1 of PCI device: Intel Corporation Cannon Lake Mobile PCH SATA AHCI Controller
echo 'auto' > '/sys/bus/pci/devices/0000:00:17.0/ata1/power/control'

# Runtime PM for PCI Device Intel Corporation Cannon Lake LPC Controller
echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.0/power/control'

# Runtime PM for PCI Device Intel Corporation Cannon Lake PCH Shared SRAM
echo 'auto' > '/sys/bus/pci/devices/0000:00:14.2/power/control'

# Runtime PM for PCI Device Intel Corporation SSD Pro 7600p/760p/E 6100p Series
echo 'auto' > '/sys/bus/pci/devices/0000:3d:00.0/power/control'

# Runtime PM for PCI Device Intel Corporation Cannon Lake PCH SPI Controller
echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.5/power/control'

# Runtime PM for PCI Device Intel Corporation Wi-Fi 6 AX200
echo 'auto' > '/sys/bus/pci/devices/0000:3b:00.0/power/control'

# Runtime PM for port ata3 of PCI device: Intel Corporation Cannon Lake Mobile PCH SATA AHCI Controller
echo 'auto' > '/sys/bus/pci/devices/0000:00:17.0/ata3/power/control'

# Runtime PM for PCI Device Intel Corporation Cannon Lake Mobile PCH SATA AHCI Controller
echo 'auto' > '/sys/bus/pci/devices/0000:00:17.0/power/control'

# Runtime PM for PCI Device Intel Corporation Cannon Lake PCH Thermal Controller
echo 'auto' > '/sys/bus/pci/devices/0000:00:12.0/power/control'

# Runtime PM for PCI Device Intel Corporation 8th Gen Core Processor Host Bridge/DRAM Registers
echo 'auto' > '/sys/bus/pci/devices/0000:00:00.0/power/control'

# Wake-on-lan status for device wlp59s0
echo 'enabled' > '/sys/class/net/wlp59s0/device/power/wakeup'

# Wake status for USB device usb3
echo 'enabled' > '/sys/bus/usb/devices/usb3/power/wakeup'

# Wake status for USB device 1-7
echo 'enabled' > '/sys/bus/usb/devices/1-7/power/wakeup'

# Wake status for USB device usb1
echo 'enabled' > '/sys/bus/usb/devices/usb1/power/wakeup'

# Wake status for USB device usb4
echo 'enabled' > '/sys/bus/usb/devices/usb4/power/wakeup'

# Wake status for USB device usb2
echo 'enabled' > '/sys/bus/usb/devices/usb2/power/wakeup'

# Wake status for USB device 1-4
echo 'enabled' > '/sys/bus/usb/devices/1-4/power/wakeup'

