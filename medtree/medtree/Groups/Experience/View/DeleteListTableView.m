
//
//  ExperienceListTableView.m
//  medtree
//
//  Created by 边大朋 on 15/6/19.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DeleteListTableView.h"
#import "ExperienceDTO.h"
#import "ServiceManager.h"
#import "UserManager.h"

@implementation DeleteListTableView

#pragma mark 重写 避免点击删除按钮提前删除cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.isCanDel) {
            [tableView beginUpdates];
            [self deleteData:indexPath];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [tableView endUpdates];
        } else {
            [self showAlert];
        }
    }
}

#pragma mark - private
- (void)showAlert
{
    NSString *notice = @"确认要删除吗？";
    if (self.edto) {
        if ([self.edto isKindOfClass:[ExperienceDTO class]]) {
            if (((ExperienceDTO *)self.edto).experienceCertStatus == CertificationStatusType_Pass) {
                notice = @"您的经历已被认证，是否确认删除”；认证未通过的经历，删除时弹出提示“是否确认删除";
            } else if (((ExperienceDTO *)self.edto).experienceCertStatus == CertificationStatusType_Wait) {
                notice = @"您的经历正在认证中，删除后认证将中断，是否确认删除";
            }
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:notice delegate:self.parent cancelButtonTitle:@"取消" otherButtonTitles:@"确认删除", nil];
    alert.tag = 1000;
    [alert show];
}



@end
