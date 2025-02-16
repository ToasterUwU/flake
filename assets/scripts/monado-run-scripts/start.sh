#! /usr/bin/env bash
systemctl --user restart monado.service monado.socket
wlx-overlay-s --replace &
journalctl --user --follow --unit monado.service