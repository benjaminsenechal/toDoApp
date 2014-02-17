//
//  detailsTaskViewController.m
//  toDoApp
//
//  Created by Benjamin SENECHAL on 27/01/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "detailsTaskViewController.h"

@interface detailsTaskViewController ()
@end
Element* taskReceived;

@implementation detailsTaskViewController
@synthesize titleTextField, textTextView, scrollView, datePickerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:taskReceived.title];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTextField:)];
    [textTextView addGestureRecognizer:gestureRecognizer];
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 30, 320, 40)];
    textTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 80, 320, 130)];
    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 230, 320, 50)];
    [scrollView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [titleTextField setBackgroundColor:[UIColor whiteColor]];
    [datePickerView setBackgroundColor:[UIColor whiteColor]];
    [textTextView setBackgroundColor:[UIColor whiteColor]];
    titleTextField.layer.masksToBounds=YES;
    titleTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    titleTextField.layer.borderWidth= 0.5f;
    textTextView.layer.masksToBounds=YES;
    textTextView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    textTextView.layer.borderWidth= 0.5f;
    datePickerView.layer.masksToBounds=YES;
    datePickerView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    datePickerView.layer.borderWidth= 0.5f;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    titleTextField.leftView = paddingView;
    titleTextField.leftViewMode = UITextFieldViewModeAlways;
    
    textTextView.textAlignment = NSTextAlignmentJustified;
    [textTextView setUserInteractionEnabled:YES];
    [textTextView textContainerInset];
    textTextView.font = FONT(15);
    titleTextField.font = FONT(15);
    
    [titleTextField setUserInteractionEnabled:YES];
    [datePickerView addTarget:self action:@selector(touchPicker) forControlEvents:UIControlEventValueChanged];
    
    [titleTextField setText:taskReceived.title];
    textTextView.text = taskReceived.content;
    
    [datePickerView setDate:taskReceived.due_date];
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

+(void)myObject:(Element*)e{
    taskReceived = e;
}

- (IBAction)saveTask:(id)sender {
    if ([titleTextField.text length]>0 && [textTextView.text length]>0){
        [ManagedElement updateElementWithID:taskReceived.id_element Title:titleTextField.text Text:textTextView.text AndDueDate:datePickerView.date];
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = datePickerView.date;
        localNotification.alertBody = titleTextField.text;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];

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

- (IBAction)touchTextField:(id)sender {
    [textTextView becomeFirstResponder];
    [titleTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [textTextView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

@end
