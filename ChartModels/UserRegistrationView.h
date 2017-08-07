//
//  UserRegistrationView.h
//  ChartModels
//
//  Created by Vignesh on 28/07/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator/TextFieldValidator.h"
@interface UserRegistrationView : UIViewController
@property (weak, nonatomic) IBOutlet TextFieldValidator *firstName;
@property (weak, nonatomic) IBOutlet TextFieldValidator *lastName;
@property (weak, nonatomic) IBOutlet TextFieldValidator *userName;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txt_Pwd;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txt_ConfirmPwd;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txt_state;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txt_Country;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txt_MobileNo;

@end
