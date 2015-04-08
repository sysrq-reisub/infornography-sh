#!/bin/sh

setcolors() {
    if test "$COLORTERM" || test "${TERM#'*color'}" ; then
	COLOR=true
    else
	return
    fi
}

for arg in "$@"; do
    case "$arg" in
	"-c")
	    setcolors
	    ;;
    esac
done

OS="$(uname -s)"
VERS="$(uname -r)"

command -v acpi >/dev/null && \
BAT="battery: $(acpi | awk '{print $4}')"

case $OS in
    *BSD)
        CPU="$(sysctl -n hw.model)"
        UPTIME="$(uptime | awk '{gsub(/,/,"") print $3 $4)}')"
        MEM="$(top -n 1 -b | awk '/Memory/{print $3}')" 
        if test -z "$MEM"; then
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
        CPU="$(awk '/model name/{$1=$2=$3=""; print $0}' | uniq)"
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
                        ..........                        
                   ..''..'''''''''''..                    
                 .''''''''';:clooool:,''.                 
        .',:::,'''''''''cdO0000kc:clkOd:'''.              
       ''cO0Ol''''''''ck0000000Ol'..l000d,''.             
      .'.cO0l''''''',k000000000000OO00000O:'.             
       .'.,c'.....''x0000000kdlc:;;;;:okO0O;'.            
         ..........;O00Od:'.            .ckd'..           $USER@$(/bin/hostname)
          .........,xc'        .......    .,...           
          ..........     ................    ...          $OS
          ........     ......dxc...........   ..          $VERS
         ........   ...c...''0Xx:............. ..         $UPTIME
         ........  .;o.x,.,;c0Xkl;,..c.,...... ..         $CPU
         .......  .,ldcdloolo0XkOk0k:l:ll'...  .          
         .......  :O00xc::ckKXXKXXXKooloOOl.  ..          $MEM
         .....'d::c0XOOl;:xk0XXXXXXX0l,:k0c..',.          $BAT
        ........,dk0XXK0KXXXXXXXXXXXXK0O0k':cll           
        ......   .dKXXXXXXXXXXXXOKXXXXXX0,,llcc           $SHELL
        ....'      :0XXXXXXXXXXKO0XXXXKO, :lll:.          $TERM
       ....;l:c'.,.';o0XXXXXXXKKXXXXKOc.  :lllc'          
       ..'cllllllllllllox0XXXXXXXKOdlc;.  :llllc'         
      ..'clllllllllllllllcldkOOkdollll:...;lllllc'        
       .,llllllllllllllllllc;;ccccllllc...,llllllc,       
      ...cllllllllllllc:,.....:o...,:cc'..'ccccccc:       
     .....;cllllllll:'........'........'...cccccc,        
    ........,cclc:,........................:cc:,..        
  .................................................       
 ...................................................      
 ...............................c,..................      
................................c,...................     
.....................................................     
......................................................    
......................................................    
......................................................    
.................................',...................    
.................................,l....................   
   
EOF

unset MEM MEMF MEMT BAT CPU UPTIME VERS OS COLOR
