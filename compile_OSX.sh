#!/bin/sh
echo "Compiling Axes, Armour & Ale..."
'/usr/local/bin/fpc' ascii_axe.lpr -Mfpc -Schi -CX -Os4 -XX -veibq -vw-n-h- -Filib/x86_64-darwin -Fuscreens -Fudungeons -Fuplayer -Fuvision -Fuentities -Fuitems -Fuitems/weapons -Fuitems/armour -Fuentities/hobs -Fu. -FUlib/x86_64-darwin -FE. -oAxes
echo "Complete."