## 项目介绍
AppStore 地址
https://itunes.apple.com/us/app/煎蛋-有趣/id1230079100?l=zh&ls=1&mt=8

腾讯应用宝地址
http://sj.qq.com/myapp/detail.htm?apkName=android.jandan.totzcc.com.weexjandan

Github地址
https://github.com/totzcc/WeexJandan

与我联系：

  http://weibo.com/3092381507/F2i3Z3nwo?type=comment

  https://m.weibo.cn/status/4105460950805404

采用Weex Vue语法做的iOS\Android 煎蛋客户端， 不支持H5

原生拓展解析HTML 的基础能力。所有的业务逻辑代码都用Weex 实现

主要功能有
  - 文章
    - 热门文章
    - 文章分类
    - 文章详情
    - 收藏、分享文章
    - 评论列表、发表评论、评论点赞
  - 段子
    - 内容抓取
    - 点赞、踩
  - 无聊图、妹子图
    - 内容抓取
    - 多图同屏浏览

## 运行Weex项目
> windows 请在  Git bash中运行

```
cnpm install
./start
```

## 运行iOS项目 platforms/ios

```
pod install
```

## 小技巧
- Debug 模式下采用在线的 js 地址，按 option + command + z (摇一摇) 可以重新加载当前 weex 页面
- Release 模式下采用 CDN weex压缩包，启动 App 时下载到本地并解压到 document 目录，加载本地的 weex文件

![项目演示](http://i2.muimg.com/588926/68762976de9614db.gif)





### 上架中遇到的问题
- 2017年5月10日 我将js文件打包成了zip 但是因为我的资源zip压缩包是在国内，苹果人员审核的时候下载资源文件失败了？？这怪我咯？？我没修改代码直接又提交了一次。让他再试试

```
2017年5月10日 上午10:16
发件人 Apple
2. 1 Performance: App Completeness
Guideline 2.1 - Performance


We discovered one or more bugs in your app when reviewed on iPhone running iOS 10.3.1 on Wi-Fi connected to an IPv6 network.

Specifically, the app was unable to load contents after launch.

Please see attached screenshots for details.

Next Steps

To resolve this issue, please run your app on a device while connected to an IPv6 network (all apps must support IPv6) to identify any issues, then revise and resubmit your app for review.

If we misunderstood the intended behavior of your app, please reply to this message in Resolution Center to provide information on how these features were intended to work.

For new apps, uninstall all previous versions of your app from a device, then install and follow the steps to reproduce the issue. For updates, install the new version as an update to the previous version, then follow the steps to reproduce the issue.

Resources

For information about supporting IPv6 Networks, please review Supporting IPv6 DNS64/NAT64 Networks and About Networking.

```

- 2017年5月9日 说我的App 和Web应用没啥区别，没用到原生的东西？怀疑是因为js文件是在线的。所以看起来像Web应用

```
2017年5月9日 上午6:24
发件人 Apple
4. 2 Design: Minimum Functionality
Guideline 4.2.2 - Design


We noticed that your app only includes links, images, or content aggregated from the Internet with limited or no native iOS functionality. We understand that this content may be curated from the web specifically for your users, but since it does not sufficiently differ from a mobile web browsing experience, it is not appropriate for the App Store.

Next Steps

Please revise your app concept to provide a more robust user experience by including native iOS features and functionality.

We understand that there are no hard and fast rules to define useful or entertaining, but Apple and Apple customers expect apps to provide a really great user experience. Apps should provide valuable utility or entertainment, draw people in by offering compelling capabilities or content, or enable people to do something they couldn't do before or in a way they couldn't do it before.


```
