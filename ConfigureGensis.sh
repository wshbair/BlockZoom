
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
    input="/root/Blockchain-Testbed/Blockchain/ethereum/CommonGenesis.json"
    while IFS= read -r var
    do
    echo "$var"
    done < "$input"
    read -p "Press any key to return to main menu ..."

}
######################################################################################

