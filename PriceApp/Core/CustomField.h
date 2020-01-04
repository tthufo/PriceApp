//
//  CustomField.h
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/22/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomField;

typedef void (^textCompletion)(int index, NSString* text);

typedef void (^textCompletion1)(int index, NSString* text);


@interface CustomField : NSObject

+ (id)shareText;

- (void)didDeploytextWith:(textCompletion)completion withTextField:(UITextField*)textField;

- (void)didDeploytextWith1:(textCompletion1)completion1 withTextField:(UITextField*)textField;

@property(nonatomic,copy) textCompletion textCompletion;

@property(nonatomic,copy) textCompletion1 textCompletion1;

@end
