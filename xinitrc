#!/bin/sh
(conky | while read LINE; do xsetroot -name "$LINE"; done) &
exec dwm
