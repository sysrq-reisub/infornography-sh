#!/bin/sh

OS="$(uname -s)"
VERS="$(uname -r)"

command -v acpi &> /dev/null && \
BAT="battery: $(acpi | awk '{print $4}')"


case $OS in
	
	*BSD)
		CPU="$(sysctl -n hw.model)"
		UPTIME="$(uptime | awk '{gsub(/,/,"") print $3 $4)}')"
		MEM="$(top -n 1 -b | awk '/Memory/{print $3}')" # fix this	
		;;
	*Linux)
		CPU="$(uname -p)"
		UPTIME="$(awk '{print int($1/3600)}' /proc/uptime) hours up"
		MEMF="$(awk '/MemAvailable/{print int($2/10^3)}' /proc/meminfo)"
		MEMT="$(awk '/MemTotal/{print int($2/10^3)}' /proc/meminfo)"
		MEM="$(( MEMT-MEMF ))/${MEMT}M"
		;;
	*)
		;;
esac

cat << EOF
                   .      .             
              .               .           
                                 .       
          .                             	$USER@$(/bin/hostname)
                                    .   	
        .              ...xc. .         	$OS
        .            '.kdlKOl.;;.    .  	$VERS
        .         ..,koxdokKKkkOc.  ..  	$UPTIME
         \/.'c... ,xOKxdlxOKXKK0xl..    	$CPU	
         /\.dxdoxk0KKkO:.oXXXXK:,;      	
         .  .doxKXXXXX000XXXXXKxd'      	$MEM
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
