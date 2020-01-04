//
//  CustomField.m
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/22/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import "CustomField.h"

static CustomField * shareInstance = nil;

@interface CustomField ()
{

}

@end

@implementation CustomField

@synthesize textCompletion, textCompletion1;

+ (id)shareText
{
    if(!shareInstance)
    {
        shareInstance = [[CustomField alloc] init];
    }
    return shareInstance;
}


- (void)didDeploytextWith:(textCompletion)completion withTextField:(UITextField*)textField
{
    self.textCompletion = completion;
    
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didDeploytextWith1:(textCompletion1)completion1 withTextField:(UITextField*)textField
{
    self.textCompletion1 = completion1;
    
    [textField addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSString * temp = textField.text;

    self.textCompletion(0, [temp stringByReplacingOccurrencesOfString:@"." withString:@""]);
    
    textField.text = [self formatString:temp];
}

- (void)textFieldDidChange1:(UITextField *)textField
{
    NSString * temp = textField.text;
    
    self.textCompletion1(0, [temp stringByReplacingOccurrencesOfString:@"." withString:@""]);
    
    textField.text = [self formatString:temp];
}

- (NSString *)formatString:(NSString *)string
{
    // Strip out the commas that may already be here:
    NSString *newString = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([newString length] == 0) {
        return nil;
    }
    
    // Check for illegal characters
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSRange charRange = [newString rangeOfCharacterFromSet:disallowedCharacters];
    if ( charRange.location != NSNotFound) {
        return nil;
    }
    
    // Split the string into the integer and decimal portions
    NSArray *numberArray = [newString componentsSeparatedByString:@"."];
    if ([numberArray count] > 2) {
        // There is more than one decimal point
        return nil;
    }
    
    // Get the integer
    NSString *integer           = [numberArray objectAtIndex:0];
    NSUInteger integerDigits    = [integer length];
    if (integerDigits == 0) {
        return nil;
    }
    
    // Format the integer.
    // You can do this by first converting to a number and then back to a string,
    // but I would rather keep it as a string instead of doing the double conversion.
    // If performance is critical, I would convert this to a C string to do the formatting.
    NSMutableString *formattedString = [[NSMutableString alloc] init];
    if (integerDigits < 4) {
        [formattedString appendString:integer];
    } else {
        // integer is 4 or more digits
        NSUInteger startingDigits = integerDigits % 3;
        if (startingDigits == 0) {
            startingDigits = 3;
        }
        [formattedString setString:[integer substringToIndex:startingDigits]];
        for (NSUInteger index = startingDigits; index < integerDigits; index = index + 3) {
            [formattedString appendFormat:@".%@", [integer substringWithRange:NSMakeRange(index, 3)]];
        }
    }
    
    // Add the decimal portion if there
    if ([numberArray count] == 2) {
        [formattedString appendString:@"."];
        NSString *decimal = [numberArray objectAtIndex:1];
        if ([decimal length] > 0) {
            [formattedString appendString:decimal];
        }
    }
    
    return formattedString;
}


@end
