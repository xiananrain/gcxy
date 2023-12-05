#!/bin/bash

# 在这里填写你的用户名和密码
username="g17881101711"
password="123123"

# 登录URL
login_url="http://36.189.241.20:9956/web"

# 填充用户名和密码
curl -X POST -d "username=${username}&password=${password}" "${login_url}" >/dev/null

# 延时一段时间后进行断开连接
sleep 1

# 断开连接
curl -X POST "${login_url}" >/dev/null

# 延时一段时间后再次连接
sleep 1

# 连接
curl -X POST -d "username=${username}&password=${password}" "${login_url}" >/dev/null
