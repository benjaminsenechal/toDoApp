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
@synthesize titleLabel, textTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:taskReceived.title];
    [titleLabel setText:taskReceived.title];
    textTextView.text = taskReceived.content;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTextField:)];
    [textTextView addGestureRecognizer:gestureRecognizer];
}

+(void)myObject:(Element*)e{
    taskReceived = e;
}

- (IBAction)saveTask:(id)sender {
    if ([titleLabel.text length]>0 && [textTextView.text length]>0){
        [ManagedElement updateElementWithID:taskReceived.id_element Title:titleLabel.text AndText:textTextView.text];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        window.rootViewController = [storyboard instantiateInitialViewController];
    }else{
        if([titleLabel.text length] <= 0){
            titleLabel.placeholder = @"Field required";
        }
        if([textTextView.text length] <= 0){
            textTextView.text = @"Field required";
        }
    }
}

- (IBAction)touchTextField:(id)sender {
    [textTextView becomeFirstResponder];
    [titleLabel setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [textTextView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

@end
