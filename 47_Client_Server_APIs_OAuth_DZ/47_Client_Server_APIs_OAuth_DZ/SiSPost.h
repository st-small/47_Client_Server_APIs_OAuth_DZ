//
//  SiSPost.h
//  46_Client_Server_APIs_OAuth_T
//
//  Created by Stanly Shiyanovskiy on 03.07.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSServerObject.h"
#import <UIKit/UIKit.h>

@interface SiSPost : SiSServerObject

@property (strong, nonatomic) NSString* text;

@property (strong, nonatomic) NSURL* imageURL_50;

@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) NSURL* postImageURL;
@property (strong, nonatomic) UIImage* postImage;
@property (assign, nonatomic) NSInteger heightImage;
@property (assign, nonatomic) NSInteger widthImage;

@property (assign, nonatomic) NSInteger sizeText;

@property (strong, nonatomic) NSString* comments;
@property (strong, nonatomic) NSString* likes;
@property (strong, nonatomic) NSString* reposts;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
