# YFPopView

## YFPopView for iOS (Objective-C)
### 自定义view边缘弹出、淡入淡出、缩放动画
![img](https://github.com/piuSora/YFPopView/blob/master/DisplayGif.gif)

### 使用
1 将下载的Demo中YFPopView文件夹拖动到项目中
2 新建自定义view(xib/code都可以)继承自YFPopView
3 在需要弹窗的地方执行以下代码
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
 
