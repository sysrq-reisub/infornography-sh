#!/bin/sh

if [ "$COLORTERM" ] || [ "${TERM#'*color'}" ]; then
    COLOR=true
fi

OS="$(uname -s)"
VERS="$(uname -r)"

command -v acpi >/dev/null && \
BAT="battery: $(acpi | awk '{print $4}')"

case $OS in
    *BSD)
        CPU="$(sysctl -n hw.model)"
        UPTIME="$(uptime | awk '{gsub(/,/,"") print $3 $4)}')"
        MEM="$(top -n 1 -b | awk '/Memory/{print $3}')" 
        if test -z $MEM; then
            if test -f /proc/meminfo; then
                MEMF="$(awk '/MemFree/{print int($2/10^3)}' /proc/meminfo)"
                MEMT="$(awk '/MemTotal/{print int($2/10^3)}' /proc/meminfo)"
                MEM="$(( MEMT-MEMF ))/${MEMT}M"
            else
                MEMT="$(vmstat -h | awk 'NR==3{print $4}')"
                MEMF="$(vmstat -h | awk 'NR==3{gsub(/M/,""); print $5}')"
                MEM="$MEMF/$MEMT"
            fi
        fi
        ;;
    *Linux)
        CPU="$(uname -p)"
        UPTIME="$(awk '{print int($1/3600)}' /proc/uptime) hours up"
        MEMF="$(awk '/MemAvailable/{print int($2/10^3)}' /proc/meminfo)"
        if test -z "$MEMF"; then
            MEMF="$(awk '/MemFree/{print int($2/10^3)}' /proc/meminfo)"
        fi
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
          .                                 $USER@$(/bin/hostname)
                                    .       
        .              ...xc. .             $OS
        .            '.kdlKOl.;;.    .      $VERS
        .         ..,koxdokKKkkOc.  ..      $UPTIME
         \/.'c... ,xOKxdlxOKXKK0xl..        $CPU    
         /\.dxdoxk0KKkO:.oXXXXK:,;          
         .  .doxKXXXXX000XXXXXKxd'          $MEM
              .l0XXXXXXXXXXX00OXK.          $BAT
              .xdOKXXXXXXXXK0KKK:           
              :xxxk0KXXXXXXKKKd.            $SHELL
         .;;,:xxxxxxdxOKXXXKo'              $TERM 
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
