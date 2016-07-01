//
//  BJLoginViewController.m
//  LivePlayerDemo
//
//  Created by MingLQ on 2016-07-01.
//  Copyright © 2016年 Baijiahulian. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "BJLoginViewController.h"

#import "BJLoginView.h"

@interface BJLoginViewController ()

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
}

@end
