# MLMSegmentPage
manage your controllers or views

* 快速集成顶部菜单栏

## 效果
 * 单独创建自己的ViewController,低耦合，具体操作在自己的ViewController中实现
 * 直接创建UIView添加到视图中
 * 根据需求选择不同的样式，具体效果可以自己定制
 * 设置初次进入显示的页面，
 * 设置初次进入加载的页面数目，和滑动过程中页面中保留的页面数目

## 预览

![image](https://github.com/MengLiMing/MLMSegmentPage/blob/master/default.gif)
![image](https://github.com/MengLiMing/MLMSegmentPage/blob/master/line.gif)
![image](https://github.com/MengLiMing/MLMSegmentPage/blob/master/arrow.gif)
![image](https://github.com/MengLiMing/MLMSegmentPage/blob/master/slide.gif)

## 安装

将 MLMSegmentPageView 拖入Xcode工程中

## 使用
将 MLMSegmentPage.h 加入工程中，执行代码

* 基础设置

      MLMSegmentPage *pageView = [[MLMSegmentPage alloc] initSegmentWithFrame:rect titlesArray:titles vcOrviews:vcsOrviews];
      
      [self.view addSubview:_pageView];
        
* 其他设置

      
