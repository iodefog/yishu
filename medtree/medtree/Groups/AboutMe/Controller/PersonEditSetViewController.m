//
//  PersonEditSetViewController.m
//  medtree
//
//  Created by 无忧 on 14-8-25.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonEditSetViewController.h"
#import "PersonEditSetTextView.h"
#import "PersonEditTitleTableView.h"
#import "EditDatePickerView.h"
#import "ServiceManager.h"
#import "InfoAlertView.h"

@interface PersonEditSetViewController ()
{
    PersonEditSetTextView   *textView;
    NSMutableDictionary     *infoDict;
    PersonEditTitleTableView *table;
    EditDatePickerView      *datePicker;
}

@end

@implementation PersonEditSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickSave
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:MethodType_UserInfo_Update] forKey:@"method"];
    NSIndexPath *index = [infoDict objectForKey:@"index"];
    NSInteger tag = [[infoDict objectForKey:@"tag"] integerValue];
    NSString *Identification = [infoDict objectForKey:@"Identification"];
    
    NSInteger cellLine = index.row;

    if (cellLine == 2) {
        if (textView.textViewInfo.length > 0) {
            [infoDict setObject:textView.textViewInfo forKey:@"detail"];
            [dataDict setObject:textView.textViewInfo forKey:@"value"];
            [dataDict setObject:@"nickname" forKey:@"key"];
        } else {
            [InfoAlertView showInfo:@"请填写您的姓名" inView:self.view duration:1];
            return;
        }
    } else if (cellLine == 3) {
        if ([table.ediTtitle isEqualToString:@"男"]) {
            [dataDict setObject:[NSNumber numberWithInteger:1] forKey:@"value"];
            [infoDict setObject:[NSNumber numberWithInteger:1] forKey:@"detail"];
        } else {
            [dataDict setObject:[NSNumber numberWithInteger:2] forKey:@"value"];
            [infoDict setObject:[NSNumber numberWithInteger:2] forKey:@"detail"];
        }
        [dataDict setObject:@"gender" forKey:@"key"];
    } else if (cellLine == 4) {
        [infoDict setObject:datePicker.startTime forKey:@"detail"];
        [dataDict setObject:[NSString stringWithFormat:@"%@ 00:00:00",[datePicker.startTime stringByReplacingOccurrencesOfString:@"." withString:@"-"]] forKey:@"value"];
        [dataDict setObject:@"birthday" forKey:@"key"];
    } else if (cellLine == 8) {
        
    }
    
    if ([Identification isEqualToString:@"Identification"]) {
//        if (index.section == 0) {
//            if (tag == 1) {
//                if ([table.ediTtitle isEqualToString:@"男"]) {
//                    [dataDict setObject:[NSNumber numberWithInteger:1] forKey:@"value"];
//                    [infoDict setObject:[NSNumber numberWithInteger:1] forKey:@"detail"];
//                } else {
//                    [dataDict setObject:[NSNumber numberWithInteger:2] forKey:@"value"];
//                    [infoDict setObject:[NSNumber numberWithInteger:2] forKey:@"detail"];
//                }
//                [dataDict setObject:@"gender" forKey:@"key"];
//            } else if (tag == 0) {
//                [infoDict setObject:textView.textViewInfo forKey:@"detail"];
//                [dataDict setObject:textView.textViewInfo forKey:@"value"];
//                [dataDict setObject:@"nickname" forKey:@"key"];
//            } else {
//                [infoDict setObject:datePicker.startTime forKey:@"detail"];
//                [dataDict setObject:[NSString stringWithFormat:@"%@ 00:00:00",[datePicker.startTime stringByReplacingOccurrencesOfString:@"." withString:@"-"]] forKey:@"value"];
//                [dataDict setObject:@"birthday" forKey:@"key"];
//            }
//        } else if (index.section == 1 && tag == 3) {
//            [infoDict setObject:table.ediTtitle forKey:@"detail"];
//        } else if (index.section == 1 && tag == 1) {
//            [infoDict setObject:datePicker.startTime forKey:@"startTime"];
//            [infoDict setObject:datePicker.endTime forKey:@"endTime"];
//        } else {
//            [infoDict setObject:textView.textViewInfo forKey:@"detail"];
//        }
    } else {
        if (index.section == 4 || (index.section == 1 && tag == 0)) {
           // [infoDict setObject:textView.textViewInfo forKey:@"detail"];
//            if (index.section == 4) {
//                [dataDict setObject:textView.textViewInfo forKey:@"value"];
//                [dataDict setObject:@"interest" forKey:@"key"];
//            } else {
//                if (textView.textViewInfo.length > 0) {
//                    [dataDict setObject:textView.textViewInfo forKey:@"value"];
//                    [dataDict setObject:@"nickname" forKey:@"key"];
//                } else {
//                    [InfoAlertView showInfo:@"请填写您的姓名" inView:self.view duration:1];
//                    return;
//                }
         //   }
        } else if (index.section == 1 && tag == 1) {
//            if ([table.ediTtitle isEqualToString:@"男"]) {
//                [dataDict setObject:[NSNumber numberWithInteger:1] forKey:@"value"];
//                [infoDict setObject:[NSNumber numberWithInteger:1] forKey:@"detail"];
//            } else {
//                [dataDict setObject:[NSNumber numberWithInteger:2] forKey:@"value"];
//                [infoDict setObject:[NSNumber numberWithInteger:2] forKey:@"detail"];
//            }
//            [dataDict setObject:@"gender" forKey:@"key"];
        } else if ((index.section == 2 && tag == 3) || (index.section == 3 && tag == 3)) {
            [infoDict setObject:table.ediTtitle forKey:@"detail"];
        } else if (index.section == 1 && tag == 2) {
            [infoDict setObject:datePicker.startTime forKey:@"detail"];
            [dataDict setObject:[NSString stringWithFormat:@"%@ 00:00:00",[datePicker.startTime stringByReplacingOccurrencesOfString:@"." withString:@"-"]] forKey:@"value"];
            [dataDict setObject:@"birthday" forKey:@"key"];
        } else if ((index.section == 2 || index.section == 3) && tag == 1) {
            [infoDict setObject:datePicker.startTime forKey:@"startTime"];
            [infoDict setObject:datePicker.endTime forKey:@"endTime"];
        }
    }
    if (cellLine != 6) {
        [dict setObject:[NSArray arrayWithObject:dataDict] forKey:@"data"];
        
        [ServiceManager setData:dict success:^(id JSON) {
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
    [self.parent updateUserInfo:infoDict];
    [self clickBack];
}

- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@""];
    UIButton *editButton = [NavigationBar createNormalButton:@"保存" target:self action:@selector(clickSave)];
    [naviBar setRightButton:editButton];
    [self createBackButton];
}

