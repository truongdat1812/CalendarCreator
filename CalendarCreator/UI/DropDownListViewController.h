//
//  DropDownListViewController.h
//  CalendarCreator
//
//  Created by Truong Dat on 8/23/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownPickerDelegate
- (void)dropDownItemSelected:(NSString *)item;
@end
@interface DropDownListViewController : UITableViewController{
    NSMutableArray *_dropDownArray;
    id<DropDownPickerDelegate> _delegate;
    
}

@property (nonatomic, retain) NSMutableArray *_dropDownArray;
@property (nonatomic, retain) id<DropDownPickerDelegate> _delegate;
- (void)setDropDownArray:(NSArray *) array;
@end

