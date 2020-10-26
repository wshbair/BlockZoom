
ReconfigureMiningNodes()
{
    clear
    header
    printf " ${Purple}E X P E R E M E N T  R E - C O N F I G U R A T I O N  -  M E N U ${NC}\n"
	echo "------------------------------------------------------------------------"
    printf "${Yellow}Nodes act as miners ${NC}\n"
    echo "--------------------------------------"
    count=1
    filename="nodes.txt"
    for host in `cat $filename`; do
        ismining=$(ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/ismining.sh 2> /dev/null 2>&1 &)        
        if [ "${ismining:7}" = "true" ]; then
        printf "> ${Cyan} Node #$count ${NC} |  $host | Mining: ${GRN} ${ismining:7} ${NC}\n"
        echo   "------------------------------------------------------------------"
        fi
        ((count++))     
    done
    local choice
    count=1
    echo "Rconfiguration Options"
    echo "-----------------------------"
    printf "1. Turn ${Red}OFF${NC} a mining node\n"
    printf "2. Turn ${Red}OFF${NC} all mining nodes\n"
    printf "3. Back to main menu\n "
    read -p "Enter choice [ 1 - 3] " choice 
    case $choice in
		1) TurnOFFNode ;;
		2) TurnOFFAllNodes ;;
		3) Reconfigure;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
		
	esac
}
######################################################################################
TurnOFFNode()
{
    clear
    header
    printf " ${Purple}E X P E R E M E N T  R E - C O N F I G U R A T I O N  -  M E N U ${NC}\n"
	echo "------------------------------------------------------------------------"
    printf "${Yellow}Nodes act as miners ${NC}\n"
    echo "--------------------------------------"
    
    count=1
    filename="nodes.txt"
    for host in `cat $filename`; do
        ismining=$(ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/ismining.sh 2> /dev/null 2>&1 &)        
        if [ "${ismining:7}" = "true" ]; then
        printf "> ${Cyan} Node #$count ${NC} |  $host | Mining: ${GRN} ${ismining:7} ${NC}\n"
        echo   "------------------------------------------------------------------"
        fi
        ((count++))     
    done
    printf "\n"
    count=1
    local x
    read -p "Enter node ID to STOP Mining:  " x 
    printf "Working ...\n"
    for host in `cat $filename`; do
        if [ $x = $count ]; then
        nohup ssh  -oStrictHostKeyChecking=no root@$host pkill geth  </dev/null >nohup.out 2>nohup.err &
        sleep 5
        nohup ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/console.sh </dev/null >nohup.out 2>nohup.err &
        echo   "------------------------------------------------------------------"
        printf "> ${Cyan} Node #$count ${NC} |  $host | Mining: ${Red}Stoped${NC}\n"
        echo   "------------------------------------------------------------------"
        fi
        ((count++))     
    done
    read -p "Press any key to return to main menu ..."
    Reconfigure
     
}
######################################################################################
TurnOFFAllNodes()
{   clear
    header
    printf " ${Purple}E X P E R E M E N T  R E - C O N F I G U R A T I O N  -  M E N U ${NC}\n"
	echo "------------------------------------------------------------------------"
    printf "${Yellow}Nodes act as miners ${NC}\n"
    echo "--------------------------------------"
    
    count=1
    filename="nodes.txt"
    for host in `cat $filename`; do
        ismining=$(ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/ismining.sh 2> /dev/null 2>&1 &)        
        if [ "${ismining:7}" = "true" ]; then
        printf "> ${Cyan} Node #$count ${NC} |  $host | Mining: ${GRN} ${ismining:7} ${NC}\n"
        echo   "------------------------------------------------------------------"
        fi
        ((count++))     
    done
    printf "Working ...\n"
    local choice
    count=1
    filename="nodes.txt"    
    for host in `cat $filename`; do
        nohup ssh  -oStrictHostKeyChecking=no root@$host pkill geth  </dev/null >nohup.out 2>nohup.err &
        sleep 5
        nohup ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/console.sh </dev/null >nohup.out 2>nohup.err &
        printf "> ${Cyan} Node #$count ${NC} | $host | Mining: ${Red}Stoped${NC}\n"
        echo   "------------------------------------------------------------------"
        ((count++))     
    done
    read -p "Press any key to return to main menu ..."
    Reconfigure
}
######################################################################################
ReconfigureTxNodes()
{
    clear
    header
    printf " ${Purple}E X P E R E M E N T  R E - C O N F I G U R A T I O N  -  M E N U ${NC}\n"
	echo "------------------------------------------------------------------------"
    printf "${Yellow}Nodes act as transaction senders${NC}\n"
    echo "--------------------------------------"
    count=1
    filename="nodes.txt"
    for host in `cat $filename`; do
        ismining=$(ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/ismining.sh 2> /dev/null 2>&1 &)        
        if [ "${ismining:7}" = "false" ]; then
        printf "> ${Cyan} Node #$count ${NC} |  $host | Mining: ${Red} ${ismining:7} ${NC}\n"
        echo   "------------------------------------------------------------------"
        fi
        ((count++))     
    done
    local choice
    echo "Rconfiguration Options"
    echo "-----------------------------"
    printf "1. Turn ${GRN}ON${NC} a node to a mining mode \n"
    printf "2. Turn ${GRN}ON${NC} all nodes to a mining mode\n"
    printf "3. Back to main menu\n"
    read -p "Enter choice [ 1 - 3] " choice 
    case $choice in
		1) TurnONNode ;;
		2) TurnONAllNodes ;;
		3) Reconfigure;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
		
	esac
     
}
######################################################################################
TurnONNode()
{   
    clear
    header
    printf " ${Purple}E X P E R E M E N T  R E - C O N F I G U R A T I O N  -  M E N U ${NC}\n"
	echo "------------------------------------------------------------------------"
    printf "${Yellow}Nodes act as transaction senders${NC}\n"
    echo "--------------------------------------"
    count=1
    filename="nodes.txt"
    for host in `cat $filename`; do
        ismining=$(ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/ismining.sh 2> /dev/null 2>&1 &)        
        if [ "${ismining:7}" = "false" ]; then
        printf "> ${Cyan} Node #$count ${NC} |  $host | Mining: ${Red} ${ismining:7} ${NC}\n"
        echo   "------------------------------------------------------------------"
        fi
        ((count++))     
    done
    local choice
    count=1
    filename="nodes.txt"
    read -p "Enter node ID to run in a mining mode " choice
    printf "Working ...\n"
    for host in `cat $filename`; do
        if [ $choice = $count ]; then
        nohup ssh  -oStrictHostKeyChecking=no root@$host pkill geth  </dev/null >nohup.out 2>nohup.err &
        sleep 5
        nohup ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/mining.sh </dev/null >nohup.out 2>nohup.err &
        printf "> ${Cyan} Node #$count ${NC} |  $host | Mining: ${GRN}STARTED${NC}\n"
        echo   "------------------------------------------------------------------"
        fi
        ((count++))     
    done

    read -p "Press any key to return to main menu ..."
    Reconfigure
}

