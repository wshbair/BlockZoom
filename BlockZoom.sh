#!/bin/bash
# ----------------------------------
# Step #1: User defined function
# ----------------------------------

#smallbanck()
# {   #small bank folder
    #make
    #./driver -ops 10000 -threads 4 -txrate 10 -fp stat.txt -endpoint 127.0.0.1:8084 -db ethereum
#}

#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

Red='\033[0;31m'
GRN='\033[0;32m'
NC='\033[0m' # No Color
Yellow='\033[1;33m'
Purple='\033[0;35m'
Cyan='\033[0;36m'
Orange='\033[0;33m'
header()
{
     printf "${Orange}
 ____  _                _     ______                     
|  _ \| |              | |   |___  /                     
| |_) | |     ___   ___| | __   / / ___   ___  _ __ _ __  
|  _ <| |    / _ \ / __| |/ /  / / / _ \ / _ \|  _   _  | 
| |_) | |___| (_) | (__|   <  / /_| (_) | (_) | | | | | |
|____/|______\___/ \___|_|\_\/_____\___/ \___/|_| |_| |_|
    ${NC} \n"
    printf "${Red}Large Scale Blockchain Testbed ${NC} - v0.6\n"
    echo "------------------------------------------------------------------------"
 }

######################################################################################
Ethereum()
{
    clear
    header
    printf "${Purple}BLOCKHAIN  SPECEFICATIONS - MENU ${NC}\n"
    echo "------------------------------------------------------------------------"
    unset sitesnumber
    printf "Grid'5000 has 8 sites (Grenoble, Lille, Luxembourg, Lyon, Nancy, Nantes, Rennes and Sophia)\n\n"
    while [[ ! ${sitesnumber} =~ ^[0-9]+$ ]]; do
        read -p "> Enter the number of sites to be used (within range of 1-8): " sitesnumber
        ! [[ ${sitesnumber} -ge 1 && ${sitesnumber} -le 8  ]] && unset sitesnumber
    done
    printf '\n'
    unset nodes
    while [[ ! ${nodes} =~ ^[0-9]+$ ]]; do
        read -p "> Enter the number of nodes per site (within range of 1-10): " nodes
                ! [[ ${nodes} -ge 1 && ${nodes} -le 10  ]] && unset nodes
    done
    printf '\n'
    read -p '> Enter the Walltime in hours (e.g, 2:00:00): ' walltime
    let a=$sitesnumber*$nodes
    printf '\n'
     
    read -p "Press any key start Resource Reservation ..."
    clear 
    header
    printf "${Purple}BLOCKHAIN  SPECEFICATIONS - MENU ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf "${Yellow}Grid'5000 Reservation Operations ${NC}\n"
    echo "------------------------------------------------------------------------"
    start=`date +%s`

    printf "Working ...\n"

    # Nodes only in luxembourg
    ruby Bch-Over-G5k #> G5Klog.txt

    end=`date +%s`
    runtime=$((end-start))
    
    #$1 number of nodes, $2 time, $3 number of sites
    #ruby node-reservation.rb $nodes $walltime $sitesnumber > G5Klog.txt
    clear 
    header
    printf "${Purple}BLOCKHAIN  SPECEFICATIONS - MENU ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf "${Yellow}Grid'5000 Reservation Operations ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf ">> Blokchain network setup tooks ${GRN} $runtime seconds${NC} \n"
    echo "-----------------------------------------------"
    filename="nodes.txt"
    echo 'Transfering static-nodes to network nodes'
    echo "-----------------------------------------------"
    for host in `cat $filename`; do
        ssh  root@$host  pkill geth
        scp -oStrictHostKeyChecking=no "static-nodes.json" root@$host:/home/luxbch/data #2> /dev/null 2>&1 &
    done

    echo "-----------------------------------------------"
    printf "${Yellow}Blockchain Validation Step ${NC}\n"
    echo "-----------------------------------------------"
    local choice
    count=1
    filename="nodes.txt"    
    for host in `cat $filename`; do
        nohup ssh  -oStrictHostKeyChecking=no root@$host pkill geth  </dev/null >nohup.out 2>nohup.err &
        sleep 5
        nohup ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/mining.sh </dev/null >nohup.out 2>nohup.err &
        printf "+ ${Cyan} Node #$count ${NC} | $host | Mining: ${GRN}STARTED${NC}\n"
        echo "------------------------------------------------------------------------"
        ((count++))     
    done
    sleep 20
    read -p "Press any key to return to main menu ..."
}
######################################################################################
Setup() {
    clear 
    header
    printf "${Purple}BLOCKHAIN  SPECEFICATIONS - MENU ${NC}\n"
    echo "------------------------------------------------------------------------"
    echo "Select blockchain paltform to be deployed :"
	echo "1. Ethereum"
	echo "2. IBM HyperLedger (not supported yet)"
	echo "3. Back to Main Menu"
	local choice
	read -p "Enter choice [ 1 - 3] " choice
	case $choice in
		1) Ethereum ;;
		2) HyperLedger  ;;
		3) show_menus;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}

