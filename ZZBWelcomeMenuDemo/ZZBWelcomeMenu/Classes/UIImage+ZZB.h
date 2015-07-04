
#import <UIKit/UIKit.h>

@interface UIImage (ZZB)

/**
 *  截图功能，根据尺寸截取view成为一张图片
 *
 *  @param view 需要截取的View
 *
 *  @return 新生成的已截取的图片
 */
+(UIImage *)imageWithCaputureView:(UIView *)view;

@end
