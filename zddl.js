// 在这里填写你的用户名和密码
const username = 'g17881101711';
const password = '123123';

// 选择登录表单元素
const usernameInput = document.querySelector('#web-auth-user');
const passwordInput = document.querySelector('#web-auth-password');
const connect = document.querySelector('#web-auth-connect');
const disconnect = document.querySelector('#web-auth-disconnect');

// 填充用户名和密码
usernameInput.value = username;
passwordInput.value = password;

// 定义连接函数
function connectAndDisconnect() {
    // 模拟点击连接按钮
    connect.click();

    // 延时一段时间后进行断开连接
    setTimeout(() => {
        // 模拟点击断开按钮
        disconnect.click();

        // 延时一段时间后再次连接
        setTimeout(() => {
            // 模拟点击连接按钮
            connect.click();
        }, 1000); // 延时时间为1秒
    }, 1000); // 延时时间为1秒
}

// 执行连接和断开连接的循环
connectAndDisconnect();