######################################################################################
Reinitialize(){
    filename="nodes.txt"
    declare -a enodelist
    count=1
    # Step 1 Kill all geth instance
    echo "> Clean configuration files"
    rm 'static-nodes.json'
    for host in `cat $filename`; do
        ssh  -oStrictHostKeyChecking=no root@$host pkill geth  
        sleep 5
        ssh  -oStrictHostKeyChecking=no root@$host rm -fr /home/luxbch/data                      
    done
    echo "-----------------------------------------------"
    printf "${Yellow}Re-initilize Nodes ${NC}\n"
    echo "-----------------------------------------------"
    # Step 2 Reinilize the node using gensis file    
    for host in `cat $filename`; do
     ssh -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/init.sh </dev/null >nohup.out 2>nohup.err &
      printf "+ ${Cyan} Node #$count ${NC} | $host | Initialized: ${GRN}True${NC}\n"
      ((count++))
      sleep 5  
    done
    sleep 10
    # Step 3 Kill all geth instance
    for host in `cat $filename`; do
        ssh  -oStrictHostKeyChecking=no root@$host pkill geth                        
    done

    echo "-----------------------------------------------"
    printf "${Yellow}Regenerate static-nodes.json file ${NC}\n"
    echo "-----------------------------------------------"
    filename="nodes.txt"
      
    for host in `cat $filename`; do
     enode=$(ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/GenerateStaticNode.sh 2> /dev/null 2>&1 &)
     enodelist+=($enode)
    done
    
    x=$(IFS=,; echo "[${enodelist[*]}]")
    echo $x >> 'static-nodes.json'

    echo "-----------------------------------------------"
    printf "${Yellow}Transfering the new static-nodes.json file ${NC}\n"
    echo "-----------------------------------------------"
     for host in `cat $filename`; do
        ssh  root@$host  pkill geth
        scp -oStrictHostKeyChecking=no "static-nodes.json" root@$host:/home/luxbch/data  #2> /dev/null 2>&1 &
    done

    read -p "Press any key to return to main menu ..."
    Reconfigure
}
######################################################################################

