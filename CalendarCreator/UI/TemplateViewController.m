//
//  TemplateViewController.m
//  CalendarCreator
//
//  Created by Truong Dat on 8/6/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import "TemplateViewController.h"
#import "CalMakerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CropImageViewController.h"

@interface TemplateViewController ()

@end

@implementation TemplateViewController

- (void)dealloc{
    [coverFlow release];
    [popoverController release];
    [datePicker release];
    [photoChooseView release];
    [settingView release];
    [templateView release];
    [_dropDownPicker release];
    [_dropDownPickerPopover release];
    [monthArray release];
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
    //[settingView.layer setCornerRadius:10.0f];
    //[settingView.layer setMasksToBounds:YES];
    monthArray = [[NSArray alloc] initWithObjects:@"January", @"Febrary", @"March", @"April", @"May", @"June",
                      @"July", @"August", @"September", @"October", @"November", @"December",nil];
    
    [templateView.layer setCornerRadius:10.0f];
    [templateView.layer setMasksToBounds:YES];
    [templateView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3]];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"template_bg.png"]];
    coverFlow = [[CoverflowViewController alloc] init];
    coverFlow.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        coverFlow.view.frame = CGRectMake(coverFlow.view.frame.origin.x, coverFlow.view.frame.origin.y - 80, coverFlow.view.frame.size.width, coverFlow.view.frame.size.height);
    }
    [templateView addSubview:coverFlow.view];
    coverFlow.delegate = self;
    //[cover release];
    
    [photoChooseView.layer setCornerRadius:20.0f];
    [photoChooseView.layer setMasksToBounds:YES];
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:300];
    UIImage *image = [UIImage imageNamed:@"template_1.jpg"];
    [imageView setFrame:CGRectMake((templateView.frame.size.width - image.size.width)/2,(templateView.frame.size.height - image.size.height)/2,image.size.width,image.size.height)];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 38.0, 280, 230)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    //Friday, August 23, 2013
    mDate = [[NSDate date] retain];

    NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
    mmddccyy.timeStyle = NSDateFormatterNoStyle;
    mmddccyy.dateFormat = @"MM/dd/yyyy";
    NSString *dateString = [mmddccyy stringFromDate:mDate];
    NSArray *chunks = [dateString componentsSeparatedByString:@"/"];
    
    NSLog(@"chunks[0] = %@",chunks[0]);
    [mmddccyy release];
    NSInteger month = [chunks[0] integerValue];
    if (month < 0 || month > 12) {
        monthLevel.text = @"September";
    }else{
        monthLevel.text = monthArray[month - 1];
    }
    currTemplate = 1;
    
    UIButton *button = (UIButton *)[settingView viewWithTag:600];
    button.layer.cornerRadius = 10.0;
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

- (void) takePhoto{
    UIImagePickerController * picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.delegate = self;
	if (popoverController) {
        [popoverController release];
    }
    popoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
	popoverController.delegate = self;
	popoverController.popoverContentSize = CGSizeMake(self.view.bounds.size.width / 2, 500);
	CGRect popRect = CGRectMake(400, - 200, self.view.bounds.size.width / 2, 500);
    picker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil] autorelease];
    
    //popRect = [self.view convertRect: buttonPhotos.bounds fromView:buttonPhotos];
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //Select front facing camera if possible
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    picker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil] autorelease];
    picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    [popoverController presentPopoverFromRect:popRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

- (void)loadPhoto{
    
    UIImagePickerController * picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.delegate = self;
	picker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil] autorelease];
	
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    if (popoverController) {
        [popoverController release];
    }
	popoverController = [[UIPopoverController alloc] initWithContentViewController:picker];

    popoverController.popoverContentSize = CGSizeMake(self.view.bounds.size.width / 2, 800);//CGSizeMake(700, 800);
    [popoverController presentPopoverFromRect:CGRectMake(0, 0, self.view.bounds.size.width / 2, 800) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self loadPhoto];
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    [photoChooseView setImage:image];
    useOwnPhoto = YES;
    [popoverController dismissPopoverAnimated:YES];
}

