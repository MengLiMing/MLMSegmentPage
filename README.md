# MLMSegmentPage
manage your controllers or views

* 快速集成顶部菜单栏
* 拆分为MLMSegementHead和MLMSegmenScroll，分别设置，使用更灵活

## 效果
 * 单独创建自己的ViewController,低耦合，具体操作在自己的ViewController中实现
 * 直接创建UIView添加到视图中
 * 根据需求选择不同的样式，具体效果可以自己定制
 * 设置初次进入显示的页面，
 * 设置初次进入加载的页面数目，和滑动过程中页面中保留的页面数目

## 部分样式预览

![image](https://github.com/MengLiMing/MLMSegmentPage/blob/master/gif/Center_Line.gif)
![image](https://github.com/MengLiMing/MLMSegmentPage/blob/master/gif/Center_Slide.gif)
![image](https://github.com/MengLiMing/MLMSegmentPage/blob/master/gif/Left_Slide.gif)
![image](https://github.com/MengLiMing/MLMSegmentPage/blob/master/gif/Left_Line.gif)
![image](https://github.com/MengLiMing/MLMSegmentPage/blob/master/gif/Center_Default.gif)
![image](https://github.com/MengLiMing/MLMSegmentPage/blob/master/gif/Center_Arrow.gif)
![image](https://github.com/MengLiMing/MLMSegmentPage/blob/master/gif/Default_Line.gif)
![image](https://github.com/MengLiMing/MLMSegmentPage/blob/master/gif/Default_Slide.gif)


## 安装

将 MLMSegmentPageView 拖入Xcode工程中

## 使用
将 MLMSegmentPage.h 加入工程中，执行代码

* 基础设置
```objc
MLMSegmentPage *pageView = [[MLMSegmentPage alloc] initSegmentWithFrame:rect titlesArray:titles vcOrviews:vcsOrviews];
      
[self.view addSubview:_pageView];
```

#### 滑动中加载页面
* 默认设置为第一次进入只加载当前显示的页面，即 pageView.loadAll = NO;
* 默认滑动过程中最大缓存页面是所有页面，即 pageView.countLimit = vcsOrviews.count;


### 其他设置
```objc
//代理
pageView.delegate = self;
//通过代理方法可以获取当前视图的下标
- (void)selectedIndex:(NSInteger)index

//设置风格
pageView.headStyle = 0 - 3；

//初始化 - 显示的页面
pageView.showIndex = *;

//设置一个屏幕显示的最大页面数目
pageView.maxTitleNum = 4;

```

### 不同风格的参考设置
* SegmentHeadStyleDefault
```objc
pageView.fontScale = 1.2;
pageView.fontSize = 12;
pageView.deselectColor = [UIColor grayColor];
pageView.selectColor = [UIColor blackColor];    
```

* SegmentHeadStyleLine
```objc
//下滑线的设置
pageView.lineScale = .9;
pageView.lineHeight = 2;

pageView.fontScale = .85;
pageView.fontSize = 14;
pageView.deselectColor = [UIColor grayColor];
pageView.selectColor = [UIColor blackColor];
```

* SegmentHeadStyleArrow
```objc
pageView.arrowColor = [UIColor blackColor];
```

* SegmentHeadStyleSlide
```objc
pageView.slideHeight = rect.size.height * 0.8;
//pageView.slideCorner = 0;
pageView.slideScale = .95;
          
pageView.fontSize = 12;            
pageView.selectColor = [UIColor whiteColor];
pageView.deselectColor = [UIColor blackColor];
```
      
## 反馈
* 如果您在使用过程中发现任何bug或者有好的改动建议，希望您可以issue我或者发邮件到920459250@qq.com反馈给我 
      
      
