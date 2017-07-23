//
//  CropImageViewController.h
//  CalendarCreator
//
//  Created by Truong Dat on 8/17/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleAndMoveObject.h"

@interface CropImageViewController : UIViewController<SPUserResizableViewDelegate>
{
    UIImageView *imageCropView;
    ScaleAndMoveObject *cropView;
    CGRect imageFrame;
    IBOutlet UIButton *actionBtn;
    BOOL isNeedDismiss;
}

@property (readwrite) NSInteger templateType;
@property (nonatomic, retain) UIColor *monthTitleColor;
@property (nonatomic, retain) UIColor *weekTitleColor;
@property (nonatomic, retain) UIColor *dayTitleColor;
@property (nonatomic, retain) NSDate *calDate;

- (void)setCropImage:(UIImage *)image;
- (void) setImageFrame:(CGRect )frame;
- (IBAction)backBtnClick:(id)sender;
@end