//- (void)createBackButton
//{
//    UIButton *backButton = [NavigationBar createImageButton:@"btn_back.png" selectedImage:@"btn_back_click.png" target:self action:@selector(clickBack)];
//    [naviBar setLeftButton:backButton];
//}
//
//- (void)clickBack
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize size = self.view.frame.size;
    if (infoDict == nil) {
        return;
    }
    NSIndexPath *index = [infoDict objectForKey:@"index"];
    NSInteger tag = [[infoDict objectForKey:@"tag"] integerValue];
    NSString *Identification = [infoDict objectForKey:@"Identification"];
    NSInteger cellLine = index.row;
    if (cellLine == 2) {//修改姓名
         textView.frame = CGRectMake(0, [self getOffset]+44, size.width, 50);
    } else if (cellLine == 3) {//修改性别
        table.frame = CGRectMake(0, [self getOffset]+44, size.width, size.height-([self getOffset]+44));
    } else if (cellLine == 4) {//修改生日
        datePicker.frame = CGRectMake(0, [self getOffset] +44, size.width, size.height-([self getOffset]+44));
    }
    
    
    if ([Identification isEqualToString:@"Identification"]) {
//        if (index.section == 0) {
//            if (tag == 0) {
//                textView.frame = CGRectMake(0, [self getOffset]+44, size.width, 50);
//            } else if (tag == 1) {
//                table.frame = CGRectMake(0, [self getOffset]+44, size.width, size.height-([self getOffset]+44));
//            } else {
//                datePicker.frame = CGRectMake(0, [self getOffset] +44, size.width, size.height-([self getOffset]+44));
//            }
//        } else if (index.section == 1) {
//            if (tag == 3) {
//                table.frame = CGRectMake(0, [self getOffset]+44, size.width, size.height-([self getOffset]+44));
//            } else if (tag == 1) {
//                datePicker.frame = CGRectMake(0, [self getOffset] +44, size.width, size.height-([self getOffset]+44));
//            }
//        } else {
//            textView.frame = CGRectMake(0, [self getOffset]+44, size.width, 50);
//        }
    } else {
        if (index.section == 4) {
            textView.frame = CGRectMake(0, [self getOffset]+44, size.width, size.height-260-([self getOffset]+44));
        } else if (index.section == 1 && tag == 0) {
            textView.frame = CGRectMake(0, [self getOffset]+44, size.width, 50);
        } else if ((index.section == 1 && tag == 1) || (index.section == 2 && tag == 3) || (index.section == 3 && tag == 3)) {
            table.frame = CGRectMake(0, [self getOffset]+44, size.width, size.height-([self getOffset]+44));
        } else if ((index.section == 1 && tag == 2) || ((index.section == 2 || index.section == 3) && tag == 1)) {
            datePicker.frame = CGRectMake(0, [self getOffset] +44, size.width, size.height-([self getOffset]+44));
        }
    }
}

