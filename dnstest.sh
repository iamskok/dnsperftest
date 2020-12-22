#!/usr/bin/env bash

NAMESERVER=127.0.0.1
RESULT=result.txt
LIST=domain_list.txt
DIVIDER='==========================================================================='

command -v bc > /dev/null ||
{ echo "bc was not found. Please install bc."; exit 1; }

{ command -v drill > /dev/null && dig=drill; } ||
{ command -v dig > /dev/null && dig=dig; } ||
{ echo "dig was not found. Please install dnsutils."; exit 1; }

# List of domains to test against
source "${LIST}"

domain_count=0
# Get total number of domains
for i in "${!DOMAIN_LIST[@]}"; do
    domain_count=$((i + 1))
done

printf "\n${DIVIDER}\n" 2>&1 | tee -a ${RESULT}
printf "$NAMESERVER" 2>&1 | tee -a ${RESULT}
printf "\n${DIVIDER}\n" 2>&1 | tee -a ${RESULT}

total_time=0

for i in "${!DOMAIN_LIST[@]}"; do
    domain=${DOMAIN_LIST[$i]}
    index=$(($i+1))

    time=$(dig +tries=1 +time=2 +stats @$NAMESERVER "$domain" | grep "Query time:" | cut -d : -f 2- | cut -d " " -f 2)
    if [ -z "$time" ]; then
        # Timeout 1s = 1000ms
        time=1000
    elif [ "x$time" = "x0" ]; then
        time=1
    fi

    printf "\n$index. $domain $time ms" 2>&1 | tee -a ${RESULT}
    total_time=$((total_time + time))
done

average_time=$(bc -lq <<< "scale=2; $total_time/$domain_count")

printf "\n\n${DIVIDER}\n" 2>&1 | tee -a ${RESULT}
printf "TOTAL NUMBER OF DOMAINS: $domain_count\n" 2>&1 | tee -a ${RESULT}
printf "TOTAL TIME: $total_time ms\n" 2>&1 | tee -a ${RESULT}
printf "AVERAGE: $average_time ms\n" 2>&1 | tee -a ${RESULT}
printf "${DIVIDER}\n" 2>&1 | tee -a ${RESULT}

exit 0;
