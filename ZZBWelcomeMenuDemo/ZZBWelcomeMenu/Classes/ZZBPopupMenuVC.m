
#import "ZZBPopupMenuVC.h"
#import "MenuButton.h"

@interface ZZBPopupMenuVC ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *itemButtons;

@property(assign,nonatomic)NSUInteger upIndex;

@property(assign,nonatomic)NSUInteger downIndex;

@property(strong,nonatomic)UIImageView *closeImgView;

@property(strong,nonatomic)NSArray *ary;

@end

@implementation ZZBPopupMenuVC

- (NSMutableArray *)itemButtons
{
    if (_itemButtons == nil) {
        _itemButtons = [NSMutableArray array];
    }
    return _itemButtons;
}

-(NSArray *)ary{
    
    if (_ary==nil) {
        
        _ary = [NSArray array];
        
        _ary = @[@"18001",@"18002",@"18003",@"18004",@"18005",@"18006"];
    }
    
    return _ary;
}

-(void)loadView{
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    //获取截取的背景图片，便于达到模糊背景效果
    UIImageView *imgView = [[UIImageView alloc]initWithImage:_backImg];
    //模糊效果层
    UIView *blurView =[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [blurView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.8]];
    
    [imgView addSubview:blurView];
    [view addSubview:imgView];
    
    self.view = view;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //添加菜单按钮
    [self setMenu];
    //添加底部关闭按钮
    [self insertCloseImg];
    
    //定时器控制每个按钮弹出的时间
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(popupBtn) userInfo:nil repeats:YES];
    
    //添加手势点击事件
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan:)];
    [self.view addGestureRecognizer:touch];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.6 animations:^{
        
        _closeImgView.transform = CGAffineTransformRotate(_closeImgView.transform, M_PI);
    }];
}

- (void)insertCloseImg{
    
    UIImage *img = [UIImage imageNamed:@"tabbar_compose_background_icon_close"];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    
    imgView.frame = CGRectMake(self.view.center.x-20, self.view.frame.size.height-30, 30, 30);
    
    [self.view addSubview:imgView];
    
    _closeImgView = imgView;
    
}


- (void)popupBtn{
    
    if (_upIndex == self.itemButtons.count) {
        
        [self.timer invalidate];
        
        _upIndex = 0;
        
        return;
    }
    
    MenuButton *btn = self.itemButtons[_upIndex];
    
    [self setUpOneBtnAnim:btn];
    
    _upIndex++;
}

//设置按钮从第一个开始向上滑动显示
- (void)setUpOneBtnAnim:(UIButton *)btn
{
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        btn.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        
        //获取当前显示的菜单控件的索引
        _downIndex = self.itemButtons.count - 1;
    }];
    
}


//按九宫格计算方式排列按钮
- (void)setMenu{
    
    int cols = 3;
    int col = 0;
    int row = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat wh = 90;
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - cols * wh) / (cols + 1);
    CGFloat oriY = 300;
    
    for (int i = 0; i < self.ary.count; i++) {
        
        NSArray *arrTitle = @[@"说说",@"收藏",@"会员",@"点赞",@"购物",@"更多"];
        
        
        MenuButton *btn = [MenuButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *img = [UIImage imageNamed:self.ary[i]];
        NSString *title = arrTitle[i];
        
        [btn setImage:img forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        
        col = i % cols;
        row = i / cols;
        
        x = margin + col * (margin + wh);
        y = row * (margin + wh) + oriY;
        
        btn.frame = CGRectMake(x, y, wh, wh);
        
        btn.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
        
        btn.tag = 1000 + i;
        
        [btn addTarget:self action:@selector(touchDownBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.itemButtons addObject:btn];
        
        [self.view addSubview:btn];
        
    }
    
}

//点击按钮进行放大动画效果直到消失
- (void)touchDownBtn:(MenuButton *)btn{
    
    NSLog(@"%ld为btn.tag的值，根据不同的按钮需要做什么操作可以写这里",btn.tag);
    
    [UIView animateWithDuration:0.5 animations:^{
        btn.transform = CGAffineTransformMakeScale(2.0, 2.0);
        btn.alpha = 0;
    }];
}


//设置按钮从后往前下落
- (void)returnUpVC{
    
    if (_downIndex == -1) {
        
        [self.timer invalidate];
        
        return;
    }
    
    MenuButton *btn = self.itemButtons[_downIndex];
    
    [self setDownOneBtnAnim:btn];
    
    _downIndex--;
}

//按钮下滑并返回上一个控制器
- (void)setDownOneBtnAnim:(UIButton *)btn
{
    
    [UIView animateWithDuration:0.6 animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }];
    
}

//点击事件返回上一控制器,并且旋转145弧度关闭按钮
-(void)touchesBegan:(UITapGestureRecognizer *)touches{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(returnUpVC) userInfo:nil repeats:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _closeImgView.transform = CGAffineTransformRotate(_closeImgView.transform, -M_PI_2*1.5);
    }];
    
}


@end
