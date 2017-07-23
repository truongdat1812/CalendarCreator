//
//  CalMakerViewController.m
//  CalendarCreator
//
//  Created by Truong Dat on 8/6/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import "CalMakerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SelectedActionViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import "StaticData.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface CalMakerViewController () 

@end

@implementation CalMakerViewController
@synthesize templateType;
@synthesize monthTitleColor;
@synthesize weekTitleColor;
@synthesize dayTitleColor;
@synthesize calDate;

- (void)dealloc{
    [calDate release];
    [monthTitleColor release];
    [weekTitleColor release];
    [dayTitleColor release];
    [_mTwitter release];
    [backgroundImage release];
    [shareImage release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int deltaY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        deltaY = 20;
    }
    if (templateType == 2) {
        UIView *calendarContentView = [[UIView alloc] initWithFrame:CGRectMake(10, 75 + deltaY, 748, 915 - deltaY)];
        [calendarContentView setTag:200];
        [calendarContentView setBackgroundColor:[UIColor whiteColor]];
        [calendarContentView.layer setCornerRadius:10.0f];
        [calendarContentView.layer setMasksToBounds:YES];
        calendarContentView.layer.borderWidth = 2;
        calendarContentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self.view addSubview:calendarContentView];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bg.jpg"]];
        backgroundImage.frame = CGRectMake(190, 50, 250, 270);
        [calendarContentView addSubview:backgroundImage];
        
        UIImageView *bgIV1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_2_1.png"]];
        bgIV1.frame = CGRectMake(0, 0, 748, 537);
        
        UIView *monthView = [[UIView alloc] initWithFrame:CGRectMake(0, 485, 748, 430)];
        [monthView setBackgroundColor:[UIColor whiteColor]];
        [calendarContentView addSubview:monthView];
        UIColor *bgPatternImage = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"frame_0.png"]];
        monthView.backgroundColor = bgPatternImage;
        
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(0,  44, monthView.frame.size.width, monthView.frame.size.height - 44) fontName:@"AmericanTypewriter" delegate:self andType:2 monthHeadingColor:monthTitleColor weekHeadingColor:weekTitleColor dayHeadingColor:dayTitleColor withBorder:YES];
        
        [monthView addSubview: calendarView];
        [calendarContentView addSubview:bgIV1];
        

        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:calDate];
        
        int year = [components year];
        int month = [components month];
        [calendarView updateCalendarForMonth:month forYear:year];
        
        [monthView release];
        [bgIV1 release];
        [calendarContentView release];
    }
    
    if (templateType == 1) {
        UIView *calendarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 68 + deltaY, self.view.frame.size.width, self.view.frame.size.height - 68 - deltaY)];
        [calendarContentView setTag:200];
        [calendarContentView setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_partern.png"]]];
        [self.view addSubview:calendarContentView];
        
        UIView *imageContentView = [[UIView alloc] initWithFrame:CGRectMake(10, 75 - 68, 748, 480)];
        [imageContentView.layer setCornerRadius:25.0f];
        [imageContentView.layer setMasksToBounds:YES];
        [calendarContentView addSubview:imageContentView];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bg.jpg"]];
        [backgroundImage setFrame:CGRectMake(0, 0, 748, 480)];
        [imageContentView addSubview:backgroundImage];
        
        UIView *calView = [[UIView alloc] initWithFrame:CGRectMake(10,563 - 68,748 , 430)];
        [calView setBackgroundColor:[UIColor whiteColor]];
        [calView.layer setCornerRadius:25.0f];
        [calView.layer setMasksToBounds:YES];
        [calendarContentView addSubview:calView];
        
        UIView *monthView = [[UIView alloc] initWithFrame:CGRectMake(0,0 ,748 , 430)];
        [calView addSubview:monthView];
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(monthView.frame.origin.x, monthView.frame.origin.y + 44, monthView.frame.size.width, monthView.frame.size.height - 44) fontName:@"AmericanTypewriter" delegate:self andType:templateType monthHeadingColor:monthTitleColor weekHeadingColor:weekTitleColor dayHeadingColor:dayTitleColor];
        calendarView.monthTitleColor = monthTitleColor;
        calendarView.weekTitleColor = weekTitleColor;
        calendarView.dayTitleColor = dayTitleColor;
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:calDate];
        
        int year = [components year];
        int month = [components month];
        [calendarView updateCalendarForMonth:month forYear:year];
        
        [monthView addSubview:calendarView];
        
        [monthView release];
        [calView release];
        [imageContentView release];
        [calendarContentView release];
    }
    
    if (templateType == 3) {
        UIView *calendarContentView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 500)/2, 68 + deltaY, 500, self.view.frame.size.height - 68 - deltaY)];
        [calendarContentView setTag:200];
        [calendarContentView setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:calendarContentView];
        
        calendarContentView.transform = CGAffineTransformIdentity;
        calendarContentView.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
        calendarContentView.bounds = CGRectMake(0.0, 0.0, 936, 500);
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bg.jpg"]];
        backgroundImage.frame = CGRectMake(33, 30, 444, 450);
        [calendarContentView addSubview:backgroundImage];
        
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_3"]];
        bgImage.frame = CGRectMake(0, 0, calendarContentView.frame.size.height, calendarContentView.frame.size.width);
        [calendarContentView addSubview:bgImage];
        
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(540, 70, 380,420) fontName:@"AmericanTypewriter" delegate:self andType:templateType monthHeadingColor:monthTitleColor weekHeadingColor:weekTitleColor dayHeadingColor:dayTitleColor];
        [calendarContentView addSubview: calendarView];
        
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:calDate];
        int year = [components year];
        int month = [components month];
        [calendarView updateCalendarForMonth:month forYear:year];
        
        [bgImage release];
        [calendarContentView release];
    }
    
    if (templateType == 4) {
        UIView *calendarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 68 + deltaY, self.view.frame.size.width, self.view.frame.size.height - 68 - deltaY)];
        [calendarContentView setTag:200];
        [calendarContentView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:calendarContentView];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bg.jpg"]];
        backgroundImage.frame = CGRectMake(30, 20, 720, 465);
        [calendarContentView addSubview:backgroundImage];
        
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame4"]];
        bgImage.frame = CGRectMake(0, 0, calendarContentView.frame.size.width, calendarContentView.frame.size.height);
        bgImage.frame = CGRectMake(0, 0, calendarContentView.frame.size.width, calendarContentView.frame.size.height);
        [calendarContentView addSubview:bgImage];
        
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(0, 542, 768,400) fontName:@"AmericanTypewriter" delegate:self andType:templateType monthHeadingColor:monthTitleColor weekHeadingColor:weekTitleColor dayHeadingColor:dayTitleColor];
        [calendarContentView addSubview: calendarView];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:calDate];
        
        int year = [components year];
        int month = [components month];
        [calendarView updateCalendarForMonth:month forYear:year];
        [calendarContentView release];
    }
    
    if (templateType == 5) {
        UIView *calendarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 68 - 450)/2 + deltaY, 768, 450 - deltaY)];
        [calendarContentView setTag:200];
        [calendarContentView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:calendarContentView];
        
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_5_bg.png"]];
        [calendarContentView addSubview:bgImage];
        
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(420, 30 , 320, 400) fontName:@"AmericanTypewriter" delegate:self andType:templateType monthHeadingColor:monthTitleColor weekHeadingColor:weekTitleColor dayHeadingColor:dayTitleColor];
        
        calendarView.monthTitleColor = monthTitleColor;
        calendarView.weekTitleColor = weekTitleColor;
        calendarView.dayTitleColor = dayTitleColor;
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:calDate];
        
        int year = [components year];
        int month = [components month];
        [calendarView updateCalendarForMonth:month forYear:year];
        
        [calendarContentView addSubview:calendarView];
        
        //add custom image here
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bg.jpg"]];
        backgroundImage.frame = CGRectMake(38, 15, 353, 400);
        [calendarContentView addSubview:backgroundImage];
        
        UIImageView *bgImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_5.png"]];
        [calendarContentView addSubview:bgImage2];
                
        UIImageView *frameTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame5_title.png"]];
        [frameTitle setFrame:CGRectMake(90, 30, frameTitle.frame.size.width, frameTitle.frame.size.height)];
        
        [calendarContentView addSubview:frameTitle];
        
        [frameTitle release];
        [bgImage2 release];
        [bgImage release];
        [calendarContentView release];
    }
    
    if (templateType == 6) {
        UIView *calendarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 68 + deltaY, self.view.frame.size.width, self.view.frame.size.height - 68 - deltaY)];
        [calendarContentView setTag:200];
        [calendarContentView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:calendarContentView];

        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bg.jpg"]];
        backgroundImage.frame = CGRectMake(100, 100, 570, 340);
        [calendarContentView addSubview:backgroundImage];
        
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_6"]];
        bgImage.frame = CGRectMake(0, 0, calendarContentView.frame.size.width, calendarContentView.frame.size.height);
        [calendarContentView addSubview:bgImage];
        
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(0, 542, 768,400) fontName:@"AmericanTypewriter" delegate:self andType:templateType monthHeadingColor:monthTitleColor weekHeadingColor:weekTitleColor dayHeadingColor:dayTitleColor];
        [calendarContentView addSubview: calendarView];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:calDate];
        
        int year = [components year];
        int month = [components month];
        [calendarView updateCalendarForMonth:month forYear:year];
        
        [bgImage release];
        [calendarContentView release];
    }

    if (templateType == 7) {
        UIView *calendarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 68 + deltaY, self.view.frame.size.width, self.view.frame.size.height - 68 - deltaY)];
        [calendarContentView setTag:200];
        [calendarContentView setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:calendarContentView];
        
        calendarContentView.transform = CGAffineTransformIdentity;
        calendarContentView.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
        calendarContentView.bounds = CGRectMake(0.0, 0.0, 936, 768);
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bg.jpg"]];
        backgroundImage.frame = CGRectMake(52, 111, 402, 550);
        [calendarContentView addSubview:backgroundImage];
        
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_7"]];
        bgImage.frame = CGRectMake(0, 0, calendarContentView.frame.size.height, calendarContentView.frame.size.width);
        [calendarContentView addSubview:bgImage];
        
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(540, 140, 380,420) fontName:@"AmericanTypewriter" delegate:self andType:templateType monthHeadingColor:monthTitleColor weekHeadingColor:weekTitleColor dayHeadingColor:dayTitleColor];
        [calendarContentView addSubview: calendarView];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:calDate];
        int year = [components year];
        int month = [components month];
        [calendarView updateCalendarForMonth:month forYear:year];
        
        [bgImage release];
        [calendarContentView release];
    }
    
    if (templateType == 8) {
        UIView *calendarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 68 + deltaY, self.view.frame.size.width, self.view.frame.size.height - 68 - deltaY)];
        [calendarContentView setTag:200];
        [calendarContentView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:calendarContentView];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bg.jpg"]];
        backgroundImage.frame = CGRectMake(120, 120, 540, 360);
        [calendarContentView addSubview:backgroundImage];
        
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_8"]];
        bgImage.frame = CGRectMake(0, 0, calendarContentView.frame.size.width, calendarContentView.frame.size.height);
        [calendarContentView addSubview:bgImage];
        
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(0, 570, 768,380) fontName:@"AmericanTypewriter" delegate:self andType:templateType monthHeadingColor:monthTitleColor weekHeadingColor:weekTitleColor dayHeadingColor:dayTitleColor];
        [calendarContentView addSubview: calendarView];
        [bgImage release];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:calDate];
        
        int year = [components year];
        int month = [components month];
        [calendarView updateCalendarForMonth:month forYear:year];
        [calendarContentView release];
    }
    
    if (templateType == 9) {
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_9"]];
        
        UIView *calendarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 68 - bgImage.frame.size.height)/2 + deltaY, bgImage.frame.size.width, bgImage.frame.size.height - deltaY)];
        [calendarContentView setTag:200];
        [calendarContentView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:calendarContentView];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bg.jpg"]];
        backgroundImage.frame = CGRectMake(67, 135, 264, 180);
        [calendarContentView addSubview:backgroundImage];
        backgroundImage.transform = CGAffineTransformIdentity;
        backgroundImage.transform = CGAffineTransformMakeRotation(degreesToRadian(36));
        
        [calendarContentView addSubview:bgImage];
        
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(367, 140, 380,300) fontName:@"AmericanTypewriter" delegate:self andType:templateType monthHeadingColor:monthTitleColor weekHeadingColor:weekTitleColor dayHeadingColor:dayTitleColor];
        [calendarContentView addSubview: calendarView];
        [bgImage release];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:calDate];
        
        int year = [components year];
        int month = [components month];
        [calendarView updateCalendarForMonth:month forYear:year];
        [calendarContentView release];
    }
    
    if (templateType == 10) {
        UIView *calendarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 68 + deltaY, self.view.frame.size.width, self.view.frame.size.height - 68 - deltaY)];
        [calendarContentView setTag:200];
        [calendarContentView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:calendarContentView];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bg.jpg"]];
        backgroundImage.frame = CGRectMake(18, 50, 682, 425);
        [calendarContentView addSubview:backgroundImage];
        
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_10"]];
        bgImage.frame = CGRectMake(0, 0, calendarContentView.frame.size.width, calendarContentView.frame.size.height);
        [calendarContentView addSubview:bgImage];
        
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(0, 500, 768,400) fontName:@"AmericanTypewriter" delegate:self andType:templateType monthHeadingColor:monthTitleColor weekHeadingColor:weekTitleColor dayHeadingColor:dayTitleColor];
        [calendarContentView addSubview: calendarView];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:calDate];
        
        int year = [components year];
        int month = [components month];
        [calendarView updateCalendarForMonth:month forYear:year];
        
        [bgImage release];
        [calendarContentView release];
    }
    
    if (templateType == 11) {
        UIView *calendarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 68 + deltaY, self.view.frame.size.width, self.view.frame.size.height - 68 - deltaY)];
        [calendarContentView setTag:200];
        [calendarContentView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:calendarContentView];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bg.jpg"]];
        backgroundImage.frame = CGRectMake(80, 68, 626, 380);
        [calendarContentView addSubview:backgroundImage];
        
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_11"]];
        bgImage.frame = CGRectMake(0, 0, calendarContentView.frame.size.width, calendarContentView.frame.size.height);
        [calendarContentView addSubview:bgImage];
        
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(0, 510, 768,400) fontName:@"AmericanTypewriter" delegate:self andType:templateType monthHeadingColor:monthTitleColor weekHeadingColor:weekTitleColor dayHeadingColor:dayTitleColor];
        [calendarContentView addSubview: calendarView];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:calDate];
        
        int year = [components year];
        int month = [components month];
        [calendarView updateCalendarForMonth:month forYear:year];
        
        [bgImage release];
        [calendarContentView release];
    }
    
    _mTwitter = [[TwitterUtils alloc] init];
    
    [self.view addSubview:settingView];
    [settingView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [settingView setHidden:YES];
    
    [ownPhoto.layer setCornerRadius:20.0f];
    [ownPhoto.layer setMasksToBounds:YES];
    [ownPhoto setImage:backgroundImage.image];
    
    UIView *settingContentView = (UIView*)[settingView viewWithTag:202];
    [settingContentView.layer setCornerRadius:20.0f];
    [settingContentView.layer setMasksToBounds:YES];
    
    UIButton *colorBtn1 = (UIButton *)[settingView viewWithTag:302];
    [colorBtn1 setBackgroundColor:monthTitleColor];
    
    UIButton *colorBtn2 = (UIButton *)[settingView viewWithTag:303];
    [colorBtn2 setBackgroundColor:weekTitleColor];
    
    UIButton *colorBtn3 = (UIButton *)[settingView viewWithTag:304];
    [colorBtn3 setBackgroundColor:dayTitleColor];
    
//    UILabel *dateLable = (UILabel*)[settingView viewWithTag:300];
//    NSString *text = [self dateToString:calDate];
//    text = [NSString stringWithFormat:@"%@,%@",[text substringWithRange:NSMakeRange(0, 3)],[text substringWithRange:NSMakeRange(7, 5)]];
//    dateLable.text = text;
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 38.0, 280, 230)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    //[self initToolBar];
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)selectMonth:(id)sender{
    if(menuAction != nil)
    {
        [menuAction release];
        menuAction = nil;
    }
    
    menuAction = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Dates", nil)
                                             delegate:self
                                    cancelButtonTitle:nil
                               destructiveButtonTitle:nil
                                    otherButtonTitles: NSLocalizedString(@" ", nil),NSLocalizedString(@" ", nil), NSLocalizedString(@" ", nil),NSLocalizedString(@"", nil), nil];
    menuAction.frame = CGRectMake(0, 0, 350, 495);
    
    //Add toolbar
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,280,40)];
    [pickerToolbar sizeToFit];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(cancel_clicked:)];
    [barItems addObject:cancelBtn];
    [cancelBtn release];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] init];
    [flexSpace setWidth:130];
    [barItems addObject:flexSpace];
    [flexSpace release];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    [barItems addObject:doneBtn];
    [doneBtn release];
    
    [pickerToolbar setItems:barItems animated:YES];
    [menuAction addSubview:pickerToolbar];
    [barItems release];
    [pickerToolbar release];
    
    
    [menuAction addSubview:datePicker];
    [menuAction showInView:self.view];
    
}

