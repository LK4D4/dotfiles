#!/bin/sh
(conky | while read LINE; do xsetroot -name "$LINE"; done) &
eval $(ssh-agent)
exec dwm
