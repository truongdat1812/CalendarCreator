//
//  CalMakerViewController.h
//  CalendarCreator
//
//  Created by Truong Dat on 8/6/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCalendarView.h"
#import "SelectedActionViewController.h"
#import "TwitterUtils.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface CalMakerViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,ActionDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>{
    DDCalendarView *calendarView;
    UIPopoverController *popoverController;
    UIImageView *backgroundImage;    
    TwitterUtils *_mTwitter;
    IBOutlet UIView *settingView;
    IBOutlet UIImageView *ownPhoto;
    UIActionSheet *menuAction;
    UIDatePicker *datePicker;
    UIImage *shareImage;
}
@property (readwrite) NSInteger templateType;
@property (nonatomic, retain) UIColor *monthTitleColor;
@property (nonatomic, retain) UIColor *weekTitleColor;
@property (nonatomic, retain) UIColor *dayTitleColor;
@property (nonatomic, retain) NSDate *calDate;
- (void)setBacgroundImage:(UIImage *)image;
- (IBAction)selectedAction:(id)sender;
- (IBAction)cancelSetting:(id)sender;
- (IBAction)doneSetting:(id)sender;
- (IBAction)choosePhoto:(id)sender;
- (IBAction)selectMonth:(id)sender;
@end