- (IBAction)next:(id)sender{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:300];
    if (currTemplate >= 4) {
        currTemplate = 1;
    }else{
        currTemplate++;
    }
    NSString *imageName = [NSString stringWithFormat:@"template_%d.jpg",currTemplate];
    UIImage *image = [UIImage imageNamed:imageName];
    [imageView setFrame:CGRectMake((templateView.frame.size.width - image.size.width)/2,(templateView.frame.size.height - image.size.height)/2,image.size.width,image.size.height)];
    [imageView setImage:image];
}

- (IBAction)previous:(id)sender{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:300];
    if (currTemplate <= 1) {
        currTemplate = 4;
    }else{
        currTemplate--;
    }
    NSString *imageName = [NSString stringWithFormat:@"template_%d.jpg",currTemplate];
    UIImage *image = [UIImage imageNamed:imageName];
    [imageView setFrame:CGRectMake((templateView.frame.size.width - image.size.width)/2,(templateView.frame.size.height - image.size.height)/2,image.size.width,image.size.height)];
    [imageView setImage:image];
}

- (IBAction)select:(id)sender{
    NSString *month = monthLevel.text;
    UITextField *textField = (UITextField *)[settingView viewWithTag:103];
    [textField resignFirstResponder];
    NSString *date = [NSString stringWithFormat:@"%@/%@/%@",@"10",month,textField.text];
    
    NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
    mmddccyy.timeStyle = NSDateFormatterNoStyle;
    mmddccyy.dateFormat = @"dd/MM/yyyy";
    mDate = [mmddccyy dateFromString:date];
    [mmddccyy release];
    
    if (useOwnPhoto) {
        CropImageViewController *viewController = [[CropImageViewController alloc] initWithNibName:@"CropImageViewController" bundle:nil];
        
        viewController.templateType = currTemplate;
        UIButton *button1 = (UIButton *)[settingView viewWithTag:100];
        viewController.monthTitleColor = button1.backgroundColor;
        
        UIButton *button2 = (UIButton *)[settingView viewWithTag:101];
        viewController.weekTitleColor = button2.backgroundColor;
        
        UIButton *button3 = (UIButton *)[settingView viewWithTag:102];
        viewController.dayTitleColor = button3.backgroundColor;
        viewController.calDate = mDate;
        
        [self presentViewController:viewController animated:YES completion:^{}];
        [viewController setCropImage:photoChooseView.image];
        [viewController release];
    }else{
//         CalMakerViewController *viewController = [[CalMakerViewController alloc] initWithNibName:@"CalMakerViewController" bundle:nil];
//         viewController.templateType = currTemplate;
//         UIButton *button1 = (UIButton *)[settingView viewWithTag:100];
//         viewController.monthTitleColor = button1.backgroundColor;
//         
//         UIButton *button2 = (UIButton *)[settingView viewWithTag:101];
//         viewController.weekTitleColor = button2.backgroundColor;
//         
//         UIButton *button3 = (UIButton *)[settingView viewWithTag:102];
//         viewController.dayTitleColor = button3.backgroundColor;
//         viewController.calDate = mDate;
//         [self presentViewController:viewController animated:YES completion:^{}];
////         if (useOwnPhoto) {
////         [viewConroller setBacgroundImage:photoChooseView.image];
////         }
//         [viewController release];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Use defaut photo? Click cancel and choose your own photo!", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        photoChooseView.image = [UIImage imageNamed:@"default_bg.jpg"];
        useOwnPhoto = YES;
        [self select:nil];
    }
}
- (IBAction)backToHome:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)selectMonth:(id)sender{
    
    if (_dropDownPicker == nil) {
        _dropDownPicker = [[[DropDownListViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        _dropDownPicker._delegate = self;
        _dropDownPickerPopover = [[UIPopoverController alloc] initWithContentViewController:_dropDownPicker];

        [_dropDownPicker setDropDownArray:monthArray];
        [_dropDownPicker.tableView reloadData];
    }
    
    [_dropDownPickerPopover presentPopoverFromRect:CGRectMake(70, -50,200, 250) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
//    return;
//    
//    if(menuAction != nil)
//    {
//        [menuAction release];
//        menuAction = nil;
//    }
//    
//    menuAction = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Dates", nil)
//                                             delegate:self
//                                    cancelButtonTitle:nil
//                               destructiveButtonTitle:nil
//                                    otherButtonTitles: NSLocalizedString(@" ", nil),NSLocalizedString(@" ", nil), NSLocalizedString(@" ", nil),NSLocalizedString(@"", nil), nil];
//    menuAction.frame = CGRectMake(0, 0, 350, 495);
//    
//    //Add toolbar
//    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,280,40)];
//    [pickerToolbar sizeToFit];
//    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
//    NSMutableArray *barItems = [[NSMutableArray alloc] init];
//    
//    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(cancel_clicked:)];
//    [barItems addObject:cancelBtn];
//    [cancelBtn release];
//    
//    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] init];
//    [flexSpace setWidth:130];
//    [barItems addObject:flexSpace];
//    [flexSpace release];
//    
//    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
//    [barItems addObject:doneBtn];
//    [doneBtn release];
//    
//    [pickerToolbar setItems:barItems animated:YES];
//    [menuAction addSubview:pickerToolbar];
//    [barItems release];
//    [pickerToolbar release];
//    
//    
//    [menuAction addSubview:datePicker];
//    [menuAction showInView:self.view];
    
}
- (void)dropDownItemSelected:(NSString *)item{
    monthLevel.text = item;
}

-(IBAction)dateChanged
{
    [mDate release];
    mDate = [[datePicker date] retain];
}
- (IBAction)cancel_clicked:(id)sender{
    [menuAction dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) selectImageAtIndex:(NSInteger) index;{
    NSLog(@"selectImageAtIndex = %d",index);
    currTemplate = index + 1;
    UIButton *button1 = (UIButton *)[settingView viewWithTag:100];
    [button1 setBackgroundColor:[UIColor darkTextColor]];
    UIButton *button2 = (UIButton *)[settingView viewWithTag:101];
    [button2 setBackgroundColor:[UIColor darkGrayColor]];
    UIButton *button3 = (UIButton *)[settingView viewWithTag:102];
    [button3 setBackgroundColor:[UIColor darkGrayColor]];
    
    if (currTemplate == 5 || currTemplate == 7 || currTemplate == 6 || currTemplate == 11) {
        [button1 setBackgroundColor:[UIColor whiteColor]];
        [button2 setBackgroundColor:[UIColor whiteColor]];
        [button3 setBackgroundColor:[UIColor whiteColor]];
    }
}

- (IBAction)done_clicked:(id)sender{
    NSString *text = [self dateToString:mDate];
    text = [NSString stringWithFormat:@"%@,%@",[text substringWithRange:NSMakeRange(0, 3)],[text substringWithRange:NSMakeRange(7, 5)]];
    monthLevel.text = text;
    [menuAction dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)monthColor:(id)sender{
    ColorPickerController *colorPicker = [[ColorPickerController alloc] initWithColor:[UIColor redColor] andTitle:@"Color Picker"];
    colorPicker.delegate = self;
    [self presentViewController:colorPicker animated:YES completion:^{}];
    typeColor = 1;
    [colorPicker release];
}

- (IBAction)weekColor:(id)sender{
    ColorPickerController *colorPicker = [[ColorPickerController alloc] initWithColor:[UIColor redColor] andTitle:@"Color Picker"];
    colorPicker.delegate = self;
    [self presentViewController:colorPicker animated:YES completion:^{}];
    typeColor = 2;
    [colorPicker release];
}

- (IBAction)dayColor:(id)sender{
    ColorPickerController *colorPicker = [[ColorPickerController alloc] initWithColor:[UIColor redColor] andTitle:@"Color Picker"];
    colorPicker.delegate = self;
    [self presentViewController:colorPicker animated:YES completion:^{}];
    typeColor = 3;
    [colorPicker release];
}

- (void)colorPickerSaved:(ColorPickerController *)controller{
    UIColor *color = [controller selectedColor];
    UIButton *button;
    switch (typeColor) {
        case 1:
            button = (UIButton *)[settingView viewWithTag:100];
            [button setBackgroundColor:color];
            break;
        case 2:
            button = (UIButton *)[settingView viewWithTag:101];
            [button setBackgroundColor:color];
            break;
        case 3:
            button = (UIButton *)[settingView viewWithTag:102];
            [button setBackgroundColor:color];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)colorPickerCancelled:(ColorPickerController *)controller{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark -
#pragma mark Picker View Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"";
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    NSString *string = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return string;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//
//}
// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}
// became first responder
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//
//}          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

//- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
// called when 'return' key pressed. return NO to ignore.

@end
