//
//  ManagedLesson.m
//  toDoApp
//
//  Created by Benjamin SENECHAL on 27/01/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "ManagedElement.h"

@implementation ManagedElement

+(void)addElementWithTitle:(NSString *)title AndText:(NSString *)text{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    Element *e = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Element"
                  inManagedObjectContext:context];
    e.title = title;
    e.text = title;
    e.completed = 0;
    e.created_at = [NSDate date];
    e.updated_at = [NSDate date];
    NSError *error;
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+(NSArray *)listElements{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Element"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"created_at" ascending:NO];
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
