#!/bin/bash

# 配置参数（可根据实际情况修改）
TARGET_URL="https://www.bing.com"
wan_interface="wan"               # WAN接口名称
macdizhi="xx-xx"      # 设备MAC地址
zhanghao="g"           # 认证账号
mima="123123"                     # 认证密码
CHECK_INTERVAL=120               # 检测间隔（秒），2分钟
RESTART_WAIT=10                   # 重启接口后等待时间（秒）

while true; do
    echo "开始网络检测：$(date)"

    # 检测网络连通性（使用curl判断）
    curl -I -m 3 "$TARGET_URL" > /dev/null 2>&1
    ping_status=$?  # 获取上一条命令的退出码（0为成功）

    if [ $ping_status -ne 0 ]; then
        echo "无法访问 $TARGET_URL，正在重启 $wan_interface 接口..."
        
        # 重启WAN接口（需要root权限）
        ifdown "$wan_interface" > /dev/null 2>&1
        ifup "$wan_interface" > /dev/null 2>&1

        echo "等待 $RESTART_WAIT 秒后准备认证..."
        sleep $RESTART_WAIT

        # 获取 WAN 口的 IP 地址
        userip=$(ip -4 addr show $wan_interface | grep -oE 'inet ([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $2}' | head -n 1)

        if [ -z "$userip" ]; then
            echo "无法获取 $wan_interface 接口的 IP 地址，请检查网络配置。"
        else
            redirect_url="http://36.189.241.20:9956/?userip=$userip&wlanacname=&nasip=117.191.7.53&usermac=$macdizhi"
            encoded_redirect_url=$(echo "$redirect_url" | sed 's/&/%26/g' | sed 's/:/%3A/g' | sed 's/\//%2F/g')

            curl 'http://36.189.241.20:9956/web/connect' \
              -H 'Accept: */*' \
              -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8' \
              -H 'Connection: keep-alive' \
              -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
              -b "redirect-url=$redirect_url" \
              -H 'Origin: http://36.189.241.20:9956' \
              -H 'Referer: http://36.189.241.20:9956/web' \
              -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36' \
              -H 'X-Requested-With: XMLHttpRequest' \
              --data-raw "web-auth-user=$zhanghao&web-auth-password=$mima&remember-credentials=false&redirect-url=$encoded_redirect_url" \
              --insecure
        fi
    else
        echo "网络正常，无需操作。"
    fi

    echo "------------------------------"
    sleep 1200  # 等待 20分钟再检查
done