######################################################################################
TurnONAllNodes()
{
     clear
    header
    printf " ${Purple}E X P E R E M E N T  R E - C O N F I G U R A T I O N  -  M E N U ${NC}\n"
	echo "------------------------------------------------------------------------"
    printf "${Yellow}Nodes act as transaction senders${NC}\n"
    echo "--------------------------------------"
    count=1
    filename="nodes.txt"
    for host in `cat $filename`; do
        ismining=$(ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/ismining.sh 2> /dev/null 2>&1 &)        
        if [ "${ismining:7}" = "false" ]; then
        printf "> ${Cyan} Node #$count ${NC} |  $host | Mining: ${Red} ${ismining:7} ${NC}\n"
        echo   "------------------------------------------------------------------"
        fi
        ((count++))     
    done
    printf "Working ...\n"
    local choice
    count=1
    filename="nodes.txt"    
    for host in `cat $filename`; do
        nohup ssh  -oStrictHostKeyChecking=no root@$host pkill geth  </dev/null >nohup.out 2>nohup.err &
        sleep 5
        nohup ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/mining.sh </dev/null >nohup.out 2>nohup.err &
        printf "> ${Cyan} Node #$count ${NC} | $host | Mining: ${GRN}STARTED${NC}\n"
        echo   "------------------------------------------------------------------"
        ((count++))     
    done
    read -p "Press any key to return to main menu ..."
    Reconfigure
}
######################################################################################

ConfigureGensisFile()
{
    clear
    header
    printf " ${Purple}G E N I S I S  F I L E  C O N F I G U R A T I O N  -  M E N U ${NC}\n"
	echo "------------------------------------------------------------------------"
    printf "${Yellow}Gensis File configuration Options${NC}\n"
    echo "--------------------------------------"
        
    printf "1. View ${Red}Default${NC} Gensis file\n"
    printf "2. Edit the Gensis file\n"
    printf "3. Back to main menu\n "
    read -p "Enter choice [ 1 - 3] " choice 
    case $choice in
		1) View ;;
		2) Edit ;;
		3) Reconfigure;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
		
	esac
}

View()
{
    echo "------------------------------------------------------------------------"
    printf "${Yellow}Gensis File ${NC}\n"
    echo "--------------------------------------"
    input="CommonGenesis.json"
    while IFS= read -r var
    do
    echo "$var"
    done < "$input"
    read -p "Press any key to return to main menu ..."
    ConfigureGensisFile
}
######################################################################################
Edit()
{
   echo "--------------------------------------"
    printf "${Yellow}Edit Gensis File ${NC}\n"
    echo "--------------------------------------"    
    nano CommonGenesis.json
    read -p "Press any key to return to transfere the file ..."

    filename="nodes.txt"

    printf '> Transfering ${Yellow} Gensis File ${NC} to Blockchain nodes'
    for host in `cat $filename`; do
        ssh  root@$host  pkill geth
        scp -oStrictHostKeyChecking=no "CommonGenesis.json" root@$host:/root/Blockchain-Testbed/Blockchain/ethereum/  #2> /dev/null 2>&1 &
    done
     echo "--------------------------------------"    
    read -p "Press any key to re-initilize Blockchain nodes ..."
    
    Reinitialize
    
    read -p "Press any key to return to main menu ..."
    
    ConfigureGensisFile
}
######################################################################################

