//
//  CropImageViewController.m
//  CalendarCreator
//
//  Created by Truong Dat on 8/17/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import "CropImageViewController.h"
#import "CalMakerViewController.h"

@interface CropImageViewController ()

@end

@implementation CropImageViewController
@synthesize templateType;
@synthesize monthTitleColor;
@synthesize weekTitleColor;
@synthesize dayTitleColor;
@synthesize calDate;

- (void)dealloc
{
    [monthTitleColor release];
    [weekTitleColor release];
    [dayTitleColor release];
    [calDate release];
    [imageCropView release];
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
    imageCropView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"template_4.jpg"]];
    [self.view addSubview:imageCropView];
    
    imageCropView.frame = CGRectMake((self.view.frame.size.width - imageCropView.frame.size.width)/2, (self.view.frame.size.height - imageCropView.frame.size.height)/2 + 68, imageCropView.frame.size.width, imageCropView.frame.size.height);
    
    // Do any additional setup after loading the view from its nib.
    CGSize frameSize;
    switch (templateType) {
        case 1:
            frameSize = CGSizeMake(748, 480);
            break;
        case 2:
            frameSize = CGSizeMake(250*2, 270*2);
            break;
        case 3:
            frameSize = CGSizeMake(444, 450);
            break;
        case 4:
            frameSize = CGSizeMake(720, 465);
            break;
        case 5:
            frameSize = CGSizeMake(353, 400);
            break;
        case 6:
            frameSize = CGSizeMake(570, 340);
            break;
        case 7:
            frameSize = CGSizeMake(402, 550);
            break;
        case 8:
            frameSize = CGSizeMake(540, 360);
            break;
        case 9:
            frameSize = CGSizeMake(264*2, 180*2);
            break;
        case 10:
            frameSize = CGSizeMake(680, 420);
            break;
        case 11:
            frameSize = CGSizeMake(626, 380);
            break;
        default:
            frameSize = CGSizeMake(200, 360);
            break;
    }
    
    CGRect gripFrame = CGRectMake((self.view.frame.size.width - frameSize.width)/2, (self.view.frame.size.height - frameSize.height + 68)/2, frameSize.width, frameSize.height);
    imageFrame = gripFrame;
    ScaleAndMoveObject *userResizableView = [[ScaleAndMoveObject alloc] initWithFrame:gripFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
    [contentView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8]];
    userResizableView.contentView = contentView;
    userResizableView.delegate = self;
    [userResizableView showEditingHandles];
    cropView = [userResizableView retain];
    [self.view addSubview:userResizableView];
    [contentView release];
    [userResizableView release];
}

