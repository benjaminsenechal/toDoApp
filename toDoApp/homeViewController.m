//
//  homeViewController.m
//  toDoApp
//
//  Created by Benjamin SENECHAL on 27/01/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "homeViewController.h"

@interface homeViewController ()
@end

@implementation homeViewController
@synthesize managedObjectContext, elements, count;

-(void)viewDidAppear:(BOOL)animated{
    [self finishedLoad];
}

-(void)finishedLoad{
    elements = [[NSMutableArray alloc] initWithArray:[ManagedElement listElements]];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationLoadDatasFinished" object:nil];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedLoad) name:@"notificationLoadDatasFinished" object:nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.2;
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];

    if (indexPath != nil){
    Element *e = [elements objectAtIndex:indexPath.row];
        if([e.completed isEqualToNumber:[[NSNumber alloc] initWithBool:FALSE]]){
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            [ManagedElement setCompletedWithID:e.id_element];
            [self.tableView reloadData];
        }
    }
}

- (void)dropViewDidBeginRefreshing:(UIRefreshControl *)refreshControl
{
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self finishedLoad];
        [refreshControl endRefreshing];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    count = [elements count];
    
	if (count == 0)
		count = 1;
	
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ElementCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    if ([elements count] > 0) {
        Element *e = [elements objectAtIndex:indexPath.row];
        if([e.completed isEqualToNumber:[[NSNumber alloc] initWithBool:TRUE]]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text = e.title;
        NSString *d= [dateFormatter stringFromDate:e.created_at];
        cell.detailTextLabel.text = d;
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Element* taskSelected = [elements objectAtIndex:indexPath.row];
    [detailsTaskViewController myObject:taskSelected];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Element *e = [elements objectAtIndex:indexPath.row];
        [ManagedElement deleteElementWithID:e.id_element];
        [self.elements removeObjectAtIndex:indexPath.row];
        [self finishedLoad];
    }
}

 // Override to support conditional editing of the table view.
/* - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

// Override to support rearranging the table view.
/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
