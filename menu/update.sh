#!/bin/bash
clear
readonly SERVER_HOST="https://raw.githubusercontent.com/imrantech237/IMRAN-TECH-VPS/main"
export LN='\e[34m'
export BG='\e[44m'
export NC='\e[0m'
export GR='\e[32m'
export RD='\e[31m'
# Auto-mise à jour de update.sh lui-même
wget -q -O /usr/local/sbin/update "${SERVER_HOST}/menu/update.sh" && chmod +x /usr/local/sbin/update

echo -e "${LN}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
echo -e "${LN}┃${NC} ${BG}          UPDATE  🜲 IMRAN_TECH PANEL           ${NC} ${LN}┃${NC}"
echo -e "${LN}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
echo -e "${LN}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"

success=0
failed=0

# Mise à jour dynamique de tous les scripts .sh du dossier menu
echo -e "${LN}┃${NC} [*] Fetching available scripts list from GitHub...${NC}"
script_list=$(wget -q -O - "${SERVER_HOST}/menu/" | grep -oE 'href="[^"]+\.sh"' | sed 's/href="//;s/\.sh"//' | sort -u)

if [ -z "$script_list" ]; then
    echo -e "${LN}┃${NC}     ⚠️  Could not fetch script list, using fallback list${NC}"
    script_list="dns domain expiry iptools menu socks ssh status trojan vless vmess netguard port log zivpn imran_bot_panel"
fi

for script in $script_list; do
    url="${SERVER_HOST}/menu/${script}.sh"
    dest="/usr/local/sbin/$script"
    echo -e "${LN}┃${NC} [*] Update $script, please wait ..."
    if wget -q -O "$dest" "$url" && chmod +x "$dest"; then
        echo -e "${LN}┃${NC}     ✅ Success"
        ((success++))
    else
        echo -e "${LN}┃${NC}     ❌ Failed"
        ((failed++))
    fi
done

# Mise à jour du bot Telegram
echo -e "${LN}┃${NC} [*] Update Telegram Bot (ppsbot.py), please wait ..."
if wget -q -O /etc/imran_bot/ppsbot.py "${SERVER_HOST}/menu/ppsbot.py"; then
    chmod +x /etc/imran_bot/imranbot.py
    echo -e "${LN}┃${NC}     ✅ Success"
    ((success++))
else
    echo -e "${LN}┃${NC}     ❌ Failed"
    ((failed++))
fi

# Mise à jour des modules Python du bot
echo -e "${LN}┃${NC} [*] Update bot Python modules, please wait ..."
mkdir -p /etc/imran_bot/modules
for module in __init__ system_core ssh_core admin_core xray_core zivpn_core; do
    if wget -q -O "/etc/imran_bot/modules/${module}.py" "${SERVER_HOST}/module/${module}.py"; then
        chmod +x "/etc/imran_bot/modules/${module}.py"
        echo -e "${LN}┃${NC}     ✅ ${module}.py updated"
        ((success++))
    else
        echo -e "${LN}┃${NC}     ❌ ${module}.py failed"
        ((failed++))
    fi
done

# Mise à jour du désinstallateur
echo -e "${LN}┃${NC} [*] Update uninstaller, please wait ..."
if wget -q -O /usr/local/sbin/uninstall "${SERVER_HOST}/menu/uninstall.sh"; then
    chmod +x /usr/local/sbin/uninstall
    echo -e "${LN}┃${NC}     ✅ Success"
    ((success++))
else
    echo -e "${LN}┃${NC}     ❌ Failed"
    ((failed++))
fi

# Mise à jour du banner SSH (issue.net)
echo -e "${LN}┃${NC} [*] Update issue.net (SSH banner), please wait ...${NC}"
if wget -q -O /etc/issue.net "${SERVER_HOST}/module/issue.net"; then
    echo -e "${LN}┃${NC}     ✅ Success"
    ((success++))
else
    echo -e "${LN}┃${NC}     ❌ Failed"
    ((failed++))
fi

# Mise à jour de l'info des ports
echo -e "${LN}┃${NC} [*] Update port info, please wait ...${NC}"
if wget -q -O /etc/xray/port_info "$SERVER_HOST/port_info"; then
    echo -e "${LN}┃${NC}     ✅ Success"
    ((success++))
else
    echo -e "${LN}┃${NC}     ❌ Failed"
    ((failed++))
fi

# Mise à jour du fichier de version
echo -e "${LN}┃${NC} [*] Update version file, please wait ...${NC}"
if wget -q -O /etc/version "$SERVER_HOST/version"; then
    echo -e "${LN}┃${NC}     ✅ Success"
    ((success++))
else
    echo -e "${LN}┃${NC}     ❌ Failed"
    ((failed++))
fi

# Résumé final
echo -e "${LN}┃${NC}"
if [ $failed -eq 0 ]; then
    echo -e "${LN}┃${NC} [*] Update successfully ☑️ ($success files updated)"
else
    echo -e "${LN}┃${NC} [*] Update finished with errors ($success ok, $failed failed)"
fi
echo -e "${LN}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
echo -e "${LN}●━━━━━━━━━━━━━━━━━━━━🜲IMRAN_TECH━━━━━━━━━━━━━━━━━━━━●${NC}"
echo ""
sleep 4
parent=$(basename $(ps -f -p $PPID | tail -1 | awk '{print $NF}'))
[[ "$parent" != "imran.sh" ]] && menu
