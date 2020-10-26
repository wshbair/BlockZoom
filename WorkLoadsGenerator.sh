SmallBank()
{
    clear
    header
    printf "${Purple}S M A L L  B A N K  W O R K L O A D  - M E N U ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf "> Compling the workload source code ... \n"
    echo   "------------------------------------------------------------------------"

    count=1
    local RESULTS
        filename="nodes.txt"
        for host in `cat $filename`; do
            RESULTS=$( ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/workloads.sh 2> /dev/null 2>&1 &)
            printf "+ ${Cyan}Node #$count${NC} |  $host  | Status: ${GRN} $RESULTS ${NC} \n"
            echo   "------------------------------------------------------------------------"
            ((count++))
        done 
    printf "\n"
    read -p "> Enter node ID as a source of workload transactions : " choice
    printf "\n"
    printf "${Yellow}Workload Configuration${NC}\n"
    echo "------------------------------------------------------------------------"
    unset ops
    while [[ ! ${ops} =~ ^[0-9]+$ ]]; do
        read -p "> Enter the number of transactions (100 - 10,000): " ops
                ! [[ ${ops} -ge 100 && ${ops} -le 10000  ]] && unset ops
    done
    unset threads
    while [[ ! ${threads} =~ ^[0-9]+$ ]]; do
        read -p "> Enter the number of threads (1 - 10): " threads
                ! [[ ${threads} -ge 1 && ${nodes} -le 10  ]] && unset threads
    done
    unset txrate
    while [[ ! ${txrate} =~ ^[0-9]+$ ]]; do
        read -p "> Enter the transaction rate (10 - 50): " txrate
                ! [[ ${txrate} -ge 10 && ${txrate} -le 50  ]] && unset txrate
    done
    echo "------------------------------------------------------------------------"
    count=1
    
    clear
    header
    printf "${Purple}S M A L L  B A N K  W O R K L O A D  ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf "Workload operations\n"
    echo "------------------------------------------------------------------------"

    for host in `cat $filename`; do
        if [ $choice = $count ]; then
            ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/smallbank/Loads.sh $ops $threads $txrate
        fi
        ((count++))     
    done

    read -p "Press any key to return to main menu ..."
}
#######################################################################################
IOheavy()
{
    clear
    header
    printf "${Purple}I/O   H E A V Y   W O R K L O A D  - M E N U ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf "> Install required software ... \n"
    echo   "------------------------------------------------------------------------"
    count=1
    local RESULTS
        filename="nodes.txt"
        for host in `cat $filename`; do
            nohup ssh  -oStrictHostKeyChecking=no root@$host chmod u+x Blockchain-Testbed/Blockchain/ethereum/ioheavy/install.sh >/dev/null 2>&1 &
            nohup ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/ioheavy/install.sh >/dev/null 2>&1 &
            sleep 15
            printf "+ ${Cyan}Node #$count${NC} |  $host  | Status: ${GRN} READY ${NC} \n"
            echo   "------------------------------------------------------------------------"
            ((count++))
        done 
    printf "\n"
    read -p "> Enter node ID as a source of workload transactions : " choice
    printf "\n"
    
    printf "${Yellow}Workload Configuration${NC}\n"
    echo "------------------------------------------------------------------------"
    unset ops
    while [[ ! ${ops} =~ ^[0-9]+$ ]]; do
        read -p "> Enter the number of key-value to write (10 - 100): " ops
                ! [[ ${ops} -ge 10 && ${ops} -le 100 ]] && unset ops
    done
    echo "------------------------------------------------------------------------"
     
    clear
    header
    printf "${Purple}I/O   H E A V Y   W O R K L O A D  ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf "Workload operations\n"
    echo "------------------------------------------------------------------------"
    count=1
    for host in `cat $filename`; do
        if [ $choice = $count ]; then
            SmartContractAddr=$(ssh  -oStrictHostKeyChecking=no root@$host node Blockchain-Testbed/Blockchain/ethereum/ioheavy/deploy.js)
            echo "Smart contract address: " $SmartContractAddr
            result=$(ssh  -oStrictHostKeyChecking=no root@$host node Blockchain-Testbed/Blockchain/ethereum/ioheavy/write.js 10 $ops 555 $SmartContractAddr)
            echo $result
            echo $result >> 'ioheavy_results.txt'
            echo "------------------" >> 'ioheavy_results.txt'
        fi
        ((count++))     
    done
    read -p "Press any key to return to main menu ..."
    WorkLoadsGenerator
}
#######################################################################################
CPUheavy()
{
    clear
    header
    printf "${Purple}C P U   H E A V Y   W O R K L O A D  - M E N U ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf "> Install required software ... \n"
    echo   "------------------------------------------------------------------------"
    count=1
    local RESULTS
        filename="nodes.txt"
        for host in `cat $filename`; do
            nohup ssh  -oStrictHostKeyChecking=no root@$host chmod u+x Blockchain-Testbed/Blockchain/ethereum/ioheavy/install.sh >/dev/null 2>&1 &             
            nohup ssh  -oStrictHostKeyChecking=no root@$host Blockchain-Testbed/Blockchain/ethereum/ioheavy/install.sh >/dev/null 2>&1 &
            printf "+ ${Cyan}Node #$count${NC} |  $host  | Status: ${GRN} READY ${NC} \n"
            echo   "------------------------------------------------------------------------"
            sleep 15
            ((count++))
        done 
    printf "\n"
    read -p "> Enter node ID as a source of workload transactions : " choice
    printf "\n"

    printf "${Yellow}Workload Configuration${NC}\n"
    echo "------------------------------------------------------------------------"
    unset ops
    while [[ ! ${ops} =~ ^[0-9]+$ ]]; do
        read -p "> Enter the size of array to sort (10 - 1000): " ops
                ! [[ ${ops} -ge 10 && ${ops} -le 1000 ]] && unset ops
    done
    echo "------------------------------------------------------------------------"
    
    count=1 
    clear
    header
    printf "${Purple}C P U  H E A V Y   W O R K L O A D  ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf "Workload operations\n"
    echo "------------------------------------------------------------------------"

    for host in `cat $filename`; do
        if [ $choice = $count ]; then
            ssh  -oStrictHostKeyChecking=no root@$host node Blockchain-Testbed/Blockchain/ethereum/ioheavy/cpuheavy.js $ops 545
            #echo $resu
            #echo $resu >> 'cpuheavy_results.txt'
            echo "------------------" >> 'cpuheavy_results.txt'
        fi
        ((count++))     
    done
    read -p "Press any key to return to main menu ..."
}

