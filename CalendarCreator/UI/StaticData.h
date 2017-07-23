//
//  StaticData.h
//  CalendarCreator
//
//  Created by Truong Dat on 8/13/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticData : NSObject
{

}

+ (UIImage *)convertImageToGrayScale:(UIImage *)image;
+(StaticData *)getInstance;
@end