-(IBAction)dateChanged
{
    [calDate release];
    calDate = [[datePicker date] retain];
}
- (IBAction)cancel_clicked:(id)sender{
    [menuAction dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)done_clicked:(id)sender{
    NSString *text = [self dateToString:calDate];
    text = [NSString stringWithFormat:@"%@,%@",[text substringWithRange:NSMakeRange(0, 3)],[text substringWithRange:NSMakeRange(7, 5)]];
    UILabel *dateLable = (UILabel*)[settingView viewWithTag:300];
    dateLable.text = text;
    [menuAction dismissWithClickedButtonIndex:0 animated:YES];
}


- (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *string = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return string;
}
- (void)setBacgroundImage:(UIImage *)image{
    if (templateType == 5) {
        image = [StaticData convertImageToGrayScale:image];
    }
    [backgroundImage setImage:image];
    
    UIView *view = (UIView *)[self.view viewWithTag:200];
    CGRect frame = view.frame;
    if (templateType == 7) {
        view.transform = CGAffineTransformIdentity;
        view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
        view.bounds = CGRectMake(0.0, 0.0, 936, 768);
        view.frame = CGRectMake(0.0, 0.0, 936, 768);
    }
    
    if (templateType == 3) {
        view.transform = CGAffineTransformIdentity;
        view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
        view.bounds = CGRectMake(0.0, 0.0, 936, 500);
        view.frame = CGRectMake(0.0, 0.0, 936, 500);
    }
    
    shareImage = [[self captureView:view] retain];
    
    if(templateType == 3 || templateType == 7){
        view.frame = frame;
    }
}
- (void) initToolBar{
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    UIColor *bgPatternImage = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"tool_bar_bg"]];
    toolBar.backgroundColor = bgPatternImage;
    [bgPatternImage release];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5,6,40,40)];
    //[backBtn setTag:BTN_RETURN_TO_CALL];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    [toolBar addSubview:backBtn];
    
    UIButton *bgChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgChangeBtn setFrame:CGRectMake(backBtn.frame.origin.x + backBtn.frame.size.width + 10,6,40,40)];
    //[backBtn setTag:BTN_RETURN_TO_CALL];
    [bgChangeBtn addTarget:self action:@selector(loadPicture:) forControlEvents:UIControlEventTouchUpInside];
    [bgChangeBtn setBackgroundImage:[UIImage imageNamed:@"picture_s2"] forState:UIControlStateNormal];
    [toolBar addSubview:bgChangeBtn];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(bgChangeBtn.frame.origin.x + bgChangeBtn.frame.size.width + 10,6,40,40)];
    //[backBtn setTag:BTN_RETURN_TO_CALL];
    [saveBtn addTarget:self action:@selector(savePicture:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"save_n"] forState:UIControlStateNormal];
    [toolBar addSubview:saveBtn];
    
    [self.view addSubview:toolBar];
    [toolBar release];
}

