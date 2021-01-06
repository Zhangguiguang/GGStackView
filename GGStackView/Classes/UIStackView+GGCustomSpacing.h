//
//  UIStackView+GGCustomSpacing.h
//  GGStackView
//
//  Created by 张贵广 on 2021/01/07.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIStackView (GGCustomSpacing)

/// 与系统方法 -setCustomSpacing:afterView: 功能一模一样，但是它兼容 11.0 以下的 iOS 版本
- (void)gg_SetCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview;

- (CGFloat)gg_CustomSpacingAfterView:(UIView *)arrangedSubview;

@end

NS_ASSUME_NONNULL_END
