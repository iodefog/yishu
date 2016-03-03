//
//  AddOrgController.m
//  medtree
//
//  Created by 边大朋 on 15/6/11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "AddOrgController.h"
#import "ColorUtil.h"
#import "MedGlobal.h"
#import "FontUtil.h"
#import "ExperienceDTO.h"
#import "ExperienceDepController.h"
#import "CustomTextField.h"
#import "RegisterController.h"
#import "ExperienceDetailController.h"
#import "YMScrollView.h"
#import "OrganizationNameDTO.h"
#import "InfoAlertView.h"
#import "ImproveController.h"

@interface AddOrgController ()
{
    YMScrollView            *contentView;
    CGFloat                 duration;
    UILabel                 *noticeLab;
    CustomTextField         *inputView;
    UILabel                 *exampleLab;
    
    UILabel                 *orgTypeLab;
    /** 被选中的button */
    UIButton                *selectButton;
    /** 显示组织类别选择 */
    BOOL                    showButtons;
}

@property (nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation AddOrgController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    contentView = [[YMScrollView alloc] init];
    [self.view addSubview:contentView];
    
    noticeLab = [[UILabel alloc] init];
    noticeLab.font = [MedGlobal getMiddleFont];
    noticeLab.textColor = [ColorUtil getColor:@"555555" alpha:1];
    noticeLab.numberOfLines = 0;
    [contentView addSubview:noticeLab];
    
    orgTypeLab = [[UILabel alloc] init];
    orgTypeLab.font = [MedGlobal getMiddleFont];
    orgTypeLab.textColor = [ColorUtil getColor:@"000000" alpha:1];
    [contentView addSubview:orgTypeLab];

    inputView = [[CustomTextField alloc] init];
    [inputView addTarget:self action:@selector(checkNumber) forControlEvents:UIControlEventEditingChanged];
    [contentView addSubview:inputView];
    
    exampleLab = [[UILabel alloc] init];
    exampleLab.numberOfLines = 0;
    exampleLab.font = [MedGlobal getMiddleFont];
    exampleLab.textColor = [ColorUtil getColor:@"555555" alpha:1];
    [contentView addSubview:exampleLab];
}

- (void)createSaveBtn
{
    UIButton *saveBtn = [NavigationBar createNormalButton:@"确定" target:self action:@selector(save)];
    [naviBar setRightButton:saveBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupData];
    [self setupView];
    [naviBar setTopLabelColor:[UIColor whiteColor]];
    [self createSaveBtn];
    [self createBackButton];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    CGFloat space = 15;
    CGSize maxSize = CGSizeMake(size.width - space * 2, MAXFLOAT);
    CGSize noticeSize = [noticeLab.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:noticeLab.font} context:nil].size;
    noticeLab.frame = CGRectMake(space, space, size.width - space * 2, noticeSize.height);
    
    CGFloat inputViewY = CGRectGetMaxY(noticeLab.frame) + space;
    if (_expType == ExperienceType_Work && showButtons) { // 添加工作经历，注册时身份为其他医学人员的时候 走下面这个方法
        orgTypeLab.frame = CGRectMake(space, CGRectGetMaxY(noticeLab.frame) + space, size.width - space * 2, 20);
        CGFloat btnW = 70;
        CGFloat sideW = 30;
        CGFloat btnY = CGRectGetMaxY(orgTypeLab.frame) + space / 2;
        CGFloat btnH = 33;
        [self.btnArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            button.frame = CGRectMake(space + (idx * (btnW + sideW)), btnY, btnW, btnH);
        }];
        inputViewY = btnY + btnH + space;
    }
    inputView.frame = CGRectMake(0, inputViewY, size.width, 55);
    
    exampleLab.frame = CGRectMake(space, CGRectGetMaxY(inputView.frame) + space, size.width - space * 2, 50);
    
    CGFloat contentViewY = CGRectGetMaxY(naviBar.frame);
    contentView.frame = CGRectMake(0, contentViewY, size.width, size.height - contentViewY);
    contentView.contentSize = CGSizeMake(CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame));
}

- (void)setupData
{
    [inputView becomeFirstResponder];
    
    if ([self.fromVC isKindOfClass:[ExperienceDetailController class]]) {   // 增加工作经历
        if (self.expType == ExperienceType_Work) {
            [self createOrgan];
        } else if (self.expType == ExperienceType_Edu) {
            [self createSchool];
        }
    } else if ([self.fromVC isKindOfClass:[RegisterController class]] || [self.fromVC isKindOfClass:[ImproveController class]]) {    // 注册经历完善
        if (self.expType == ExperienceType_Work) {
            if (self.userType <= UserTypes_ManagementAndAdministrative) {
                [self createHospital];
            } else {
                [self createOrgan];
            }
        } else if (self.expType == ExperienceType_Edu) {
            [self createSchool];
        }
    }
}

