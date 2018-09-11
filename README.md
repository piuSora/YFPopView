# YFPopView

## YFPopView for iOS (Objective-C)
### 自定义view边缘弹出、淡入淡出、缩放动画
![img](https://github.com/piuSora/YFPopView/blob/master/DisplayGif.gif)

### 集成  

#### Pod  
将
`pod 'YFPopView', '~> 1.0.2'`
添加到podfile中并执行pod install
#### 手动集成  
将下载的Demo中YFPopView文件夹拖到项目中 

###使用
1 新建自定义view(xib/code都可以)继承自YFPopView  
2 在需要弹窗的地方执行以下代码  
```
    // code
    PopCustomView *yourView = [[PopCustomView alloc] init];
    // xib
    PopCustomView *yourView = [[PopCustomView instanceViewWithNibName:@"YourNibName"] init];
    //set your subview as YFPopView's animated view
    yourView.animatedView = yourView.subview;
    [yourView showPopViewOn:keyWindow];
```
详细使用方法参见Demo
 
