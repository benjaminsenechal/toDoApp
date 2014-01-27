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
@synthesize textTextView, titleTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)submitTask:(id)sender {
    if ([textTextView.text length]>0 && [titleTextField.text length]>0){
        [ManagedElement addElementWithTitle:titleTextField.text AndText:textTextView.text];
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
@end
