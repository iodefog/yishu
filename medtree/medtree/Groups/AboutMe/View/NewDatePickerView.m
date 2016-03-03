//
//  NewDatePickerView.m
//  medtree
//
//  Created by 边大朋 on 15-4-6.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewDatePickerView.h"
#import "DateUtil.h"
#import "ColorUtil.h"

@interface NewDatePickerView ()
{
    UIView          *btnView;
    UILabel         *btn;
}
@end

@implementation NewDatePickerView

- (void)createUI
{
    self.backgroundColor = [ColorUtil getColor:@"000000" alpha:0.4];
    _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    _datePickerView.backgroundColor = [UIColor whiteColor];
    _datePickerView.datePickerMode = UIDatePickerModeDate;
    _datePickerView.maximumDate = [NSDate new];
    _datePickerView.hidden = YES;
    NSString *time = [NSString stringWithFormat:@"1980-01-01 00:00:00"];
    NSLog(@"%@,%@",time,[DateUtil convertTime:time]);
    [_datePickerView setDate:[DateUtil convertTime:time] animated:YES];
    [_datePickerView addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_datePickerView];
    [self createSaveBtn];
}

- (void)createSaveBtn
{
    btnView = [[UIView alloc] init];
    btnView.backgroundColor = [UIColor whiteColor];
    [self addSubview:btnView];
    //
    btn = [[UILabel alloc] init];
    btn.text = @"完成";
    btn.textColor = [ColorUtil getColor:@"00B5B1" alpha:1];
    
    [btnView addSubview:btn];
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSave:)];
    [touch setNumberOfTapsRequired:1];
    btn.userInteractionEnabled = YES;
    [btn addGestureRecognizer:touch];
}

- (void)clickSave:(UITapGestureRecognizer *)tap
{
    [self.parent clickSaveDate];
}

- (void)dateChange:(UIDatePicker *)picker
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    _startTime = [df stringFromDate:picker.date];
}

- (void)setInfo:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"isBirthday"] boolValue]) {
        _startTime = [dict objectForKey:@"birthday"];
        if (_startTime.length == 0) {
            
            NSDate *date =  _datePickerView.date;
            _startTime = [DateUtil getFormatTime:date format:@"yyyy-MM-dd"];
        } else {

            NSString *time =[NSString stringWithFormat:@"%@ 00:00:00",[_startTime stringByReplacingOccurrencesOfString:@"." withString:@"-"]];
       //     NSLog(@"%@,%@",time,[DateUtil convertTime:time]);
            NSDate *date = [DateUtil convertTime:time formate:@"yyyy-MM-dd HH:mm:ss"];
            NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
            [_datePickerView setLocale:locale];
            [_datePickerView setDate:date animated:YES];
        }
        _datePickerView.hidden = NO;
    }
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    _datePickerView.frame = CGRectMake(0, size.height - 180, size.width, 180);
    btn.frame = CGRectMake(size.width - 60, 5, 60, 30);
    btnView.frame = CGRectMake(0, size.height-220, size.width, 40);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.hidden = YES;return;
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGRect frame = btnView.frame;
    frame.size.width = frame.size.width - 60;
    
    if (CGRectContainsPoint(frame, point)) {
        if (CGRectContainsPoint(btn.frame, point)) {
            self.hidden = YES;
        }
    } else {
        self.hidden = YES;
        
    }
}

@end
