//功能介绍：
//1.头像弹簧效果显示，标题随头像渐变显示,头像圆圈化并且加入边框
//2.跳转控制器按钮按顺序单个弹出显示，关闭界面按逆序单个弹走
//3.弹出按钮旋转效果
//4.利用了autolayout布局跟随弹出
//2015.06.23 by L、至尊宝(lzzbCoder)

#import "ZZBWelcomeVC.h"
#import "ZZBPopupMenuVC.h"
#import "UIImage+ZZB.h"

#define kTransform -80

@interface ZZBWelcomeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLbl;
@end

@implementation ZZBWelcomeVC

//设置头像的形状及边框色
- (void)setIconView:(UIImageView *)iconView{
    
    iconView.layer.cornerRadius = 50;
    iconView.layer.masksToBounds = YES;
    iconView.layer.borderWidth = 2;
    iconView.layer.borderColor = [UIColor orangeColor].CGColor;
    
    _iconView =iconView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化欢迎label为全透明
    self.welcomeLbl.alpha = 0.01;
    
    //使用弹簧动画效果实现头像的位移
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:2 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.iconView.transform = CGAffineTransformTranslate(_iconView.transform, 0, kTransform);
        self.welcomeLbl.transform = CGAffineTransformTranslate(_welcomeLbl.transform, 0, kTransform);
    } completion:^(BOOL finished) {
        
        //动画结束后设置欢迎label为不透明（使用首尾式动画区分block）
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.welcomeLbl.alpha = 1.0;
        [UIView commitAnimations];
        
    }];
    
}

#pragma mark 跳转发布控制器
- (IBAction)toSendView {
    
    ZZBPopupMenuVC *vc = [[ZZBPopupMenuVC alloc]init];
    
    UIImage *image = [UIImage imageWithCaputureView:self.view];
    
    vc.backImg = image;
    
    [self presentViewController:vc animated:NO completion:nil];
    
}

@end
