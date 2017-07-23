//
//  TemplateViewController.h
//  CalendarCreator
//
//  Created by Truong Dat on 8/6/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerController.h"
#import "CoverflowViewController.h"
#import "DropDownListViewController.h"

@interface TemplateViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ColorPickerDelegate, UIPopoverControllerDelegate,CoverFlowDelegate,DropDownPickerDelegate,UITextFieldDelegate>{
    NSInteger currTemplate;
    IBOutlet UIView *settingView;
    IBOutlet UIView *templateView;
    IBOutlet UIImageView *photoChooseView;
    IBOutlet UILabel *monthLevel;
    UIPopoverController *popoverController;
    UIActionSheet *menuAction;
    UIDatePicker *datePicker;
    NSDate *mDate;
    BOOL useOwnPhoto;
    NSInteger typeColor;
    CoverflowViewController *coverFlow;
    DropDownListViewController *_dropDownPicker;
    UIPopoverController *_dropDownPickerPopover;
    NSArray *monthArray;
}
- (IBAction)backToHome:(id)sender;
- (IBAction)choosePhoto:(id)sender;
- (IBAction)selectMonth:(id)sender;
- (IBAction)monthColor:(id)sender;
- (IBAction)weekColor:(id)sender;
- (IBAction)dayColor:(id)sender;
@end
