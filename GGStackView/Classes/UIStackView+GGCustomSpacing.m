//
//  UIStackView+GGCustomSpacing.m
//  GGStackView
//
//  Created by 张贵广 on 2021/01/07.
//

#import "UIStackView+GGCustomSpacing.h"
#import <objc/runtime.h>

@interface UIStackView ()
@property (nonatomic, strong) NSMapTable<UIView *, NSNumber *> *gg_customSpacing;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation UIStackView (GGCustomSpacing)
#pragma clang diagnostic pop


+ (void)load {
    if (@available(iOS 11.0, *)) {
        // Nothing
    } else {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            SEL selectors[] = {
                @selector(updateConstraints),
                @selector(removeArrangedSubview:),
                @selector(setCustomSpacing:afterView:),
                @selector(customSpacingAfterView:),
            };
            
            for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
                SEL originalSelector = selectors[index];
                SEL swizzledSelector = NSSelectorFromString([@"gg_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
                Method originalMethod = class_getInstanceMethod(self, originalSelector);
                Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
                if (originalMethod) {
                    method_exchangeImplementations(originalMethod, swizzledMethod);
                } else {
                    IMP impletor = method_getImplementation(swizzledMethod);
                    class_addMethod([self class], originalSelector, impletor, "v@:");
                }
            }
        });
    }
}

#pragma mark - Override

- (void)gg_updateConstraints {
    [self gg_updateConstraints];
    
    /**
     layout constraints should like this
     
        next.top = target.bottom + spacing
        or
        next.leading = target.trailing + spacing
     */
    __block NSMutableArray<NSLayoutConstraint *> *firstContstraints = nil;
    [self.gg_customSpacing.keyEnumerator.allObjects enumerateObjectsUsingBlock:^(UIView *view, NSUInteger _, BOOL *stop) {
        if (![view.superview isEqual:self]) {
            // view is removed from self
            [self.gg_customSpacing removeObjectForKey:view];
            return; // continue
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
            matchedConstraints.firstObject.constant = [self gg_customSpacingAfterView:view];
            [firstContstraints removeObjectsInArray:matchedConstraints];
        }
    }];
}

- (void)gg_removeArrangedSubview:(UIView *)view {
    [self.gg_customSpacing removeObjectForKey:view];
    [self gg_removeArrangedSubview:view];
}

#pragma mark - Custom Spacing

- (void)gg_setCustomSpacing:(CGFloat)spacing afterView:(UIView *)view {
    if (@available(iOS 11.0, *)) {
        [self setCustomSpacing:spacing afterView:view];
        return;
    }
    if (![self.arrangedSubviews containsObject:view]) {
        return;
    }
    [self.lazy_customSpacing setObject:@(spacing) forKey:view];
    [self setNeedsUpdateConstraints];
}

- (CGFloat)gg_customSpacingAfterView:(UIView *)view {
    if (@available(iOS 11.0, *)) {
        return [self customSpacingAfterView:view];
    } else {
        return [[self.gg_customSpacing objectForKey:view] doubleValue];
    }
}


#pragma mark - Property

- (NSMapTable<UIView *,NSNumber *> *)gg_customSpacing {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSMapTable<UIView *,NSNumber *> *)lazy_customSpacing {
    NSMapTable *temp = objc_getAssociatedObject(self, @selector(gg_customSpacing));
    if (!temp) {
        temp = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory capacity:0];
        objc_setAssociatedObject(self, @selector(gg_customSpacing), temp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return temp;
}

@end