- (void)setNaviTitle:(NSString *)title
{
    [naviBar setTopTitle:title];
}

//- (void)createView:(NSInteger)tag
//{
//    if (tag == 0) {
//        [self createTextView];
//        [textView setBgTitle:@"填写您的姓名"];
//        [textView setTextViewTextInfo:[infoDict objectForKey:@"detail"]];
//    } else if (tag == 1) {
//        [self createEditTableView];
//        NSString *gender = [infoDict objectForKey:@"detail"];
//        NSArray *array = [NSArray arrayWithObjects:@"男",@"女", nil];
//        NSMutableArray *tableArray = [NSMutableArray array];
//        for (int i = 0; i < array.count; i ++) {
//            if ([gender isEqualToString:[array objectAtIndex:i]]) {
//                [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:YES]}];
//            } else {
//                [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:NO]}];
//            }
//        }
//        table.ediTtitle = gender;
//        [table setInfo:tableArray];
//    } else {
//        [self createEditDatePicker];
//        [datePicker setInfo:@{@"isBirthday":[NSNumber numberWithBool:YES],@"birthday":[infoDict objectForKey:@"detail"]}];
//    }
//    [self viewDidLayoutSubviews];
//}

- (void)createView:(NSInteger)cellLine
{
    if (cellLine == 2) {
        [self createTextView];
        [textView setBgTitle:@"填写您的姓名"];
        [textView setTextViewTextInfo:[infoDict objectForKey:@"detail"]];
    } else if (cellLine == 3) {
        [self createEditTableView];
        NSString *gender = [infoDict objectForKey:@"detail"];
        NSArray *array = [NSArray arrayWithObjects:@"男",@"女", nil];
        NSMutableArray *tableArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i ++) {
            if ([gender isEqualToString:[array objectAtIndex:i]]) {
                [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:YES]}];
            } else {
                [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:NO]}];
            }
        }
        table.ediTtitle = gender;
        [table setInfo:tableArray];
    } else {
        [self createEditDatePicker];
        [datePicker setInfo:@{@"isBirthday":[NSNumber numberWithBool:YES],@"birthday":[infoDict objectForKey:@"detail"]}];
    }
    [self viewDidLayoutSubviews];
}

- (void)setUserInfo:(NSDictionary *)dict
{
    infoDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSIndexPath *index = [infoDict objectForKey:@"index"];
    NSInteger tag = [[infoDict objectForKey:@"tag"] integerValue];
    NSString *Identification = [infoDict objectForKey:@"Identification"];
    NSInteger cellLine = index.row;
    switch (cellLine) {
        case 2:
        case 3:
        case 4:
            [self createView:cellLine];
            break;
            
        default:
            break;
    }
    
    
    if ([Identification isEqualToString:@"Identification"]) {
       
    } else {
        if (index.section == 4) {
            [self createTextView];
            [textView setBgTitle:@"填写您的兴趣爱好"];
            [textView setTextViewTextInfo:[infoDict objectForKey:@"detail"]];
        } else if (index.section == 1) {
           // [self createView:tag];
        } else if ((index.section == 2 || index.section == 3) && tag == 1) {
          //  [self createEditDatePicker];
           // [datePicker setInfo:@{@"isBirthday":[NSNumber numberWithBool:NO],@"startTime":[infoDict objectForKey:@"startTime"],@"endTime":[infoDict objectForKey:@"endTime"]}];
        } else if (index.section == 2 && tag == 3) {
            [self createEditTableView];
            NSString *gender = [infoDict objectForKey:@"detail"];
            NSArray *array = [NSArray arrayWithObjects:@"大专",@"本科",@"硕士",@"博士",@"其他", nil];
            NSMutableArray *tableArray = [NSMutableArray array];
            for (int i = 0; i < array.count; i ++) {
                if ([gender isEqualToString:[array objectAtIndex:i]]) {
                    [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:YES]}];
                } else {
                    [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:NO]}];
                }
            }
            table.ediTtitle = gender;
            [table setInfo:tableArray];
        } else if (index.section == 3 && tag == 3) {
            [self createEditTableView];
            NSString *gender = [infoDict objectForKey:@"detail"];
            NSArray *array = [NSArray arrayWithObjects:@"副主任药师",@"主任药师",@"技师",@"主管技师",@"副主任技师",@"主任技师",@"住院医师",@"主治医师",@"副主任医师",@"主任医师",@"其他",nil];
            NSMutableArray *tableArray = [NSMutableArray array];
            for (int i = 0; i < array.count; i ++) {
                if ([gender isEqualToString:[array objectAtIndex:i]]) {
                    [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:YES]}];
                } else {
                    [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:NO]}];
                }
            }
            table.ediTtitle = gender;
            [table setInfo:tableArray];
        }
    }
    
}


