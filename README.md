# chat

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## note
web 调试工具 非常好用!!!
`vscode web dev tool `

ws token  可以通过 query 或者 header 传递,之前由于没找到 headers 的传递方法而采用的 query

## 1578495803
1. 存在一个 ws 连接的 bug,当服务器无法响应时产生. 

2. 采用 event bus 的订阅流收集和分发服务端的消息,注意销毁页面时销毁监听者.订阅流代表可以注册全局的事件监听而不用担心时间被占用. 

3. ws 消息处理是否应该考虑单独放在一个类里面进行调用???消息渲染暂时被注释,后面重新加

## 
[需要设置全局拦截器用于对于类似 dio 的异步请求进行拦截,重点是上下文的存储!!!](https://juejin.im/post/5c9f2c37518825609415d11d)

[打包卡在 Running Gradle task 'assembleRelease'... 的问题](https://kaixuan.im/2019/09/26/flutterrunning-gradle-task-assemblerelease/)