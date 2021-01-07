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

@property (nonatomic, strong) UIStackView *uiStackView;
@property (nonatomic, strong) GGStackView *ggStackView;

@end

@implementation GGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeSubview];
    
    [self testUIStackView];
}

- (void)didClickView:(UIButton *)view {
    NSInteger customSpacing = (arc4random() % 10) * 10;
    [view setTitle:[NSString stringWithFormat:@"%ld", customSpacing] forState:UIControlStateNormal];
    
    if (_ggStackView) {
        // Can always be used, supported since iOS9.0
        [_ggStackView setCustomSpacing:customSpacing afterView:view];
    }
    
    if (_uiStackView) {
        // Can always be used, supported since iOS9.0
        [_uiStackView gg_setCustomSpacing:customSpacing afterView:view];
        
        // You can also use this method with confidence, if you don’t care about the warning ⚠️
        // In fact, it supports iOS9.0 and will not crash
        [_uiStackView setCustomSpacing:customSpacing afterView:view];
    }
    
//    [UIView animateWithDuration:0.1 animations:^{
//        [_ggStackView setNeedsLayout];
//        [_ggStackView layoutIfNeeded];
//    }];
}

- (void)testUIStackView {
    _uiStackView = [[UIStackView alloc] initWithArrangedSubviews:self.viewArray];
    [self configStackView:_uiStackView];
}

- (void)testGGStackView {
    _ggStackView = [[GGStackView alloc] initWithArrangedSubviews:self.viewArray];
    [self configStackView:_ggStackView];
}

- (void)configStackView:(UIStackView *)stackView {
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 20;
    stackView.alignment = UIStackViewAlignmentCenter;
    
    [self.view addSubview:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100].active = YES;
    [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30].active = YES;
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
