凑热闹
=======

2013西电hackday参赛作品《凑热闹》

##作者
*黄嘉恒 @huajiahen \(新浪微博 [@__block](http://weibo.com/u/2977681790)\)
*勾小川 @gpxlcj
##特别感谢 
*林威 \(新浪微博 [@Wiilen_n](http://weibo.com/wiilen)\)
*何明涛 \(新浪微博 [@美工大人](http://weibo.com/u/2366762741)\)

##项目简介
凑热闹是一款基于地理位置的消息分发平台，主要实现了周边事件与活动的发布和查看功能。事件是指不可预期的一些突发事件，发布者提交信息后周边的用户可收到推送通知，其他用户可选择参与事件，发布后若所有参与者离开发布地点一定距离一定时间后活动会自动结束。活动是指有预期时间和地点的讲座、比赛等。用户每到达一个地方都能自动接收到周边的活动与事件。
凑热闹强调 LBS 属性，用户不能查看距离自己过远的活动，不在活动周围的一定区域内也不能参加活动。

##项目截图
![发布事件](/UI/demo1.PNG)
![发布活动](/UI/demo1.PNG)

##文件内容简介
*`backend` 文件夹内为软件后台，用 Python 的网络框架 Django 编写，开发环境为 Python2.7.3 与 Django1.3，不保证向前向后兼容。`data.db` 中为示例事件与活动，均位于西安电子科技大学周边。你可以通过 `\busy\template\posttest.html` 文件加入测试地点，其中经度\(longtitude\)与纬度\(latitude\)单位均为`°`。
*`client_iOS` 文件夹内为 iOS 客户端，使用前需要将 `hotspot-Prefix.pch` 文件中的 `#define kHostIP @"172.20.10.11:8000"` 中的IP地址替换为你的服务器地址。开发环境为 Xcode5.0, 基于iOS7.0 SKD开发, Deployment Target 7.0, 不保证向前兼容。使用了 AFNetworking, JPush, NSLogger 等几个依赖包，bulid 前请使用 pod update 命令下载依赖包\(需要安装 cocoapod \)
*`UI` 文件夹内为App截图和一些预期的设计(与实际作品相差较大)