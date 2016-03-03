//
//  IdentificationController.m
//  medtree
//
//  Created by 无忧 on 14-10-31.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IdentificationController.h"
#import "MedGlobal.h"
#import "PairDTO.h"
#import "ImageCenter.h"
#import "IdentificationCell.h"
#import "UserType.h"
#import "CertificationStatusType.h"
#import "CertificationDTO.h"
#import "ServiceManager.h"
//#import "PersonCertificationController.h"
#import "JSONKit.h"

@interface IdentificationController ()
{
    BOOL            isPopRoot;
    BOOL            isPerson;
    NSMutableArray  *certificationArray;
}

@end

@implementation IdentificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)createHeader
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15+24+15+40)];
    header.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgHeaderImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"register_header_bg.png"]];
    bgHeaderImage.frame = CGRectMake((header.frame.size.width-124)/2, 15, 124, 24);
    [header addSubview:bgHeaderImage];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"register_header_1.png"]];
    imageView.frame = CGRectMake(0, 0, 24, 24);
    [bgHeaderImage addSubview:imageView];
    
    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15+24+5, self.view.frame.size.width-40, 40)];
    headerLab.backgroundColor = [UIColor clearColor];
    headerLab.numberOfLines = 0;
    headerLab.alpha = 0.6;
    headerLab.text = @"“医树”是医学专业人员的家园，为尽最大努力维护家园的纯洁环境，请选择您的身份并完善相关信息。";
    headerLab.font = [MedGlobal getTinyLittleFont];
    [header addSubview:headerLab];
    [table setTableHeaderView:header];
    
    [table setSectionTitleHeight:[NSArray arrayWithObjects:[NSNumber numberWithFloat:10],[NSNumber numberWithFloat:30],[NSNumber numberWithFloat:30],[NSNumber numberWithFloat:30], nil]];
}

- (void)createPerson
{
    [table setSectionTitleHeight:[NSArray arrayWithObjects:[NSNumber numberWithFloat:30],[NSNumber numberWithFloat:30],[NSNumber numberWithFloat:30],[NSNumber numberWithFloat:30], nil]];
}

- (void)createUI
{
    [super createUI];
    isPerson = NO;
    isPopRoot = NO;
    [naviBar setTopTitle:@"请选择您的身份"];
    [self createBackButton];
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    foot.backgroundColor = [UIColor clearColor];
    
    [table setTableFooterView:foot];
    [table registerCell:[IdentificationCell class]];
    table.enableFooter = NO;
    table.enableHeader = NO;
//    table.parent = self;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    
    [self setData];
}

- (void)setData
{
    NSMutableArray *cellNames = [NSMutableArray array];
    NSArray *resourceArray = [NSArray arrayWithObjects:@"医师",@"护理人员",@"医技人员",@"药剂人员",@"其他管理和行政人员", nil];
    [cellNames addObject:[NSArray arrayWithObjects:@{@"title":@"医院从业人员",@"detail":resourceArray,@"image":@"img_v_1.png"}, nil]];
    
    [cellNames addObject:[NSArray arrayWithObjects:@{@"title":@"医学教学/科研/行政管理人员",@"detail":[NSArray array],@"image":@"img_v_2.png"}, nil]];
    
    [cellNames addObject:[NSArray arrayWithObjects:@{@"title":@"医学院校在读学生",@"detail":[NSArray array],@"image":@"img_v_3.png"}, nil]];
    
    [cellNames addObject:[NSArray arrayWithObjects:@{@"title":@"既往从医人员",@"detail":[NSArray array],@"image":@"img_v_5.png"}, nil]];
    
    NSMutableArray *cells = [NSMutableArray array];
    for (int i=0; i<cellNames.count; i++) {
        NSArray *array = [cellNames objectAtIndex:i];
        NSMutableArray *section = [NSMutableArray array];
        [cells addObject:section];
        //
        for (int j=0; j<array.count; j++) {
            PairDTO *dto = [[PairDTO alloc] init];
            NSDictionary *dict = [array objectAtIndex:j];
            dto.label = [dict objectForKey:@"title"];
            dto.imageName = [dict objectForKey:@"image"];
//            dto.type = [dict objectForKey:@"detail"];
            dto.accessType = UITableViewCellAccessoryNone;
            dto.resourceArray = [dict objectForKey:@"detail"];
            [section addObject:dto];
        }
    }
    [table setData:cells];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)setisPerson:(BOOL)sender
{
    isPerson = sender;
    if (isPerson) {
        [self createPerson];
    } else {
        [self createHeader];
    }
}

- (void)setDataInfo:(NSArray *)array
{
    certificationArray = [[NSMutableArray alloc] initWithArray:array];
}

- (void)getCertificationInfo
{
    certificationArray = [[NSMutableArray alloc] init];
    isPopRoot = YES;
    {
        [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"certificationInfo"} success:^(id JSON) {
            NSArray *array = [NSArray arrayWithArray:JSON];
            if (array.count > 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:0]];
                [certificationArray removeAllObjects];
                NSArray *array1 = [NSArray arrayWithArray:[dict objectForKey:@"certification"]];
                for (int i = 0; i < [array1 count]; i ++) {
                    NSDictionary *dict = [[array1 objectAtIndex:i] objectFromJSONString];
                    CertificationDTO *dto = [[CertificationDTO alloc] init:dict];
                    [certificationArray addObject:dto];
                }
            }
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
    {
        [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_Certification]} success:^(id JSON) {
            [certificationArray removeAllObjects];
            [certificationArray addObjectsFromArray:JSON];
        } failure:^(NSError *error, id JSON) {
            
        }];
    }

}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    NSInteger type = 1;
    if (index.section == 0) {
        type = ((PairDTO *)dto).cellType+2;
    } else {
        type = index.section+6;
        if (index.section == 3) {
            type = 10;
        }
    }
    if (isPerson) {
//        BOOL isFind = NO;
        /*
        PersonCertificationController *view = [[PersonCertificationController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
        for (int i = 0; i < certificationArray.count; i ++) {
            CertificationDTO *dto = [certificationArray objectAtIndex:i];
            if (type == dto.userType) {
                isFind = YES;
                [view setCertificationDTOInfo:dto];
                break;
            }
        }
        if (!isFind) {
            [view createNewCertificationInfo:type];
        }
        if (isPopRoot) {
            [view setPopToRoot];
        }
         */
    } else {
        /*
        RegisterController *registerView = [[RegisterController alloc] init];
        [self.navigationController pushViewController:registerView animated:YES];
        registerView.parent = self.parent;
        [registerView setUserType:type];
         */
    }
}

@end
