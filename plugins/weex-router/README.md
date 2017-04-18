# weex-router

适用于weex的声明式路由组件。

特点：

* 声明式
* 基于组件的可组合性


```html
<template>
  <div>
      <router>
          <div class="nav">
            <router-link to="/home">home</router->
            <router-link to="/about">about</router->
          </div>
          <match pattern="/home"><home></home></match>
          <match pattern="/about"><about></about></match>
      </router>
  </div>
</templater>

<script>
require('weex-router')
</script>
```


## Getting Started

weexpack 安装

```
$ weexpack plugin add weex-router
```

## 组件

核心组件

* router
* link
* match
* miss


### Router

Router负责监听地址的变化，执行跳转运画，渲染页面

```html
<router basename="/app" >
  <div class="app"><div>
</router>
```

- basename: string 所有路由的基础地址


### router-link
类似一个a标签，使用link声明跳转地址和跳转方式

```html
<router-link to="/about" activeClassName="active">
  About
</router-link>
```


- to: string 

跳转的路径

```html
<router-link to="/courses" >课程</router-link>
```



- action: 选择路由的类型， push | pop | tab, 默认为push

```html
<router-link to="/courses" action="push">课程</router-link>
```

- animated: boolean 是否使用动画效果

```html
<router-link to="/courses" animated="ture">课程</router-link>
```


### router-match

match根据路由地址负责渲染或者不渲染它所拥有的组件， Match是可以嵌套的


- pattern: string

匹配的路由，支持正则表达式，支持[path-to-regexp](https://www.npmjs.com/package/path-to-regexp)

```html
<router-match pattern="/users/:id" ><user></user></router-match>
```


### router-miss

如果所有的Match组件都没有配置到地址，那么Miss组件会被渲染

```html
<router>
   <rouer-match pattern="/foo"/><foo></foo></rouer-match>
   <rouer-match pattern="/bar"><bar></bar></rouer-match>
   <router-miss><nomatch></nomatch></router-miss>
</router>
```



## JS API

 - push(url, options)

```javascript
var Router = require("weex-router")
Router.push('/about',{
  animated:true,
  params:{
    user:"123"
  }
})
```

- pop(options)

```javascript
var Router = require("weex-router")
Router.pop()
```




- params

```javascript
//获取相前渲染的参数
var Router = require("weex-router")
console.log(Router.params)

```


