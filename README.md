# YFPopView

## What For

可自定义视图的弹窗控件支持边缘弹出、淡入淡出、缩放动画

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
    PopCustomView *yourView = [[PopCustomView alloc] init];
    YFPopView *popView = [[YFPopView alloc] initWithSubView:yourView];
    [popView showPopViewOn:keyWindow];
```
```swift
//swift
    // create your custom view
    let yourView = PopCustomView.init()
    let popView = YFPopView.init(subView: yourView)
    yourView.show(on: UIApplication.shared.keyWindow)
```
详细使用方法参见Demo