- (void)viewDidAppear:(BOOL)animated{
    if (isNeedDismiss) {
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    isNeedDismiss = NO;
}
// Called when the resizable view receives touchesBegan: and activates the editing handles.
- (void)userResizableViewDidBeginEditing:(ScaleAndMoveObject *)userResizableView{
    
}

// Called when the resizable view receives touchesEnded: or touchesCancelled:
- (void)userResizableViewDidEndEditing:(ScaleAndMoveObject *)userResizableView
{
    imageFrame = cropView.contentView.frame;
}

- (IBAction)donekBtnClick:(id)sende{
    CalMakerViewController *viewController = [[CalMakerViewController alloc] initWithNibName:@"CalMakerViewController" bundle:nil];
    viewController.templateType = templateType;
    viewController.monthTitleColor = monthTitleColor;
    viewController.weekTitleColor = weekTitleColor;
    viewController.dayTitleColor = dayTitleColor;
    viewController.calDate = calDate;
    
    [self presentViewController:viewController animated:YES completion:^{
    }];
    
    [viewController setBacgroundImage:imageCropView.image];
    
    [viewController release];
    isNeedDismiss = YES;
}
- (IBAction)backBtnClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)cropAndDone:(id)sender{
    if (cropView.isHidden) {
        [self donekBtnClick:nil];
    }else{
        [self crop:nil];
        [actionBtn setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    }
}
- (IBAction)crop:(id)sender{
   // UIImage *output = [self resizeToSize:imageCropView.frame.size thenCropWithRect:imageFrame withImage:imageCropView.image];
    CGImageRef   imageRef;
    imageFrame = CGRectMake(cropView.frame.origin.x - imageCropView.frame.origin.x, cropView.frame.origin.y - imageCropView.frame.origin.y, cropView.frame.size.width, cropView.frame.size.height);
    NSLog(@"imageFrame imageFrame imageFrame = %f, %f, %f, %f",imageFrame.origin.x, imageFrame.origin.y,imageFrame.size.width, imageFrame.size.height);
    if ( ( imageRef = CGImageCreateWithImageInRect( imageCropView.image.CGImage, CGRectMake(imageFrame.origin.x + 5, imageFrame.origin.y + 5, imageFrame.size.width - 10, imageFrame.size.height - 10)) ) )
    {
        imageCropView.image = [[[UIImage alloc] initWithCGImage: imageRef] autorelease];
    }
        
    imageCropView.frame = CGRectMake(imageFrame.origin.x + imageCropView.frame.origin.x + 5,imageFrame.origin.y +imageCropView.frame.origin.y + 5,imageFrame.size.width - 10,imageFrame.size.height - 10);
    cropView.hidden = YES;
}

- (void) setImageFrame:(CGRect )frame{
    imageFrame = frame;
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setCropImage:(UIImage *)image{
    if (image.size.width > self.view.frame.size.width) {
        image = [self imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 68)];
    }
    
    if (image.size.height > self.view.frame.size.height - 68) {
        image = [self imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 68)];
    }
    
    imageCropView.image = image;
    imageCropView.frame = CGRectMake((self.view.frame.size.width - image.size.width)/2, (self.view.frame.size.height - image.size.height + 68)/2, image.size.width, image.size.height);
    
    if (cropView.frame.size.width > imageCropView.frame.size.width) {
        float scale = cropView.frame.size.width/imageCropView.frame.size.width;
        [cropView setFrame:CGRectMake(imageCropView.frame.origin.x, imageCropView.frame.origin.y, imageCropView.frame.size.width, cropView.frame.size.height/scale)];
    }
    
    if (cropView.frame.size.height > imageCropView.frame.size.height) {
        float scale = cropView.frame.size.height/imageCropView.frame.size.height;
        [cropView setFrame:CGRectMake(imageCropView.frame.origin.x, imageCropView.frame.origin.y, cropView.frame.size.width/scale, imageCropView.frame.size.height)];
    }
}

- (UIImage *) resizeToSize:(CGSize) newSize thenCropWithRect:(CGRect) cropRect withImage:(UIImage *)image{
    CGContextRef                context;
    CGImageRef                  imageRef;
    CGSize                      inputSize;
    UIImage                     *outputImage = nil;
    CGFloat                     scaleFactor, width;
    
    // resize, maintaining aspect ratio:
    
    inputSize = image.size;
    scaleFactor = newSize.height / inputSize.height;
    width = roundf( inputSize.width * scaleFactor );
    
    if ( width > newSize.width ) {
        scaleFactor = newSize.width / inputSize.width;
        newSize.height = roundf( inputSize.height * scaleFactor );
    } else {
        newSize.width = width;
    }
    
    UIGraphicsBeginImageContext( newSize );
    
    context = UIGraphicsGetCurrentContext();
    CGContextDrawImage( context, CGRectMake( 0, 0, newSize.width, newSize.height ), image.CGImage );
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    inputSize = newSize;
    
    // constrain crop rect to legitimate bounds
    if ( cropRect.origin.x >= inputSize.width || cropRect.origin.y >= inputSize.height ) return outputImage;
    if ( cropRect.origin.x + cropRect.size.width >= inputSize.width ) cropRect.size.width = inputSize.width - cropRect.origin.x;
    if ( cropRect.origin.y + cropRect.size.height >= inputSize.height ) cropRect.size.height = inputSize.height - cropRect.origin.y;
    
    // crop
    if ( ( imageRef = CGImageCreateWithImageInRect( outputImage.CGImage, cropRect ) ) ) {
        outputImage = [[[UIImage alloc] initWithCGImage: imageRef] autorelease];
        CGImageRelease( imageRef );
    }
    
    return outputImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
