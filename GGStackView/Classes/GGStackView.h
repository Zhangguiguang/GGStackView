//
//  GGStackView.h
//  GGStackView
//
//  Created by 张贵广 on 2021/01/06.
//

#import <UIKit/UIKit.h>
#import <GGStackView/UIStackView+GGCustomSpacing.h>

NS_ASSUME_NONNULL_BEGIN

@interface GGStackView : UIStackView

/// 与系统方法 -setCustomSpacing:afterView: 功能一模一样，但是它兼容 iOS11.0 以下的版本
/// The function is exactly the same as the system method -setCustomSpacing:afterView:, but it is compatible with versions below iOS11.0
- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview API_AVAILABLE(ios(9.0));

- (CGFloat)customSpacingAfterView:(UIView *)arrangedSubview API_AVAILABLE(ios(9.0));

@end

NS_ASSUME_NONNULL_END
