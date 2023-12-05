#!/bin/bash

# 在这里填写你的用户名和密码
username="g17881101711"
password="123123"

# 登录URL和表单数据
login_url="http://36.189.241.20:9956/web"
login_data="web-auth-user=$username&web-auth-password=$password"

# 发送登录请求
login_response=$(curl -s -X POST -d "$login_data" "$login_url")

# 提取连接和断开连接按钮的ID
connect_id=$(echo "$id="web-auth-connect" | jq -r '. | .connect')
disconnect_id=$(echo "$id="web-auth-disconnect" | jq -r '. | .disconnect')

# 模拟点击连接按钮
curl -s -X POST -d "id=$connect_id" "$login_url"

# 延时一段时间后进行断开连接
sleep 1

# 模拟点击断开按钮
curl -s -X POST -d "id=$disconnect_id" "$login_url"

# 延时一段时间后再次连接
sleep 1

# 模拟点击连接按钮
curl -s -X POST -d "id=$connect_id" "$login_url"
