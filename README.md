# MLMSegmentPage
manage your controllers or views

* 快速集成顶部菜单栏
* 拆分为MLMSegementHead和MLMSegmenScroll，分别设置，使用更灵活
* 使用NSCache统计页面加载

## 效果
 * 单独创建自己的ViewController,低耦合，具体操作在自己的ViewController中实现
 * 直接创建UIView添加到视图中
 * 根据需求选择不同的样式，具体效果可以自己定制
 * 设置初次进入显示的页面，
 * 设置初次进入加载的页面数目，和滑动过程中页面中保留的页面数目

## 样式

```objc
//风格
typedef enum : NSUInteger {
    /**
     *  默认
     */
    SegmentHeadStyleDefault,
    /**
     *  line(下划线)
     */
    SegmentHeadStyleLine,
    /**
     *  arrow(箭头)
     */
    SegmentHeadStyleArrow,
    /**
     *  Slide(滑块)
     */
    SegmentHeadStyleSlide
} MLMSegmentHeadStyle;
//布局样式
typedef enum : NSUInteger {
    /*
     * 默认均分,根据maxTitles计算宽度，均分
     */
    MLMSegmentLayoutDefault,
    
    /*
     * 居中(标题不足一屏时选择样式，反之设置后按照居左)
     */
    MLMSegmentLayoutCenter,
    /*
     * 居左
     */
    MLMSegmentLayoutLeft
    
} MLMSegmentLayoutStyle;
```
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
将 MLMSegmentManager.h 加入工程中，执行代码

* 基础设置
```objc
    MLMSegmentHead *segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) titles:list headStyle:_style layoutStyle:_layout];
    
    MLMSegmentScroll *segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    
    [MLMSegmentManager associateHead:segHead withScroll:segScroll completion:^{
        [self.view addSubview:segHead];
        [self.view addSubview:segScroll];
    }];
```

#### 滑动中加载页面
* 默认设置为第一次进入只加载当前显示的页面，即 segScroll.loadAll = NO;
* 默认滑动过程中最大缓存页面是所有页面，即 segScroll.countLimit = vcsOrviews.count;即segScroll.loadAll = 

### 其他设置
* 具体设置，参照代码
* 注意，创建MLMSegmentHead和MLMSegmentScroll，并使用MLMSegmentManager绑定两个View，在block中设置addSubView:操作

### 未来将添加
* 添加自定义button的类，用于更复杂的头部菜单
* 添加moreButton，用于添加，删除头部菜单的数据源
      
## 反馈
* 如果您在使用过程中发现任何bug或者有好的改动建议，希望您可以issue我或者发邮件到920459250@qq.com反馈给我 
      
      
