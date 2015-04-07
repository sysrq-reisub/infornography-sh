#!/bin/sh

OS="$(uname -o)"
UPTIME="$(uptime | awk '{gsub(/,/,""); print $3, $4}')"
KERN="$(uname -s -r)"

if test acpi; then
BAT="battery: $(acpi | awk '{print $4}')"
fi

case $OS in
	
	*BSD)
		CPU="$(sysctl -n hw.model)"
		MEM="$(top -n 1 -b | awk '/KiB Mem/{print int($5/10^3),"/",int($3/10^3)}')"	
		;;
	*Linux)
		CPU="$(uname -p)"
		MEMF="$(cat /proc/meminfo | awk '/MemAvailable/{print int($2/10^3)}')"
		MEMT="$(cat /proc/meminfo | awk '/MemTotal/{print int($2/10^3)}')"
		MEM="$(( MEMT-MEMF )) / $MEMT"
		;;
	*)
		;;
esac

cat << EOF
                   .      .             
              .               .           
                                 .       
          .                             	$USER@$HOSTNAME 
                                    .   	
        .              ...xc. .         	$OS
        .            '.kdlKOl.;;.    .  	$UPTIME
        .         ..,koxdokKKkkOc.  ..  	$KERN
         \/.'c... ,xOKxdlxOKXKK0xl..    	$CPU	
         /\.dxdoxk0KKkO:.oXXXXK:,;      	
         .  .doxKXXXXX000XXXXXKxd'      	$MEM MB
              .l0XXXXXXXXXXX00OXK.      	$BAT
              .xdOKXXXXXXXXK0KKK:       	
              :xxxk0KXXXXXXKKKd.        	$SHELL
         .;;,:xxxxxxdxOKXXXKo'         		$TERM 
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
