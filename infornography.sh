#!/bin/sh

OS="$(uname -o)"
UPTIME="$(uptime | awk '{gsub(/,/,""); print $3, $4}')"
KERN="$(uname -s -r)"
CPU="$(uname -p)"

if test acpi; then
BAT="battery: $(acpi | awk '{print $4}')"
fi

MEMF="$(cat /proc/meminfo | grep '^MemAvailable' | awk '{print int($2/10^3)}')"
MEMT="$(cat /proc/meminfo | grep '^MemTotal' | awk '{print int($2/10^3)}')"

cat << EOF
                   .      .             
              .               .           
                                 .       
          .                              
                                    .   	$OS
        .              ...xc. .         	$UPTIME
        .            '.kdlKOl.;;.    .  	$KERN
        .         ..,koxdokKKkkOc.  ..  	$CPU	
         \/.'c... ,xOKxdlxOKXKK0xl..    	
         /\.dxdoxk0KKkO:.oXXXXK:,;      	$(( MEMT-MEMF ))/$MEMT MB
         .  .doxKXXXXX000XXXXXKxd'      	$BAT
              .l0XXXXXXXXXXX00OXK.      	
              .xdOKXXXXXXXXK0KKK:       	$SHELL
              :xxxk0KXXXXXXKKKd.        	$TERM
         .;;,:xxxxxxdxOKXXXKo'          
       .;llccdxxxxxxxxlc;,,.            
     'ooloxxdoldxxxxxxocx:..            
    ;kOOkkkOOkxoldxxxxk0kOk: ....'...   
   .xc'',;:codkOkdl;,,::xOx;.,;,'cxdc   
   ............,:lxd'   xx'..','',;;o.  
   ................':: .:....l0ooxkkk,  
  ..........................,xKK0xkOOl  
  ............................'dxoO0OO. 
  ..............................:codx0. 
 ............. ............... ..cddxk' 
 .............. ..............   lxdc'. 
 ..............................  .,.....
...............................  .......

EOF