- (void)createOrgan
{
    [naviBar setTopTitle:@"创建新的单位"];
    noticeLab.text = @"您创建的单位需要您身份认证后，才能在单位列表显示";
    orgTypeLab.text = @"您的单位是？";
    inputView.placeholder = @"请填写规范的单位全称";
    exampleLab.text = @"请填写规范的单位全称 如： “中国人民解放军总医院”";
    if (self.orgName.length > 0) {
        inputView.text = self.orgName;
    }
    showButtons = YES;
}

- (UIButton *)createButtonWithTitle:(NSString *)title tag:(NSNumber *)tag
{
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    button.titleLabel.font = [MedGlobal getMiddleFont];
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 0.6;
    button.layer.borderColor = [ColorUtil getColor:@"D7D7D8" alpha:1].CGColor;
    [contentView addSubview:button];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = tag.integerValue;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    if (tag.integerValue == self.orgType) {
        button.selected = YES;
        [button setBackgroundColor:[ColorUtil getColor:@"2A4877" alpha:1]];
        selectButton = button;
    }
    return button;
}

- (void)createSchool
{
    [naviBar setTopTitle:@"创建新的学校"];
    noticeLab.text = @"您创建的学校需要您身份认证后，才能直接在学校列表显示";
    exampleLab.text = @"如： “北京大学医学部”";
    inputView.placeholder = @"请填写规范的学校全称";
    if (self.orgName.length > 0) {
        inputView.text = self.orgName;
        exampleLab.text = @"请填写规范的学校全称 如： “北京大学医学部”";
    }
}

- (void)createHospital
{
    [naviBar setTopTitle:@"创建新的医院"];
    noticeLab.text = @"您创建的医院需要您身份认证后，才能直接在医院列表显示";
    inputView.placeholder = @"请填写规范的医院全称";
    exampleLab.text = @"请填写规范的医院全称 如： “中国人民解放军总医院”";
    if (self.orgName.length > 0) {
        inputView.text = self.orgName;
    }
}

#pragma mark - register
- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - noti
- (void)keyboardWillShow:(NSNotification *)notification
{
    duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyFrame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize size = contentView.frame.size;

    if (keyFrame.size.height -  (size.height - CGRectGetMaxY(inputView.frame)) > 0) {
        CGFloat chaHeight = keyFrame.size.height - (size.height - CGRectGetMaxY(inputView.frame));
        contentView.contentOffset = CGPointMake(0, chaHeight);
    }
}

#pragma mark - click
- (void)clickBtn:(UIButton *)button
{
    button.selected = YES;
    [button setBackgroundColor:[ColorUtil getColor:@"2A4877" alpha:1]];
    selectButton.selected = NO;
    [selectButton setBackgroundColor:[UIColor clearColor]];
    selectButton = button;
}

- (void)save
{
    NSString *organName = [inputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (organName.length == 0) {
        [InfoAlertView showInfo:@"请选择填写您的单位" inView:self.view duration:1.0];
        return;
    }
    if (showButtons) {
        if (selectButton) {
            self.orgType = (OrgType)selectButton.tag;
        } else {
            [InfoAlertView showInfo:@"请选择您的单位类型" inView:self.view duration:1.0];
            return;
        }
    }
    
    if ([self.fromVC isKindOfClass:[RegisterController class]] || [self.fromVC isKindOfClass:[ExperienceDetailController class]] || [self.fromVC isKindOfClass:[ImproveController class]]) {
        OrganizationNameDTO *dto = [[OrganizationNameDTO alloc] init];
        dto.name = organName;
        dto.type = self.orgType;
        if (self.expType == ExperienceType_Edu) {
            dto.type = OrgType_School;
        }
        dto.province = self.province;
        NSDictionary *dict = @{@"data":@"organization", @"organization":dto};
        [self.navigationController popToViewController:self.fromVC animated:YES];
        if ([self.parent respondsToSelector:@selector(updateInfo:)]) {
            [self.parent updateInfo:dict];
        }
    }
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [UIView animateWithDuration:duration animations:^{
        contentView.contentOffset = CGPointMake(0, 0);
    }];
    [self.view endEditing:YES];
}

#pragma mark - setter & getter
- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        NSArray *titleArray = @[@"医院", @"学校", @"其他"];
        NSArray *tagArray = @[@20, @10, @30];
        _btnArray = [[NSMutableArray alloc] initWithCapacity:titleArray.count];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [self createButtonWithTitle:titleArray[i] tag:tagArray[i]];
            [_btnArray addObject:button];
        }
    }
    return _btnArray;
}

#pragma mark - click
- (void)checkNumber
{
    if (inputView.text.length > 20) {
        [InfoAlertView showInfo:@"单位字数不能超过20个" inView:self.view duration:1.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            inputView.text = [inputView.text substringToIndex:20];
        });
    }
}

@end
