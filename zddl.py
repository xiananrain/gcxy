import time
import requests

# 在这里填写你的用户名和密码
username = '你的账号'
password = '密码'

# 定义连接、断开连接和再次连接的函数
def connect_disconnect_reconnect():
    # 构造登录请求的数据
    login_data = {
        'web-auth-user': username,
        'web-auth-password': password,
        'web-auth-connect': '连接'
    }

    # 发送登录请求
    response = requests.post('http://36.189.241.20:9956/web', data=login_data)

    # 延时一段时间后进行断开连接
    time.sleep(1)

    # 构造断开连接请求的数据
    disconnect_data = {
        'web-auth-disconnect': '断开'
    }

    # 发送断开连接请求
    response = requests.post('http://36.189.241.20:9956/web', data=disconnect_data)

    # 延时一段时间后再次连接
    time.sleep(1)
    response = requests.post('http://36.189.241.20:9956/web', data=login_data)

# 执行连接、断开连接和再次连接的操作
connect_disconnect_reconnect()
