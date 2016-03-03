//
//  TableController.m
//  medtree
//
//  Created by sam on 8/8/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "TableController.h"
#import "ServiceManager+Public.h"
#import "BaseTableView.h"
#import "ColorUtil.h"
#import "LoadingTableView.h"
#import "ImageCenter.h"
#import "JSONKit.h"
#import "InfoAlertView.h"

@interface TableController () <BaseTableViewDelegate>
{
    BOOL isShowErrorAlert;
}

@end

@implementation TableController

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [ColorUtil getColor:@"F4F4F7" alpha:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark -
#pragma mark - UI -

- (void)createUI
{
    [super createUI];
    isShowErrorAlert = NO;
    
    dataLoading = [[GetDataLoadingView alloc] init];
    dataLoading.hidden = YES;
    [self.view addSubview:dataLoading];
}

- (void)createTable
{
    table = [[LoadingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.parent = self;
    table.enableHeader = YES;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
}

- (UIButton *)createBackButton
{
    UIButton *backButton = [NavigationBar createImageButton:@"btn_back.png"
                                              selectedImage:@"btn_back_click.png"
                                                     target:self
                                                     action:@selector(clickBack)];
    [naviBar setLeftButton:backButton];
    return backButton;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize size = [[UIScreen mainScreen] bounds].size;
    dataLoading.frame = CGRectMake(0, [self getOffset]+44+80, size.width, 100);
    [self.view bringSubviewToFront:dataLoading];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)loadHeader:(BaseTableView *)table
{
    [self requestData];
}

- (void)loadFooter:(BaseTableView *)table
{
    [self requestDataMore];
}

#pragma mark -
#pragma mark - response event -

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTable
{
    
}

- (void)cleanData
{
    [table setData:[NSArray arrayWithObjects:[NSArray array], nil]];
}

- (void)loadData
{
    
}

- (void)reloadData
{
    
}

#pragma mark -
#pragma mark - request -

- (NSDictionary *)getParam_FromLocal
{
    return @{ @"method" : @(MethodType_Unknown_Local) };
}

- (NSDictionary *)getParam_FromNet
{
    return @{@"method" : @(MethodType_Unknown) };
}

- (NSDictionary *)getParam_FromNet_More
{
    return @{@"method": @(MethodType_Unknown_More) };
}

- (void)getDataFromLocal
{
    [ServiceManager getData:[self getParam_FromLocal] success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideProgress];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getParam_FromLocal]];
            [dict setObject:JSON forKey:@"data"];
            [self parseData:dict];
        });
    } failure:^(NSError *error, id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideProgress];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getParam_FromLocal]];
            [dict setObject:JSON forKey:@"error"];
            [self parseDataError:JSON];
        });
    }];
}

- (void)requestData
{
    [self showProgress];
    [ServiceManager getData:[self getParam_FromNet] success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideProgress];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getParam_FromNet]];
            [dict setObject:JSON forKey:@"data"];
            [self parseData:dict];
        });
    } failure:^(NSError *error, id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideProgress];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getParam_FromNet]];
            if (JSON) {
                [dict setObject:JSON forKey:@"error"];
                [self parseDataError:JSON];
            }
            
        });
    }];
}

- (void)requestDataMore
{
    [self showProgress];

    [ServiceManager getData:[self getParam_FromNet_More] success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideProgress];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getParam_FromNet_More]];
            [dict setObject:JSON forKey:@"data"];
            [self parseData:dict];
        });
    } failure:^(NSError *error, id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideProgress];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getParam_FromNet_More]];
            [dict setObject:JSON forKey:@"error"];
            [self parseDataError:JSON];
        });
    }];
}

- (void)parseData:(id)JSON
{

}

- (void)parseDataError:(id)JSON
{
    
}

- (void)showProgress
{
    
}

- (void)hideProgress
{
    
}

#pragma mark -
#pragma mark - helper -

- (NSString *)getPhone
{
    NSString *phone = @"iPhone4";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize size = [[UIScreen mainScreen] currentMode].size;
        if (size.width == 320) {
            phone = @"iPhone3";
        } else if (size.width == 640) {
            if (size.height > 960) {
                phone = @"iPhone5";
            } else {
                phone = @"iPhone4";
            }
        } else if (size.width == 750) {
            phone = @"iPhone6";
        } else {
            phone = @"iPhone6plus";
        }
    }
    return phone;
}

- (void)showErrorAlert:(NSString *)message
{
    if (isShowErrorAlert) {
        return;
    }
    isShowErrorAlert = YES;
    [InfoAlertView showInfo:message inView:[UIApplication sharedApplication].keyWindow duration:2];
    [self performSelector:@selector(changeShowErrorAlert) withObject:nil afterDelay:2];
}

- (void)changeShowErrorAlert
{
    isShowErrorAlert = NO;
}

@end
