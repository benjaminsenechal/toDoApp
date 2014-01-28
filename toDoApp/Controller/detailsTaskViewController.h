//
//  detailsTaskViewController.h
//  toDoApp
//
//  Created by Benjamin SENECHAL on 27/01/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailsTaskViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *textTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;
+(void)myObject:(Element*)e;
- (IBAction)saveTask:(id)sender;
- (IBAction)touchTextField:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

