// ==UserScript==
// @name         新疆工程学院校园宽带自动登录脚本
// @namespace    https://github.com/xiananrain/gcxy
// @version      1.1
// @author       xianan
// @description  新疆工程学院寝室网络自动登录脚本
// @match        *://36.189.241.20:9956/*
// @icon         
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // 在这里填写你的用户名和密码
    const username = '【替换为你的账号】';
    const password = '【替换为你的密码】';

    //判断是否修改配置，请勿修改
    if (username === "【替换为你的账号】" || password === "【替换为你的密码】") {    
        alert("请在[油猴]管理面板处修改脚本源码输入为你的用户名和密码");
        return;
    };
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
    // 避免重复连接
    //window.location.href = "https://cn.bing.com/";
})();
