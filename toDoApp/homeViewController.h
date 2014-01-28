//
//  homeViewController.h
//  toDoApp
//
//  Created by Benjamin SENECHAL on 27/01/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailsTaskViewController.h"
@interface homeViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSMutableArray* elements;
@property (nonatomic) NSInteger count;

@end
