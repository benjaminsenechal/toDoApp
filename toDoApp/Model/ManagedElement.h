//
//  ManagedLesson.h
//  toDoApp
//
//  Created by Benjamin SENECHAL on 27/01/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface ManagedElement : NSObject

+(void)addElementWithTitle:(NSString *)title AndText:(NSString *)text;
+(NSArray *)listElements;
+(void)deleteElementWithID:(NSString*)uniqueID;
+(void)updateElementWithID:(NSString*)uniqueID Title:(NSString *)title AndText:(NSString *)text;
+(void)setCompletedWithID:(NSString*)uniqueID;

@end
