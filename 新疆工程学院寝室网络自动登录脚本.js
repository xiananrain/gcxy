// ==UserScript==
// @name         新疆工程学院寝室网络自动登录脚本
// @namespace    your-namespace
// @version      1.1
// @description  自动登录脚本示例
// @match        http://36.189.241.20:9956/web
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // 在这里填写你的用户名和密码
    const username = '你的';
    const password = '密码';

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
            }, 250); // 延时时间为3秒（250毫秒）
        }, 250); // 延时时间为0.25秒（250毫秒）
    }

    // 开始连接和断开连接的循环
    connectAndDisconnect();
})();
