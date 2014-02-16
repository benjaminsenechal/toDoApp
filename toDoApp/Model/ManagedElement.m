//
//  ManagedLesson.m
//  toDoApp
//
//  Created by Benjamin SENECHAL on 27/01/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "ManagedElement.h"

@implementation ManagedElement

+(void)addElementWithTitle:(NSString *)title Text:(NSString *)text AndDueDate:(NSDate*)date{
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
    e.due_date = date;
    e.updated_at = [NSDate date];
    
    NSError *error;
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }else{
        PFObject *element = [PFObject objectWithClassName:@"Element"];
        element[@"id_element"] = e.id_element;
        element[@"content"] = e.content;
        element[@"title"] = e.title;
        element[@"completed"] = e.completed;
        element[@"created_at"] = e.created_at;
        element[@"updated_at"] = e.updated_at;
        element[@"due_date"] = e.due_date;
        [element saveInBackground];
    }
}

+(void)addElementFromParseWithTitle:(NSString *)title Text:(NSString *)text AndDueDate:(NSDate*)date{
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
    e.due_date = date;
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

+(void)listElementsWithParse{
    PFQuery *query = [PFQuery queryWithClassName:@"Element"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved: %@", objects);
            for (int i=0; i<[objects count]; i++){
                PFObject *eReceived = [objects objectAtIndex:i];
                Element *element = [self findByID:eReceived[@"id_element"]];
                if (!element){
                    [self addElementFromParseWithTitle:eReceived[@"title"] Text:eReceived[@"text"] AndDueDate:eReceived[@"due_date"]];
                }
            }
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"notificationLoadDatasFinished" object:nil]];
}

+(void)updateElementWithID:(NSString*)uniqueID Title:(NSString *)title Text:(NSString *)text AndDueDate:(NSDate*)date{
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Element"];
    [query whereKey:@"id_element" equalTo:element.id_element];
    PFObject *elementReceived = [query getFirstObject];
    elementReceived[@"title"] = title;
    elementReceived[@"content"] = text;
    elementReceived[@"due_date"] = date;
    elementReceived[@"updated_at"] = [NSDate date];
    [elementReceived saveInBackground];
    
    element.title = title;
    element.content = text;
    element.due_date = date;
    element.updated_at = [NSDate date];
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+(Element*)findByID:(NSString*)uniqueID{
    Element *element;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Element" inManagedObjectContext:context]];
    NSError *error = nil;
    NSArray *fetchedArray = [context executeFetchRequest:request error:&error];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_element == %@",uniqueID];
    [request setPredicate:predicate];
    
    NSArray *filtered  = [fetchedArray filteredArrayUsingPredicate:predicate];
    if ([filtered count]> 0){
        element = [filtered objectAtIndex:0];
    }
    
    return element;
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
    Element *element = [filtered objectAtIndex:0];
    [context deleteObject:element];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Element"];
    [query whereKey:@"id_element" equalTo:element.id_element];
    PFObject *elementReceived = [query getFirstObject];
    [elementReceived deleteEventually];


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
    
    if([element.completed isEqualToNumber:[[NSNumber alloc] initWithBool:FALSE]]){
        element.completed = [[NSNumber alloc] initWithBool:TRUE];
        element.updated_at = [NSDate date];

        PFQuery *query = [PFQuery queryWithClassName:@"Element"];
        [query whereKey:@"id_element" equalTo:element.id_element];
        PFObject *elementReceived = [query getFirstObject];
        elementReceived[@"completed"] = @1;
        elementReceived[@"updated_at"] = [NSDate date];
        [elementReceived saveInBackground];
    }
    
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
}


@end
