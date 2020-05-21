server=
port=
num_success=0
num_fail=0
openssl='openssl'
selective=0  # 0 is print all, 1 is print only fail, 2 is print only success
default_proto="tls1_0 tls1_1 tls1_2 tls1_3"
proto=${proto:-$default_proto}

if [ $# == 2 ]; then
    server=$1
    port=$2
elif [ $# == 3 ]; then
    server=$1
    port=$2
    openssl=$3
elif [ $# == 4 ]; then
    server=$1
    port=$2
    openssl=$3
    selective=$4
else
    echo "support_ciphers.sh <IP> <Port> [<openssl path for test>]"
    exit
fi

echo "Will test SSL Cipher with $openssl"
echo "openssl version is ..."
$openssl version

sleep 3

for v in $proto; do
 for c in $(openssl ciphers 'ALL:eNULL' | tr ':' ' '); do
    $openssl s_client -connect ${server}:${port} -cipher $c -$v < /dev/null > /dev/null 2>&1
    if [ $? -gt 0 ]
    then
        if [ $selective -eq 0 ]
        then
            echo -e "[ FAIL  ] $v:\t$c" 
        elif [ $selective -eq 1 ]
        then
            echo -e "[ FAIL  ] $v:\t$c" 
        fi
        ((num_fail++))
    else
        if [ $selective -eq 0 ] 
        then
            echo -e "[SUCCESS] $v:\t$c"
        elif [ $selective -eq 2 ]
        then
            echo -e "[SUCCESS] $v:\t$c"
        fi
        ((num_success++))
    fi
 done
 echo "-----------------------[$v Result]------------------------"
 echo "TOTAL   : $((num_success + num_fail))"
 echo "SUCCESS : $num_success"
 echo "F A I L : $num_fail"
 echo "------------------------[$v DONE]-------------------------"
 num_success=0
 num_fail=0
done

