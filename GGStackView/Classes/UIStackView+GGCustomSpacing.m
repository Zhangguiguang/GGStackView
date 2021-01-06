//
//  UIStackView+GGCustomSpacing.m
//  GGStackView
//
//  Created by 张贵广 on 2021/01/07.
//

#import "UIStackView+GGCustomSpacing.h"
#import <objc/runtime.h>

@interface UIStackView ()

@property (nonatomic, strong) NSMapTable<UIView *, NSNumber *> *gg_CustomSpacing;

@end

@implementation UIStackView (GGCustomSpacing)

+ (void)load {
    SEL selectors[] = {
        @selector(updateConstraints),
        @selector(removeArrangedSubview:),
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"gg_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)gg_updateConstraints {
    [self gg_updateConstraints];
    
    /**
     layout constraints should like this
     
        next.top = target.bottom + spacing
        or
        next.leading = target.trailing + spacing
     */
    __block NSMutableArray<NSLayoutConstraint *> *firstContstraints = nil;
    [self.gg_CustomSpacing.keyEnumerator.allObjects enumerateObjectsUsingBlock:^(UIView *view, NSUInteger _, BOOL *stop) {
        if (![view.superview isEqual:self]) {
            // view is removed from self
            [self.gg_CustomSpacing removeObjectForKey:view];
            return;
        }
        if (firstContstraints == nil) {
            NSLayoutAttribute firstAttribute = self.axis == UILayoutConstraintAxisVertical ? NSLayoutAttributeTop : NSLayoutAttributeLeading;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstAttribute == %ld", firstAttribute];
            firstContstraints = [[self.constraints filteredArrayUsingPredicate:predicate] mutableCopy];
        }
        if (firstContstraints.count == 0) {
            *stop = YES; return; // break
        }
        
        NSLayoutAttribute secondAttribute = self.axis == UILayoutConstraintAxisVertical ? NSLayoutAttributeBottom : NSLayoutAttributeTrailing;
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.secondItem == %@ AND SELF.secondAttribute == %ld", view, secondAttribute];
        NSArray<NSLayoutConstraint *> *matchedConstraints = [firstContstraints filteredArrayUsingPredicate:predicate2];
        if (matchedConstraints.count > 0) {
            matchedConstraints.firstObject.constant = [self gg_CustomSpacingAfterView:view];
            [firstContstraints removeObjectsInArray:matchedConstraints];
        }
    }];
}

- (void)gg_removeArrangedSubview:(UIView *)view {
    [self.gg_CustomSpacing removeObjectForKey:view];
    [self gg_removeArrangedSubview:view];
}

#pragma mark - Custom Spacing

- (void)gg_SetCustomSpacing:(CGFloat)spacing afterView:(UIView *)view {
    if (![self.arrangedSubviews containsObject:view]) {
        return;
    }
    [self.gg_CustomSpacing setObject:@(spacing) forKey:view];
    [self setNeedsUpdateConstraints];
}

- (CGFloat)gg_CustomSpacingAfterView:(UIView *)view {
    return [[self.gg_CustomSpacing objectForKey:view] doubleValue];
}

- (NSMapTable<UIView *,NSNumber *> *)gg_CustomSpacing {
    NSMapTable *temp = objc_getAssociatedObject(self, _cmd);
    if (!temp) {
        temp = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory capacity:0];
        objc_setAssociatedObject(self, _cmd, temp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return temp;
}

@end
