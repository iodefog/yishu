//
//  AnnotiontationView.m
//  medtree
//
//  Created by tangshimi on 6/14/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "AnnotationView.h"

@interface AnnotationView ()

@property (nonatomic, strong)UIImageView *myAnnotionView;

@end

@implementation AnnotationView

- (instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bounds = CGRectMake(0, 0, 20, 20);
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.myAnnotionView];
        self.myAnnotionView.frame = self.bounds;
        self.myAnnotionView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setter and getter -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIImageView *)myAnnotionView
{
    if (!_myAnnotionView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"default_marker.png"];
        _myAnnotionView = imageView;
    }
    return _myAnnotionView;
}

@end
