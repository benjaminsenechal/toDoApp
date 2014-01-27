//
//  ManagedLesson.m
//  toDoApp
//
//  Created by Benjamin SENECHAL on 27/01/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "ManagedLesson.h"

@implementation ManagedLesson

+(void)addElementWithTitle:(NSString *)title AndText:(NSString *)text{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    Element *e = [NSEntityDescription insertNewObjectForEntityForName:@"Element" inManagedObjectContext:context];
    [e setTitle:title];
    [e setText:text];
    [e setCompleted:0];
    [e setCreated_at:[NSDate date]];
    [e setUpdated_at:[NSDate date]];
}

+(NSArray *)listElements{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Element"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"created_at" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *fetchedArray = [context executeFetchRequest:request error:&error];
    
    if (fetchedArray == nil) {
        NSLog(@"Error while fetching\n%@",
              ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        exit(1);
    }
    
    return fetchedArray;
}

+(void)updateElementWithTitle:(NSString*)oldTitle Title:(NSString *)title AndText:(NSString *)text{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Element" inManagedObjectContext:context]];
    NSError *error = nil;
    NSArray *fetchedArray = [context executeFetchRequest:request error:&error];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",oldTitle];
    [request setPredicate:predicate];

    Element* element = [fetchedArray objectAtIndex:0];
    element.title = title;
    element.text = text;
}

+(void)deleteElementWithTitle:(NSString*)Title{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Element" inManagedObjectContext:context]];
    NSError *error = nil;
    NSArray *fetchedArray = [context executeFetchRequest:request error:&error];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",Title];
    [request setPredicate:predicate];
    
    Element* element = [fetchedArray objectAtIndex:0];
    [context deleteObject:element];
}

@end
