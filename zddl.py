import requests

# 在这里填写你的用户名和密码
username = 'g17881101711'
password = '123123'

# 登录页面的 URL
login_url = 'http://36.189.241.20:9956/web'

# 创建一个会话
session = requests.Session()

# 发送登录请求
login_data = {
    'username': username,
    'password': password
}
response = session.post(login_url, data=login_data)

# 检查登录是否成功
if response.status_code == 200:
    print('登录成功')
else:
    print('登录失败')
