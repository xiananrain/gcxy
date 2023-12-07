// 获取用户名和密码的输入框
var usernameInput = document.getElementById('web-auth-user');
var passwordInput = document.getElementById('web-auth-password');

// 填充用户名和密码
usernameInput.value = 'g17881101711';
passwordInput.value = '123123';

// 获取登录按钮
var loginButton = document.getElementById('web-auth-connect');

// 模拟点击登录按钮
loginButton.click();

// 延迟执行断开连接和重新连接的操作
setTimeout(function() {
  // 执行断开连接的操作
  var disconnectButton = document.getElementById('web-auth-disconnect');
  disconnectButton.click();

  setTimeout(function() {
loginButton.click()
    // 执行重新连接的操作
    // ...
  }, 2000); // 延迟 2 秒后执行重新连接的操作
}, 5000); // 延迟 5 秒后执行断开连接的操作