- (IBAction)loadPicture:(id)sender{
    UIImagePickerController * picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.delegate = self;
    picker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil] autorelease];
    
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if (popoverController) {
        [popoverController release];
    }
    popoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
    if (self.navigationController == nil) {
        popoverController.popoverContentSize = CGSizeMake(800, 800);//CGSizeMake(700, 800);
        [popoverController presentPopoverFromRect:CGRectMake(0, -800, 800, 800) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        popoverController.popoverContentSize = CGSizeMake(self.view.bounds.size.width / 2, 800);//CGSizeMake(700, 800);
        [popoverController presentPopoverFromRect:CGRectMake(0, 0, self.view.bounds.size.width / 2, 800) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)backBtnClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    //UIColor *bgPatternImage = [[UIColor alloc] initWithPatternImage:image];
    //calendarView.backgroundColor = bgPatternImage;
    //[bgPatternImage release];
    [backgroundImage setImage:image];
    //[self dismissViewControllerAnimated:YES completion:^{}];
    if (popoverController.isPopoverVisible) {
        [popoverController dismissPopoverAnimated:YES];
    }
}

- (IBAction)selectedAction:(id)sender{
    if (popoverController) {
        [popoverController dismissPopoverAnimated:NO];
        [popoverController release];
    }
        SelectedActionViewController *selectionView = [[SelectedActionViewController alloc] initWithNibName:@"SelectedActionViewController" bundle:nil];
        selectionView.delegate = self;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:selectionView];
        popoverController.delegate = self;
        popoverController.popoverContentSize = CGSizeMake(200, 176);
        CGRect popRect = CGRectMake(650, -135, 200, 176);
        [popoverController presentPopoverFromRect:popRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

//- (IBAction)savePicture:(id)sender{
//    [self saveScreenshotToPhotosAlbum:self.view];
//}

- (void)saveScreenshotToPhotosAlbum:(UIView *)view
{
    //UIImageWriteToSavedPhotosAlbum([self captureView:view], nil, nil, nil);
    UIImageWriteToSavedPhotosAlbum(shareImage, nil, nil, nil);
}

- (UIImage*)captureView:(UIView *)view
{
    CGRect rect = view.frame;//[[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)dayButtonPressed:(DayButton *)button {
	//For the sake of example, we obtain the date from the button object
	//and display the string in an alert view
    
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
//	NSString *theDate = [dateFormatter stringFromDate:button.buttonDate];
//	[dateFormatter release];
//	
//	UIAlertView *dateAlert = [[UIAlertView alloc]
//                              initWithTitle:@"Date Pressed"
//                              message:theDate
//                              delegate:self
//                              cancelButtonTitle:@"Ok"
//                              otherButtonTitles:nil];
//	[dateAlert show];
//	[dateAlert release];
}

- (void)nextButtonPressed {
	NSLog(@"Next...");
}

- (void)prevButtonPressed {
	NSLog(@"Prev...");
}

- (void) saveToPhoto{
    UIView *view = (UIView *)[self.view viewWithTag:200];
    [self saveScreenshotToPhotosAlbum:view];
    [popoverController dismissPopoverAnimated:YES];
}

- (void) shareToFacebook{
    [popoverController dismissPopoverAnimated:YES];
    
    // Just use the icon image from the application itself.  A real app would have a more
    // useful way to get an image.
    UIImage *img = shareImage;
    
    [self performPublishAction:^{
        FBRequestConnection *connection = [[FBRequestConnection alloc] init];
        connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
        | FBRequestConnectionErrorBehaviorAlertUser
        | FBRequestConnectionErrorBehaviorRetry;
        
        [connection addRequest:[FBRequest requestForUploadPhoto:img]
             completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 
                 [self showAlert:@"Photo Post" result:result error:error];
                 if (FBSession.activeSession.isOpen) {
                     
                 }
             }];
        [connection start];
        
    }];
}



- (void) shareToTwitter{
    UIImage *newImg = shareImage;
    [_mTwitter sendTweetWithImage:@"From CalendarCreator" withImage:newImg andViewController:self];
}


- (void) setting{
    [popoverController dismissPopoverAnimated:YES];
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Calendar creator application"];
    [controller setMessageBody:@"Hi , <br/>  This is my new latest designed calendar." isHTML:YES];
    [controller addAttachmentData:UIImagePNGRepresentation(shareImage) mimeType:@"image/png" fileName:@"My Calendar Card"];
    if (controller)
        [self presentViewController:controller animated:YES completion:^{}];
    [controller release];
    //[settingView setHidden:NO];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)cancelSetting:(id)sender{
    [settingView setHidden:YES];
}

- (IBAction)doneSetting:(id)sender{
    [settingView setHidden:YES];
}


// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                } else if (error.fberrorCategory != FBErrorCategoryUserCancelled){
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                                                        message:@"Unable to get permission to post"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                    [alertView show];
                                                }
                                            }];
    } else {
        action();
    }
    
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we do not need to surface our own alert view if there is an
        // an fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;
            
        } else {
            // Otherwise, use a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    if (alertTitle) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choosePhoto:(id)sender{
    UIActionSheet* act = [[UIActionSheet alloc]
                          initWithTitle:NSLocalizedString(@"Choice photo", nil)
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                          destructiveButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"Take a photo", nil), NSLocalizedString(@"From Albums", nil), nil];
    act.tag = 101;
    [act showInView:self.view];
    [act release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self loadPicture:nil];
            break;
        default:
            break;
    }
}

@end
