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
    
    /**
     layout constraints should like this
     
        next.top = target.bottom + spacing
        or
        next.leading = target.trailing + spacing
     */
    __block NSArray<NSLayoutConstraint *> *firstContstraints = nil;
    [self.ggCustomSpacing.keyEnumerator.allObjects enumerateObjectsUsingBlock:^(UIView *view, NSUInteger _1, BOOL *_2) {
        if (![view.superview isEqual:self]) {
            // view is removed from self
            [self.ggCustomSpacing removeObjectForKey:view];
            return;
        }
        if (firstContstraints == nil) {
            NSLayoutAttribute firstAttribute = self.axis == UILayoutConstraintAxisVertical ? NSLayoutAttributeTop : NSLayoutAttributeLeading;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstAttribute == %ld", firstAttribute];
            firstContstraints = [self.constraints filteredArrayUsingPredicate:predicate];
        }
        
        NSLayoutAttribute secondAttribute = self.axis == UILayoutConstraintAxisVertical ? NSLayoutAttributeBottom : NSLayoutAttributeTrailing;
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.secondItem == %@ AND SELF.secondAttribute == %ld", view, secondAttribute];
        NSArray<NSLayoutConstraint *> *matchedConstraints = [firstContstraints filteredArrayUsingPredicate:predicate2];
        if (matchedConstraints.count > 0) {
            matchedConstraints.firstObject.constant = [self ggCustomSpacingAfterView:view];
        }
    }];
}

- (void)removeArrangedSubview:(UIView *)view {
    [self.ggCustomSpacing removeObjectForKey:view];
    [super removeArrangedSubview:view];
}

#pragma mark - Custom Spacing

- (void)ggSetCustomSpacing:(CGFloat)spacing afterView:(UIView *)view {
    if (![self.arrangedSubviews containsObject:view]) {
        return;
    }
    if (self.spacing == spacing) {
        if ([self.ggCustomSpacing objectForKey:view] == nil) {
            return;
        }
    }
    [self.ggCustomSpacing setObject:@(spacing) forKey:view];
    [self setNeedsUpdateConstraints];
}

- (CGFloat)ggCustomSpacingAfterView:(UIView *)arrangedSubview {
    return [[self.ggCustomSpacing objectForKey:arrangedSubview] doubleValue];
}

- (NSMapTable<UIView *,NSNumber *> *)ggCustomSpacing {
    if (!_ggCustomSpacing) {
        _ggCustomSpacing = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory capacity:0];
    }
    return _ggCustomSpacing;
}

@end
