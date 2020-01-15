# YFPopView

iOS、macOS弹窗控件封装

## What For

弹窗控件动画、逻辑封装，调用者仅需要对弹窗控件的展示view进行实现，无需关心动画、显示、隐藏的逻辑

## Features

* 支持四边弹出、淡入淡出、缩放动画
* 支持autolayout、frame布局
* 支持macOS、iOS
* 支持OC、Swift
* 可用于弹窗、toast、loadingHUD等需求，

![img](https://github.com/piuSora/YFPopView/blob/master/DisplayGif.gif)

## Installation

### Pod

将
`pod 'YFPopView'`
添加到podfile中并执行pod install

### Manually

将下载的Demo中```YFPopView```文件夹拖到项目中 

## Usage

* 在需要使用的地方```import "YFPopView.h"```

* Coding

```obj-c
//obj-c
    // create your custom view
    //...
    CustomView *customView = [[CustomView alloc] initWithFrame:frame];
    YFPopView *popView = [[YFPopView alloc] initWithAnimationView:customView];
    [popView showPopViewOn:keyWindow];
```
```swift
//swift
    // create your custom view
    //...
    let customView = CustomView.init(frame: frame)
    let popView = YFPopView.init(animationView: yourView)
    popView.show(on: UIApplication.shared.keyWindow)
```
详细使用方法参见Demo

