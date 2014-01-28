//
//  detailsTaskViewController.h
//  toDoApp
//
//  Created by Benjamin SENECHAL on 27/01/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailsTaskViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *textTextView;
+(void)myObject:(Element*)e;
- (IBAction)saveTask:(id)sender;
- (IBAction)touchTextField:(id)sender;

@end

