//
//  BJLoginViewController.m
//  LivePlayerDemo
//
//  Created by MingLQ on 2016-07-01.
//  Copyright © 2016年 Baijiahulian. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "BJLoginViewController.h"

#import "BJLoginView.h"

@interface BJLoginViewController () <UITextFieldDelegate>

@property (nonatomic) BJLoginView *loginView;

@end

@implementation BJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.loginView = [BJLoginView new];
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    
    UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer new];
    [self.view addGestureRecognizer:tapGesture];
    UIPanGestureRecognizer *panGesture = [UIPanGestureRecognizer new];
    [self.view addGestureRecognizer:panGesture];
    [[RACSignal merge:@[ tapGesture.rac_gestureSignal,
                         panGesture.rac_gestureSignal ]]
     subscribeNext:^(UIGestureRecognizer *gesture) {
         @strongify(self);
         [self.view endEditing:YES];
     }];
    
    self.loginView.codeTextField.delegate = self;
    self.loginView.nameTextField.delegate = self;
    
    [[self.loginView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self login];
     }];
}

#pragma mark -

- (void)login {
    [self.view endEditing:YES];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.loginView.codeTextField) {
        [self.loginView.nameTextField becomeFirstResponder];
    }
    else if (textField == self.loginView.nameTextField) {
        [self login];
    }
    return NO;
}

@end
