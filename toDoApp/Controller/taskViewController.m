//
//  taskViewController.m
//  toDoApp
//
//  Created by Benjamin SENECHAL on 27/01/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "taskViewController.h"

@interface taskViewController ()
@end

@implementation taskViewController
@synthesize textTextView, titleTextField, scrollView, datePickerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 30, 320, 30)];
    textTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 80, 320, 100)];
    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 190, 320, 50)];
    [titleTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [textTextView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [textTextView setUserInteractionEnabled:YES];
    [textTextView textContainerInset];
    textTextView.font = FONT(15);
    titleTextField.font = FONT(15);

    [titleTextField setUserInteractionEnabled:YES];
    [datePickerView addTarget:self action:@selector(touchPicker) forControlEvents:UIControlEventValueChanged];

    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 500)];
    [scrollView addSubview:textTextView];
    [scrollView addSubview:titleTextField];
    [scrollView addSubview:datePickerView];
}

-(void)touchPicker{
    [titleTextField resignFirstResponder];
    [textTextView resignFirstResponder];
}

- (IBAction)submitTask:(id)sender {
    NSLog(@"%@", self.datePickerView.date);
    if ([textTextView.text length]>0 && [titleTextField.text length]>0){
        [ManagedElement addElementWithTitle:titleTextField.text Text:textTextView.text AndDueDate:datePickerView.date];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        window.rootViewController = [storyboard instantiateInitialViewController];
    }else{
        if([titleTextField.text length] <= 0){
            titleTextField.placeholder = @"Field required";
        }
        if([textTextView.text length] <= 0){
            textTextView.text = @"Field required";
        }
    }
}

- (IBAction)cancelTask:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = [storyboard instantiateInitialViewController];
}

@end
