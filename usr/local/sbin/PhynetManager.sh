#!/usr/bin/sh

wireless_interface="$(find /sys/class/net -follow -maxdepth 2 -name wireless 2>/dev/null | cut -d / -f 5)";
if [ -f /etc/systemd/system/multi-user.target.wants/PhynetManager@${wireless_interface}.service ];then
    exit 0;
fi
echo "[Unit]
Description=Future Tech Labs(FTL) - PhyOS Network Manager Wireless Interface Instance
Wants=network.target
Before=network.target
BindsTo=sys-subsystem-net-devices-%i.device
After=sys-subsystem-net-devices-%i.device

[Service]
Type=oneshot
RemainAfterExit=yes

#ExecStart=/usr/sbin/ip link set dev %i up
ExecStart=/usr/sbin/wpa_supplicant -B -i %i -c /etc/wpa_supplicant/wpa_supplicant.conf
#ExecStart=/usr/sbin/dhclient %i

ExecStop=/usr/sbin/ip link set dev %i down

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/PhynetManager@.service;
ln -s /etc/systemd/system/PhynetManager@.service \
    /etc/systemd/system/multi-user.target.wants/PhynetManager@${wireless_interface}.service;
systemctl enable PhynetManager@${wireless_interface}.service;
systemctl daemon-reload;
systemctl start PhynetManager@${wireless_interface}.service;