Stop()
{
    clear
    header
    printf "${Purple}STOP & RESET NODES ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf "> Stop all nodes ... \n"
    echo   "------------------------------------------------------------------------"
    count=1
    filename="nodes.txt"
    for host in `cat $filename`; do
        ssh  -oStrictHostKeyChecking=no root@$host pkill geth
        printf "+ ${Cyan}Node #$count${NC} |  $host  | Status: ${GRN} OK ${NC} \n"
        echo   "------------------------------------------------------------------------"
        ((count++))
    done
    read -p "Press any key to return to main menu ..."
    Reset

}
######################################################################################
Reset(){
    clear
    header
    printf "${Purple}STOP & RESET  NODES - MENU ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf "1. Stop all nodes\n"    
    printf "2. Reinitialize nodes with a default configuration \n"
    printf "3. Release Grid'5000 reserved nodes (ToDo)\n"
    printf "4. Back to main menu \n"
    local choice
	read -p "Enter choice [ 1 - 3] " choice
	case $choice in
		1) Stop;;
        2) Reinitialize ;;
		3) Release ;;
		4) show_menus;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
    read -p "Press any key to return to main menu ..."
}
######################################################################################
Reconfigure()
{
    source ./Reconfigure.sh
    
    clear
    header
    printf " ${Purple}EXPEREMNT  RE-CONFIGURATION - MENU ${NC}\n"
	echo "------------------------------------------------------------------------"
    echo "1. Reconfigure mining nodes  \n\n"
    echo "2. Reconfigure transaction nodes  \n\n"
    echo "3. Reconfigure genesis file  \n\n"
    echo "4. Back to main menu  \n\n"
    printf '\n'
    local choice
	read -p "Enter choice [ 1 - 4] " choice
	case $choice in
		1) ReconfigureMiningNodes ;;
		2) ReconfigureTxNodes ;;
        3) ConfigureGensisFile ;;
        4) show_menus ;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}
######################################################################################
info()
{
    clear
    header
    printf "${Purple}ABOUT  BLOCKZOOM ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf "${GRN}BlockZoom${NC} is a reproducible environment for experimenting distributed ledgers \ntechnologies and smart contract applications.\n\n"
    printf "The project is supported by the FNR Luxembourg and H2020 CONCORDIA\n \n"    
    printf "This demonistration has been presented in \nIEEE ICBC2019, 14-17 May 2019 Seoul, South Korea. \n\n"
    echo "------------------------------------------------------------------------"                 
    printf "${Purple} Developed by:  ${NC}\n"
    echo "------------------------------------------------------------------------"             
    echo "Dr. Wazen SHBAIR"
    echo "wazen.shbair@uni.lu" 
    echo "wazen.shbair@gmail.com" 
    echo "University of Luxembourg"
    printf "\n"
    read -p "Press any key to return to main menu ..."
}
######################################################################################
# function to display menus
show_menus() {
    clear
    header
	printf " ${Purple}BLOCKZOOM - MAIN MENU ${NC}\n"
	echo "------------------------------------------------------------------------"
	printf "1. ${Orange}Setup${NC} a new expirement \n \n"
    printf "2. ${Orange}View${NC} a running expirement \n \n"
    printf "3. ${Orange}Lanuch${NC} workLoads generator ${Red}(Chain Hammer Included)${NC} \n \n"
    printf "4. ${Orange}Reconfigure${NC} the network \n \n"
    printf "5. ${Orange}Reset${NC} all nodes \n \n"
    printf "6. ${Orange}Results${NC} file \n \n"
    printf "7. ${Orange}About BlockZoom${NC} \n \n"
	printf "0. Exit\n"
    printf "\n"
}
# read input from the keyboard and take a action
# invoke the Reserver() when the user select 1 from the menu option.
# invoke the Reset() when the user select 2 from the menu option.
# invode the Recofigure() when the user select 3 from the menu option
# Exit when user the user select 3 form the menu option.

read_options(){
    source ./ViewCurrentExp.sh
    source ./WorkLoadsGenerator.sh
    source ./results.sh


	local choice
	read -p "Enter choice [ 1 - 7] " choice
	case $choice in
		1) Setup ;;
        2) ViewCurrentExp ;;
        3) WorkLoadsGenerator;;		
        4) Reconfigure;;
        5) Reset ;;
        6) Show_Results;;
        7) info;;
		0) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}

Topmenu()
{
while true
do
	show_menus
	read_options
done
}

while true
do
	show_menus
	read_options
done
