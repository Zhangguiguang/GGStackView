//
//  GGViewController.m
//  GGStackView
//
//  Created by zhangguiguang on 01/07/2021.
//  Copyright (c) 2021 zhangguiguang. All rights reserved.
//

#import "GGViewController.h"
#import <GGStackView/GGStackView.h>
#import <GGStackView/UIStackView+GGCustomSpacing.h>

@interface GGViewController ()

@property (nonatomic, strong) NSMutableArray<UIView *> *viewArray;

@property (nonatomic, strong) GGStackView *stackView;

@end

@implementation GGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeSubview];
    [self makeStackView];
}

- (void)didClickView:(UIButton *)view {
    NSInteger customSpacing = (arc4random() % 10) * 10;
    [view setTitle:[NSString stringWithFormat:@"%ld", customSpacing] forState:UIControlStateNormal];
    
    // Always can use, support from iOS 9.0
//    [self.stackView ggSetCustomSpacing:customSpacing afterView:view];
    [self.stackView gg_SetCustomSpacing:customSpacing afterView:view];
    
    // Only can use after iOS 11.0
//    if (@available(iOS 11.0, *)) {
//        [self.stackView setCustomSpacing:customSpacing afterView:view];
//    }
    
//    [UIView animateWithDuration:0.1 animations:^{
//        [self.stackView setNeedsLayout];
//        [self.stackView layoutIfNeeded];
//    }];
}

- (void)makeStackView {
    _stackView = [[GGStackView alloc] initWithArrangedSubviews:self.viewArray];
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.spacing = 20;
    _stackView.alignment = UIStackViewAlignmentCenter;
    
    [self.view addSubview:_stackView];
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [_stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100].active = YES;
    [_stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30].active = YES;
}

- (void)makeSubview {
    [self makeViewWithColor:[UIColor redColor]];
    [self makeViewWithColor:[UIColor greenColor]];
    [self makeViewWithColor:[UIColor orangeColor]];
    [self makeViewWithColor:[UIColor purpleColor]];
    [self makeViewWithColor:[UIColor cyanColor]];
    [self makeViewWithColor:[UIColor grayColor]];
}

- (void)makeViewWithColor:(UIColor *)color {
    UIButton *view = [UIButton new];
    view.backgroundColor = color;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view.widthAnchor constraintEqualToConstant:44].active = YES;
    [view.heightAnchor constraintEqualToConstant:44].active = YES;
    [view addTarget:self action:@selector(didClickView:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!_viewArray) {
        _viewArray = [NSMutableArray new];
    }
    [_viewArray addObject:view];
}

@end
