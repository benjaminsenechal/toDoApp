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
    e.id_element = [NSString stringWithFormat:@"%@",e.objectID];
    e.title = title;
    e.content = text;
    e.completed = [[NSNumber alloc] initWithBool:FALSE];
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
                                        initWithKey:@"updated_at" ascending:NO];
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

+(void)updateElementWithID:(NSString*)uniqueID Title:(NSString *)title AndText:(NSString *)text{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Element" inManagedObjectContext:context]];
    NSError *error = nil;
    NSArray *fetchedArray = [context executeFetchRequest:request error:&error];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_element == %@",uniqueID];
    [request setPredicate:predicate];
    
    NSArray *filtered  = [fetchedArray filteredArrayUsingPredicate:predicate];
    
    Element *element = [filtered objectAtIndex:0];
    element.title = title;
    element.content = text;
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+(void)deleteElementWithID:(NSString*)uniqueID{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Element" inManagedObjectContext:context]];
    NSError *error = nil;
    NSArray *fetchedArray = [context executeFetchRequest:request error:&error];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_element == %@",uniqueID];
    [request setPredicate:predicate];
    
    NSArray *filtered  = [fetchedArray filteredArrayUsingPredicate:predicate];
    Element* element = [filtered objectAtIndex:0];
    [context deleteObject:element];

    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
}

+(void)setCompletedWithID:(NSString*)uniqueID{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Element" inManagedObjectContext:context]];
    NSError *error = nil;
    NSArray *fetchedArray = [context executeFetchRequest:request error:&error];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_element == %@",uniqueID];
    [request setPredicate:predicate];
    
    NSArray *filtered  = [fetchedArray filteredArrayUsingPredicate:predicate];
    Element* element = [filtered objectAtIndex:0];
    
    if([element.completed isEqualToNumber:[[NSNumber alloc] initWithBool:FALSE]])
        element.completed = [[NSNumber alloc] initWithBool:TRUE];
    else if ([element.completed isEqualToNumber:[[NSNumber alloc] initWithBool:TRUE]])
        element.completed = [[NSNumber alloc] initWithBool:FALSE];
    
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
}


@end
