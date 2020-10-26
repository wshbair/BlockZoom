ViewCurrentExp(){
    clear
    header
    printf "${Purple}RUNNING EXPIREMENT - MENU ${NC}\n"
    echo "------------------------------------------------------------------------"
    local currentjobs=$(oarstat -u)
    if [[ $currentjobs ]]
    then   
        local RESULTS
        local peerCount
        local ismining
        count=1
        filename="nodes.txt"
        for host in `cat $filename`; do
            RESULTS=$(ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/getBalance.sh 2> /dev/null 2>&1 &)
            peerCount=$(ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/getPeerCount.sh 2> /dev/null 2>&1 &)
            ismining=$(ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/ismining.sh 2> /dev/null 2>&1 &)
            RESULTS=${RESULTS#?};
            RESULTS=${RESULTS#?};
            printf "> ${Cyan}Node #$count${NC} |  $host  | Balance: ${GRN} $((16#$RESULTS))${NC} Ether | $(($peerCount)) peers | Mining: ${Yellow} ${ismining:7} ${NC}\n"
            echo   "------------------------------------------------------------------------------------------------------------------------"
            ((count++))
        done
    else 

        printf "\n"
        printf "${Yellow}Info${NC}: ${Red}NO${NC} expiremnts are running \n "

    fi
    printf '\n'
    read -p "Press any key to return to main menu ..."
}
