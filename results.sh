Show_Results(){
clear
header
printf " ${Purple}R E S U L T S V I E W -  M E N U ${NC}\n"
echo "------------------------------------------------------------------------"
printf "1. ${GRN}View${NC} Small bank workloads\n"
printf "2. ${GRN}View${NC} I/O heavy workloads\n"
printf "3. ${GRN}View${NC} CPU heavy workloads\n"
printf "4. Back to main menu\n "
read -p "Enter choice [ 1 - 4] " choice 
case $choice in
    1) smallbankresults ;;
    2) ioheavyresults ;;
    3) cpuheavyresults;;
    4) show_menus;;
    *) echo -e "${RED}Error...${STD}" && sleep 2
esac
}

smallbankresults()
{

    input="smallbankresult.txt"
    while IFS= read -r var
    do
    echo "$var"
    done < "$input"

    read -p "Press any key to return to main menu ..."
    Show_Results
}

ioheavyresults()
{
    input="ioheavy_results.txt"
    while IFS= read -r var
    do
    echo "$var"
    done < "$input"
    
    read -p "Press any key to return to main menu ..."
    Show_Results
}
cpuheavyresults()
{
    input="cpuheavy_results.txt"
    while IFS= read -r var
    do
    echo "$var"
    done < "$input"
    
    read -p "Press any key to return to main menu ..."
    Show_Results
}
