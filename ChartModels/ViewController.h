//
//  ViewController.h
//  ChartModels
//
//  Created by Vijayaamirtharaj on 16/02/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"
#import "SamplechartView.h"
#import <sqlite3.h>


@interface ViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TextFieldValidator *txtName;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtEmail;
- (IBAction)btn_SignIn:(id)sender;

@end

