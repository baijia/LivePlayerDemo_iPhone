//
//  BJLoginViewController.m
//  LivePlayerDemo
//
//  Created by MingLQ on 2016-07-01.
//  Copyright © 2016年 Baijiahulian. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import <BJHL-LivePlayer-iOS/BJHL-LivePlayer-iOS.h>
#import <BJHL-LivePlayer-iOS/NSObject+lp_M9Dev.h>
#import <BJHL-LivePlayer-iOS/UIKit+lp_M9Dev.h>

#import "BJLoginViewController.h"

#import "BJLoginView.h"

static NSString * const BJCloudBaseURL_TEST = @"http://test-api.baijiacloud.com/";
static NSString * const BJCloudBaseURL_BETA = @"http://beta-api.baijiacloud.com/";
static NSString * const BJCloudBaseURL = @"http://api.baijiacloud.com/";

static NSString * const BJCodeKey = @"BJCode";
static NSString * const BJNameKey = @"BJName";

@interface BJLoginViewController () <UITextFieldDelegate>

@property (nonatomic) AFHTTPSessionManager *urlSessionManager;

@property (nonatomic) BJLoginView *loginView;

@end

@implementation BJLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
#if DEBUG
        NSURL *baseURL = [NSURL URLWithString:BJCloudBaseURL_TEST];
#else
        NSURL *baseURL = [NSURL URLWithString:BJCloudBaseURL];
#endif
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL
                                                          sessionConfiguration:config];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *code = [userDefaults stringForKey:BJCodeKey];
    NSString *name = [userDefaults stringForKey:BJNameKey];
    
    self.loginView = [BJLoginView new];
    self.loginView.codeTextField.text = code;
    self.loginView.nameTextField.text = name;
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.loginView.codeTextField.text forKey:BJCodeKey];
    [userDefaults setObject:self.loginView.nameTextField.text forKey:BJNameKey];
    [userDefaults synchronize];
    
    if (!self.loginView.codeTextField.text.length) {
        [self.loginView.codeTextField becomeFirstResponder];
        return;
    }
    
    if (!self.loginView.nameTextField.text.length) {
        [self.loginView.nameTextField becomeFirstResponder];
        return;
    }
    
    [self.view endEditing:YES];
    self.loginView.codeTextField.enabled = NO;
    self.loginView.nameTextField.enabled = NO;
    self.loginView.loginButton.enabled = NO;
    
    [self loginWithJoinCode:self.loginView.codeTextField.text
                   userName:self.loginView.nameTextField.text];
}

- (void)loginWithJoinCode:(NSString *)joinCode userName:(NSString *)userName {
    self.loginView.codeTextField.enabled = YES;
    self.loginView.nameTextField.enabled = YES;
    self.loginView.loginButton.enabled = YES;
    
    LPDeployEnvType deployType = LP_DEPLOY_WWW;
#if DEBUG
    // LPDeployEnvType deployType = LP_DEPLOY_TEST;
#endif
    
    @weakify(self);
    [[LPLivePlayerSDK sharedInstance] enterRoomWithJoinCode:joinCode
                                                   userName:userName
                                                 deployType:deployType
                                                 completion:^(BOOL suc, LPError * _Nullable error)
     {
         @strongify(self);
         NSLog(@"enter room <#%@#>", suc ? @"success" : error);
         if (!suc) {
             [self showMessage:error.message];
         }
     }];
}

- (void)showMessage:(NSString *)message {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    hud.mode = MBProgressHUDModeText;
    hud.minShowTime = 0.5;
    hud.removeFromSuperViewOnHide = YES;
    // hud.passThroughTouches = YES;
    
    // hud.labelText = message;
    hud.detailsLabel.text = message;
    hud.detailsLabel.font = hud.label.font;
    hud.detailsLabel.textColor = hud.label.textColor;
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:3.0];
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

#pragma mark - <LPLivePlayerDelegate>

- (NSArray<LPShareItem *> *)lp_shareItems {
    return @[ [LPShareItem shareItemWithTitle:@"微信" icon:[UIImage lp_imageWithColor:[UIColor greenColor]]],
              [LPShareItem shareItemWithTitle:@"QQ" icon:[UIImage lp_imageWithColor:[UIColor blueColor]]],
              [LPShareItem shareItemWithTitle:@"新浪微博" icon:[UIImage lp_imageWithColor:[UIColor yellowColor]]],
              [LPShareItem shareItemWithTitle:@"AirDrop" icon:[UIImage lp_imageWithColor:[UIColor grayColor]]] ];
}

- (void)lp_didSelectShareItem:(LPShareItem *)shareItem presentingViewController:(UIViewController *)presentingViewController {
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), shareItem.title);
}

- (LPHelpItem *)lp_helpItem {
    return [LPHelpItem helpItemWithCompanyName:@"跟谁学"
                               userPhoneNumber:@"100000000"
                               helpPhoneNumber:@"000-00000000"];
}

- (BOOL)lp_recordEnabled {
    return YES;
}

- (BOOL)lp_rewardEnabled {
    return YES;
}

@end
