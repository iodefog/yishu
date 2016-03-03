//
//  ExperienceTitleController.m
//  medtree
//
//  Created by 陈升军 on 15/6/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceTitleController.h"
#import "ExperienceDTO.h"
#import "ExperienceCommonCell.h"
#import "ExperienceTableView.h"
#import "TitleDTO.h"

@interface ExperienceTitleController ()

// 教育经历中的学历
@property (nonatomic, strong) NSMutableArray *educationTitleArray;
// 工作经历中老师职称
@property (nonatomic, strong) NSMutableArray *teachTitleArray;
// 医院中工作经历的职称
@property (nonatomic, strong) NSMutableArray *hospitalTitleArray;
// 医院里的医生
@property (nonatomic, strong) NSMutableArray *doctorTitleArray;
// 医院里的护士
@property (nonatomic, strong) NSMutableArray *nurseTitleArray;

@end

@implementation ExperienceTitleController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    [self createBackButton];
    commonTable.footer = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize size = self.view.frame.size;
    commonTable.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, size.height - CGRectGetMaxY(naviBar.frame));
    [self setupData];
}

- (void)setupData
{
    NSString *title = @"";
    if (self.experienceType == ExperienceType_Work) {
        title = @"选择职称/职务";
        if (self.orgType == OrgType_School) {
            dataArray = [NSMutableArray arrayWithArray:self.teachTitleArray];
        } else if (self.orgType == OrgType_Hospital) {
            if (self.userType == UserTypes_Physicians) {
                dataArray = [NSMutableArray arrayWithArray:self.doctorTitleArray];
            } else if (self.userType == UserTypes_NursingStaff) {
                dataArray = [NSMutableArray arrayWithArray:self.nurseTitleArray];
            } else {
                dataArray = [NSMutableArray arrayWithArray:self.hospitalTitleArray];
            }
        }
    } else if (self.experienceType == ExperienceType_Edu) {
        title = @"选择学历";
        dataArray = [NSMutableArray arrayWithArray:self.educationTitleArray];
    }
    
    [dataArray enumerateObjectsUsingBlock:^(TitleDTO *dto, NSUInteger idx, BOOL *stop) {
        if ([dto.title isEqualToString:self.titleDto.title]) {
            dto.selected = YES;
        } else {
            dto.selected = NO;
        }
    }];
    
    [naviBar setTopTitle:title];
    [naviBar setTopLabelColor:[UIColor whiteColor]];
    [commonTable setInfo:dataArray];
}

- (void)selectTitle:(id)dto
{
    if ([dto isKindOfClass:[TitleDTO class]]) {
        [self.parent updateInfo:@{@"data":@"title", @"title":dto}];
        [self clickBack];
    }
}

#pragma mark - RegisterOrganizationControllerDelegate
- (void)updateInfo:(NSDictionary *)dict
{
    [self.parent updateInfo:@{@"data":@"title",@"detail":[dict objectForKey:@"detail"]}];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - getter & settter 
- (NSMutableArray *)hospitalTitleArray
{
    if (!_hospitalTitleArray) {
        _hospitalTitleArray = [[NSMutableArray alloc] init];
        NSArray *hospitalTitles = @[@"主任医师", @"副主任医师", @"主治医师",
                                    @"住院医师", @"主任护师", @"副主任护师",
                                    @"主管护师", @"护师", @"护士",
                                    @"主任技师", @"副主任技师", @"主管技师",
                                    @"技师", @"技士", @"主任药师",
                                    @"副主任药师", @"主管药师", @"药师",
                                    @"药士", @"其他"];
        NSArray *hospitalTypes = @[@45, @44, @43,
                                   @42, @55, @54,
                                   @53, @52, @51,
                                   @35, @34, @33,
                                   @32, @31, @25,
                                   @24, @23, @22,
                                   @21, @90];
        for (NSInteger i = 0; i < hospitalTitles.count; i ++) {
            TitleDTO *dto = [[TitleDTO alloc] init];
            dto.title = hospitalTitles[i];
            dto.titleType = (Title_Type)[hospitalTypes[i] integerValue];
            [_hospitalTitleArray addObject:dto];
        }
    }
    return _hospitalTitleArray;
}

- (NSMutableArray *)doctorTitleArray
{
    if (!_doctorTitleArray) {
        _doctorTitleArray = [[NSMutableArray alloc] init];
        NSArray *doctorTitles = @[@"主任医师", @"副主任医师", @"主治医师",
                                  @"住院医师", @"其他"];
        NSArray *doctorTypes = @[@45, @44, @43,
                                 @42, @90];
        for (NSInteger i = 0; i < doctorTitles.count; i ++) {
            TitleDTO *dto = [[TitleDTO alloc] init];
            dto.title = doctorTitles[i];
            dto.titleType = (Title_Type)[doctorTypes[i] integerValue];
            [_doctorTitleArray addObject:dto];
        }
    }
    return _doctorTitleArray;
}

- (NSMutableArray *)nurseTitleArray
{
    if (!_nurseTitleArray) {
        _nurseTitleArray = [[NSMutableArray alloc] init];
        NSArray *nurseTitles = @[@"主任护师", @"副主任护师", @"主管护师",
                                 @"护师", @"护士", @"其他"];
        NSArray *nurseTypes = @[@55, @54, @53,
                                @52, @51, @90];
        for (NSInteger i = 0; i < nurseTitles.count; i ++) {
            TitleDTO *dto = [[TitleDTO alloc] init];
            dto.title = nurseTitles[i];
            dto.titleType = (Title_Type)[nurseTypes[i] integerValue];
            [_nurseTitleArray addObject:dto];
        }
    }
    return _nurseTitleArray;
}

- (NSMutableArray *)educationTitleArray
{
    if (!_educationTitleArray) {
        _educationTitleArray = [[NSMutableArray alloc] init];
        NSArray *educationTitles = @[@"大中专",@"本科",@"硕士研究生",@"博士研究生", @"其他"];
        for (NSInteger i = TitleType_College; i <= TitleType_College_Other; i ++) {
            TitleDTO *dto = [[TitleDTO alloc] init];
            dto.titleType = (Title_Type)i;
            dto.title = educationTitles[i - TitleType_College];
            [_educationTitleArray addObject:dto];
        }
    }
    return _educationTitleArray;
}

- (NSMutableArray *)teachTitleArray
{
    if (!_teachTitleArray) {
        _teachTitleArray = [[NSMutableArray alloc] init];
        NSArray *teachTitles = @[@"教授", @"副教授", @"讲师", @"其他"];
        NSArray *teachTypes = @[@15, @14, @13, @10];
        for (NSInteger i = 0; i < teachTitles.count; i ++) {
            TitleDTO *dto = [[TitleDTO alloc] init];
            dto.titleType = (Title_Type)[teachTypes[i] integerValue];
            dto.title = teachTitles[i];
            [_teachTitleArray addObject:dto];
        }
    }
    return _teachTitleArray;
}


@end