#######################################################################################
# ChainHmmer Workload 
ChainHammer()
{
    clear
    header
    printf "${Purple}ChainHmmer Workload - M E N U ${NC}\n"
    echo "------------------------------------------------------------------------"
    printf "> Select the Source of Transactions ... \n"
    echo   "------------------------------------------------------------------------"
    count=1
    local RESULTS
        filename="nodes.txt"
        for host in `cat $filename`; do
            printf "+ ${Cyan}Node #$count${NC} |  $host  | Status: ${GRN} READY ${NC} \n"
            echo   "------------------------------------------------------------------------"
            ((count++))
        done 
    printf "\n"
   
    read -p "> Enter NODE ID as a source of workload transactions : " choice
    printf "\n"

    printf "${Yellow}Workload Configuration${NC}\n"
    echo "------------------------------------------------------------------------"
    unset lbl
        read -p "> Enter lable for this experiment (e.g BlockZoom_Exp): " lbl
    unset ops
    while [[ ! ${ops} =~ ^[0-9]+$ ]]; do
        read -p "> Enter the of transactions (e.g 15000 txs): " ops
                ! [[ ${ops} -ge 10 && ${ops} -le 1000000 ]] && unset ops
    done
    unset type
        read -p "> Enter the transaction sending mode (sequential or 'threaded2 300'): " type
    echo "------------------------------------------------------------------------"

    count=1
    printf "${Purple}Generating Expirment Command  ${NC}\n"
    echo "------------------------------------------------------------------------"
    echo "cd chainhammer" > "exp_chainhammer.sh"
    echo "CH_TXS=$ops CH_THREADING=$type ./run.sh $lbl" >>exp_chainhammer.sh
    printf "\n"
    cat exp_chainhammer.sh

    printf "\n"

    read -p "> Enter any key to transfere the expirment configuration file to Node#$choice " ok  
    echo "------------------------------------------------------------------------"
    for host in `cat $filename`; do
        if [ $choice = $count ]; then
      		scp -oStrictHostKeyChecking=no "exp_chainhammer.sh" root@$host:/root/ #2> /dev/null 2>&1 &
        	nohup ssh  -oStrictHostKeyChecking=no root@$host chmod u+x exp_chainhammer.sh  </dev/null >nohup.out 2>nohup.err &
       fi
       ((count++))
    done
    echo "------------------------------------------------------------------------"
    
    clear
    header
    printf "${Purple}CHAIN HAMMER EXPIREMENT LOG ${NC}\n"
    echo "------------------------------------------------------------------------"
   count=1
   for host in `cat $filename`; do
        if [ $choice = $count ]; then
             ssh  -oStrictHostKeyChecking=no root@$host /root/exp_chainhammer.sh 
       fi
       ((count++))
    done
    printf "${Yellow}[BlockZoom] Workload operation is Completed ... ${NC}\n"
   sleep 10 
   printf "${Purple}Results Collection ${NC}\n"
   echo "------------------------------------------------------------------------"

  cd chainhammer_results
  mkdir $lbl
  count=1
  cd ..
   for host in `cat $filename`; do
        if [ $choice = $count ]; then
             scp -r  -oStrictHostKeyChecking=no root@$host:/root/chainhammer/reader/img chainhammer_results/$lbl
             scp -r  -oStrictHostKeyChecking=no root@$host:/root/chainhammer/reader/temp.db chainhammer_results/$lbl
             scp -r  -oStrictHostKeyChecking=no root@$host:/root/chainhammer/results/runs chainhammer_results/$lbl
             scp -r  -oStrictHostKeyChecking=no root@$host:/root/chainhammer/hammer/last-experiment.json chainhammer_results/$lbl
       fi
       ((count++))
    done

  printf "\n"
  printf "${Yellow}Results are collected and saved in /results/$lbl ... ${NC}\n \n"
  
}

#######################################################################################
WorkLoadsGenerator()
{
    clear
    header
    printf "${Purple}W O R K L O A D S  G E N E R A T O R S - M E N U ${NC}\n"
    echo "------------------------------------------------------------------------"
    #printf '1. Small bank\n'
    printf '1. Chain Hammer workload \n\n'
    printf '2. I/O heavy (Read/Write operations)\n\n'
    printf '3. CPU heavy (Sorting operations)\n\n'
    printf '4. Back to Main Menu \n\n'
    read -p "Enter choice [ 1 - 5]  " choice
	case $choice in
		1) ChainHammer  ;;
		2) IOheavy ;;
                3) CPUheavy;;
		4) Topmenu;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
    read -p "Press any key to return to main menu ..."
}