//- (void)setUserInfo:(NSDictionary *)dict
//{
//    infoDict = [NSMutableDictionary dictionaryWithDictionary:dict];
//    NSIndexPath *index = [infoDict objectForKey:@"index"];
//    NSInteger tag = [[infoDict objectForKey:@"tag"] integerValue];
//    NSString *Identification = [infoDict objectForKey:@"Identification"];
//    if ([Identification isEqualToString:@"Identification"]) {
//        if (index.section == 0) {
//            [self createView:tag];
//        } else if (index.section == 1) {
//            if (tag == 3) {
//                [self createEditTableView];
//                NSString *gender = [infoDict objectForKey:@"detail"];
//                NSArray *array = [NSArray arrayWithObjects:@"大专",@"本科",@"硕士",@"博士",@"其他", nil];
//                NSMutableArray *tableArray = [NSMutableArray array];
//                for (int i = 0; i < array.count; i ++) {
//                    if ([gender isEqualToString:[array objectAtIndex:i]]) {
//                        [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:YES]}];
//                    } else {
//                        [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:NO]}];
//                    }
//                }
//                table.ediTtitle = gender;
//                [table setInfo:tableArray];
//            } else if (tag == 1) {
//                [self createEditDatePicker];
//                [datePicker setInfo:@{@"isBirthday":[NSNumber numberWithBool:NO],@"startTime":[infoDict objectForKey:@"startTime"],@"endTime":[infoDict objectForKey:@"endTime"]}];
//            }
//        } else if (index.section == 2) {
//            [self createTextView];
//            [textView setBgTitle:@"填写您的学号"];
//            if ([[infoDict objectForKey:@"detail"] isEqualToString:@"未填写"]) {
//                
//            } else {
//                [textView setTextViewTextInfo:[infoDict objectForKey:@"detail"]];
//            }
//        }
//    } else {
//        if (index.section == 4) {
//            [self createTextView];
//            [textView setBgTitle:@"填写您的兴趣爱好"];
//            [textView setTextViewTextInfo:[infoDict objectForKey:@"detail"]];
//        } else if (index.section == 1) {
//            [self createView:tag];
//        } else if ((index.section == 2 || index.section == 3) && tag == 1) {
//            [self createEditDatePicker];
//            [datePicker setInfo:@{@"isBirthday":[NSNumber numberWithBool:NO],@"startTime":[infoDict objectForKey:@"startTime"],@"endTime":[infoDict objectForKey:@"endTime"]}];
//        } else if (index.section == 2 && tag == 3) {
//            [self createEditTableView];
//            NSString *gender = [infoDict objectForKey:@"detail"];
//            NSArray *array = [NSArray arrayWithObjects:@"大专",@"本科",@"硕士",@"博士",@"其他", nil];
//            NSMutableArray *tableArray = [NSMutableArray array];
//            for (int i = 0; i < array.count; i ++) {
//                if ([gender isEqualToString:[array objectAtIndex:i]]) {
//                    [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:YES]}];
//                } else {
//                    [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:NO]}];
//                }
//            }
//            table.ediTtitle = gender;
//            [table setInfo:tableArray];
//        } else if (index.section == 3 && tag == 3) {
//            [self createEditTableView];
//            NSString *gender = [infoDict objectForKey:@"detail"];
//            NSArray *array = [NSArray arrayWithObjects:@"副主任药师",@"主任药师",@"技师",@"主管技师",@"副主任技师",@"主任技师",@"住院医师",@"主治医师",@"副主任医师",@"主任医师",@"其他",nil];
//            NSMutableArray *tableArray = [NSMutableArray array];
//            for (int i = 0; i < array.count; i ++) {
//                if ([gender isEqualToString:[array objectAtIndex:i]]) {
//                    [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:YES]}];
//                } else {
//                    [tableArray addObject:@{@"title":[array objectAtIndex:i],@"isSelect":[NSNumber numberWithBool:NO]}];
//                }
//            }
//            table.ediTtitle = gender;
//            [table setInfo:tableArray];
//        }
//    }
//    
//}

- (void)createEditDatePicker
{
    datePicker = [[EditDatePickerView alloc] init];
    [self.view addSubview:datePicker];
}

- (void)createEditTableView
{
    table = [[PersonEditTitleTableView alloc] init];
    [self.view addSubview:table];
}

- (void)createTextView
{
    textView = [[PersonEditSetTextView alloc] initWithFrame:CGRectZero];
    [textView setBgTitle:@"提示语"];
    [textView setTextViewBecomeFirstResponder];
    [self.view addSubview:textView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}

@end
