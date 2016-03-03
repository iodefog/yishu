//
//  NewGenderPickerView.m
//  medtree
//
//  Created by 边大朋 on 15-4-6.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewGenderPickerView.h"
#import "ColorUtil.h"
@interface NewGenderPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UILabel         *btn;
    NSInteger       gender;
    UIView          *btnView;
}
@end

@implementation NewGenderPickerView


- (void)createUI
{
    self.backgroundColor = [ColorUtil getColor:@"000000" alpha:0.4];
    _picker = [[UIPickerView alloc] init];
    _picker.backgroundColor = [UIColor whiteColor];
    _picker.delegate = self;
    _picker.dataSource = self;
    [self addSubview:_picker];
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
    [self.parent clickSaveGender:gender];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    gender = row + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"男";
    }else {
        return @"女";
    }
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    btn.frame = CGRectMake(size.width - 60, 5, 60, 30);
    _picker.frame = CGRectMake(0, size.height-150, size.width, 150);
    btnView.frame = CGRectMake(0, size.height-190, size.width, 40);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
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
