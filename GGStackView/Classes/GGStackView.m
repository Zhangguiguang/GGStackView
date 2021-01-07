//
//  GGStackView.m
//  GGStackView
//
//  Created by 张贵广 on 2021/01/06.
//

#import "GGStackView.h"

@interface GGStackView ()
@property (nonatomic, strong) NSMapTable<UIView *, NSNumber *> *ggCustomSpacing;
@end

@implementation GGStackView

- (void)updateConstraints {
    [super updateConstraints];
    if (@available(iOS 11.0, *)) {
        return;
    }
    
    /**
     layout constraints should like this
     
        next.top = target.bottom + spacing
        or
        next.leading = target.trailing + spacing
     */
    __block NSMutableArray<NSLayoutConstraint *> *firstContstraints = nil;
    [_ggCustomSpacing.keyEnumerator.allObjects enumerateObjectsUsingBlock:^(UIView *view, NSUInteger _, BOOL *stop) {
        if (![view.superview isEqual:self]) {
            // view is removed from self
            [_ggCustomSpacing removeObjectForKey:view];
            return;
        }
        if (firstContstraints == nil) {
            NSLayoutAttribute firstAttribute = self.axis == UILayoutConstraintAxisVertical ? NSLayoutAttributeTop : NSLayoutAttributeLeading;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstAttribute == %ld", firstAttribute];
            firstContstraints = [[self.constraints filteredArrayUsingPredicate:predicate] mutableCopy];
        }
        if (firstContstraints.count == 0) {
            *stop = YES; return; // break;
        }
        
        NSLayoutAttribute secondAttribute = self.axis == UILayoutConstraintAxisVertical ? NSLayoutAttributeBottom : NSLayoutAttributeTrailing;
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.secondItem == %@ AND SELF.secondAttribute == %ld", view, secondAttribute];
        NSArray<NSLayoutConstraint *> *matchedConstraints = [firstContstraints filteredArrayUsingPredicate:predicate2];
        if (matchedConstraints.count > 0) {
            matchedConstraints.firstObject.constant = [self customSpacingAfterView:view];
            [firstContstraints removeObjectsInArray:matchedConstraints];
        }
    }];
}

- (void)removeArrangedSubview:(UIView *)view {
    [_ggCustomSpacing removeObjectForKey:view];
    [super removeArrangedSubview:view];
}

#pragma mark - Custom Spacing

- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)view {
    if (@available(iOS 11.0, *)) {
        [super setCustomSpacing:spacing afterView:view];
        return;
    }
    if (![self.arrangedSubviews containsObject:view]) {
        return;
    }
    [self.ggCustomSpacing setObject:@(spacing) forKey:view];
    [self setNeedsUpdateConstraints];
}

- (CGFloat)customSpacingAfterView:(UIView *)arrangedSubview {
    if (@available(iOS 11.0, *)) {
        return [super customSpacingAfterView:arrangedSubview];
    } else {
        return [[_ggCustomSpacing objectForKey:arrangedSubview] doubleValue];
    }
}

#pragma mark - Property

- (NSMapTable<UIView *,NSNumber *> *)ggCustomSpacing {
    if (!_ggCustomSpacing) {
        _ggCustomSpacing = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory capacity:0];
    }
    return _ggCustomSpacing;
}

@end
