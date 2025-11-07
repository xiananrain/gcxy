#!/bin/bash

# 配置参数（可根据实际情况修改）
TARGET_URLS=("https://www.baidu.com" "https://www.qq.com" "https://www.douyin.com")  # 三个检测地址
wan_interface="wan"               # WAN接口名称
macdizhi="xx-xx"      # 设备MAC地址
zhanghao="g"            # 认证账号
mima="123123"                     # 认证密码
MIN_INTERVAL=120                 # 最小检测间隔（秒），2分钟
MAX_INTERVAL=240                 # 最大检测间隔（秒），4分钟
RESTART_WAIT=10                   # 重启接口后等待时间（秒）
TIMEOUT=3                         # 每个地址检测超时时间（秒）
LOG_FILE="/var/log/network_monitor.log"  # 日志文件路径（可自定义）


# 日志输出函数：同时打印到终端和日志文件
log() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo "$msg"
    echo "$msg" >> "$LOG_FILE"
}

while true; do
    # 确保日志文件存在并设置权限
    > "$LOG_FILE"  # 直接清空日志文件
    chmod 644 "$LOG_FILE"
    log "开始网络检测"
    failed_count=0  # 记录无法访问的地址数量

    # 逐个检测目标地址
    for url in "${TARGET_URLS[@]}"; do
        log "检测 $url..."
        curl -I -m "$TIMEOUT" "$url" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            log "无法访问 $url"
            ((failed_count++))
        else
            log "成功访问 $url"
        fi
    done

    # 当所有地址都无法访问时，执行修复操作
    if [ $failed_count -eq ${#TARGET_URLS[@]} ]; then
        log "所有目标地址均无法访问，正在重启 $wan_interface 接口..."
        
        # 重启WAN接口（需要root权限）
        ifdown "$wan_interface" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            log "$wan_interface 接口关闭成功"
        else
            log "$wan_interface 接口关闭失败"
        fi
        
        ifup "$wan_interface" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            log "$wan_interface 接口启动成功"
        else
            log "$wan_interface 接口启动失败"
        fi

        log "等待 $RESTART_WAIT 秒后准备认证..."
        sleep "$RESTART_WAIT"

        # 获取 WAN 口的 IP 地址
        userip=$(ip -4 addr show "$wan_interface" | grep -oE 'inet ([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $2}' | head -n 1)

        if [ -z "$userip" ]; then
            log "无法获取 $wan_interface 接口的 IP 地址，请检查网络配置。"
        else
            log "获取到 $wan_interface 接口 IP 地址：$userip"
            redirect_url="http://36.189.241.20:9956/?userip=$userip&wlanacname=&nasip=117.191.7.53&usermac=$macdizhi"
            encoded_redirect_url=$(echo "$redirect_url" | sed 's/&/%26/g' | sed 's/:/%3A/g' | sed 's/\//%2F/g')

            log "开始进行网络认证..."
            # 执行认证并记录结果
            auth_result=$(curl 'http://36.189.241.20:9956/web/connect' \
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
              --insecure 2>&1)
            log "认证执行结果：$auth_result"
        fi
    else
        log "网络正常（至少一个目标地址可访问），无需操作。"
    fi

    # 计算随机间隔时间（在MIN和MAX之间）
    RANDOM_INTERVAL=$((MIN_INTERVAL + RANDOM % (MAX_INTERVAL - MIN_INTERVAL + 1)))
    log "等待 $RANDOM_INTERVAL 秒后再次检查..."
    log "------------------------------"
    sleep "$RANDOM_INTERVAL"  # 等待随机间隔后再次检查
done
