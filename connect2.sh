#!/bin/bash

while true; do
    echo "开始网络检测：$(date)"

    # 尝试 ping baidu.com
    ping -c 3 baidu.com > /dev/null 2>&1
    ping_status=$?

    # 假设 WAN 口为 eth0.2
    wan_interface="eth0.2"
    zhanghao="账号"
    mima="123123"
    mac="mac地址"
    # 定义一个固定的 b-user-id，可能需要自己去网页查看，如果你的认证门户每次都生成新的，可能需要动态获取
    b_user_id="62e493eb-f655-a1a8-9549-c27f00348f5b"

    if [ $ping_status -ne 0 ]; then

        # 等待10s
        echo "无法ping通baidu，等待10s后发送post"
        sleep 10

        # 获取 WAN 口的 IP 地址
        userip=$(ip -4 addr show $wan_interface | grep -oE 'inet ([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $2}' | head -n 1)

        if [ -z "$userip" ]; then
            echo "无法获取 $wan_interface 接口的 IP 地址，请检查网络配置。"
        else
            redirect_url="http://36.189.241.20:9956/?userip=$userip&wlanacname=&nasip=117.191.7.53&usermac=$mac"
            encoded_redirect_url=$(echo "$redirect_url" | sed 's/&/%26/g' | sed 's/:/%3A/g' | sed 's/\//%2F/g')

            response=$(curl -s -o /dev/null -w "%{http_code}" 'http://36.189.241.20:9956/web/connect' \
              -H 'Accept: */*' \
              -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8' \
              -H 'Connection: keep-alive' \
              -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
              -b "b-user-id=$b_user_id; redirect-url=$redirect_url" \
              -H 'Origin: http://36.189.241.20:9956' \
              -H 'Referer: http://36.189.241.20:9956/web' \
              -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36' \
              -H 'X-Requested-With: XMLHttpRequest' \
              --data-raw "web-auth-user=$zhanghao&web-auth-password=$mima&remember-credentials=false&redirect-url=$encoded_redirect_url" \
              --insecure)

            if [ $response -eq 200 ]; then
                echo "POST 请求成功，状态码: $response"
            else
                echo "POST 请求失败，状态码: $response"
            fi
        fi
    else
        echo "网络正常，无需操作。"
    fi

    echo "------------------------------"
    sleep 120  # 等待 2 分钟再检查
done
