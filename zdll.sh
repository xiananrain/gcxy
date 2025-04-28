#!/bin/bash

wan_interface="eth0"
macdizhi="路由器mac地址"
zhanghao="账号"
mima="123123"

log_file="/var/log/network_check.log"

while true; do
    echo "[$(date)] 开始网络检测..." | tee -a $log_file

    ping -c 3 baidu.com > /dev/null 2>&1
    ping_status=$?

    if [ $ping_status -ne 0 ]; then
        echo "[$(date)] 无法 ping 通，重启 $wan_interface 接口..." | tee -a $log_file

        ifdown $wan_interface && sleep 5 && ifup $wan_interface
        sleep 30

        userip=""
        for i in {1..3}; do
            userip=$(ip -4 addr show $wan_interface | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)
            if [ -n "$userip" ]; then
                break
            fi
            sleep 3
        done

        if [ -z "$userip" ]; then
            echo "[$(date)] 获取IP失败，请检查网卡！" | tee -a $log_file
        else
            redirect_url="http://36.189.241.20:9956/?userip=$userip&wlanacname=&nasip=117.191.7.53&usermac=$macdizhi"
            encoded_redirect_url=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$redirect_url'''))")

            curl 'http://36.189.241.20:9956/web/connect' \
              -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
              -b "redirect-url=$redirect_url" \
              --data-raw "web-auth-user=$zhanghao&web-auth-password=$mima&remember-credentials=false&redirect-url=$encoded_redirect_url" \
              --insecure

            echo "[$(date)] 尝试重新认证成功（提交 curl）" | tee -a $log_file
        fi
    else
        echo "[$(date)] 网络正常。" | tee -a $log_file
    fi

    echo "------------------------------" | tee -a $log_file
    sleep 120
done
