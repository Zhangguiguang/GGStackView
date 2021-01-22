//
//  UIStackView+GGCustomSpacing.h
//  GGStackView
//
//  Created by 张贵广 on 2021/01/07.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static const CGFloat GGStackViewSpacingUseDefault = FLT_MAX;

@interface UIStackView (GGCustomSpacing)

/// 与系统方法 -setCustomSpacing:afterView: 功能一模一样，但是它兼容 iOS11.0 以下的版本
/// The function is exactly the same as the system method -setCustomSpacing:afterView:, but it is compatible with versions below iOS11.0
- (void)gg_setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview;
- (CGFloat)gg_customSpacingAfterView:(UIView *)arrangedSubview;


/// 你也可以放心大胆的使用这个方法，如果你不在意警告的话 ⚠️
/// You can also use this method with confidence, if you don’t care about the warning ⚠️
- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview API_AVAILABLE(ios(9.0));
- (CGFloat)customSpacingAfterView:(UIView *)arrangedSubview API_AVAILABLE(ios(9.0));

@end

NS_ASSUME_NONNULL_END
