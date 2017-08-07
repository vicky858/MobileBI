//
//  UserRegistrationView.m
//  ChartModels
//
//  Created by Vignesh on 28/07/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import "UserRegistrationView.h"
#import "SQLiteManager.h"
#import "FMResultSet.h"
#import "ViewController.h"

#define REGEX_USER_NAME_LIMIT @"^.{3,40}$"
#define REGEX_USER_NAME @"[A-Za-z0-40]{3,40}"
#define REGEX_EMAIL @"[A-Z0-9a-z]+([._%+-]{1}[A-Z0-9a-z]+)*@[A-Z0-9a-z]+([.-]{1}[A-Z0-9a-z]+)*(\\.[A-Za-z]{2,4}){0,1}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"

@interface UserRegistrationView ()

@end

@implementation UserRegistrationView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAlerts];
    _firstName.presentInView=self.view;
    _lastName.presentInView=self.view;
    _userName.presentInView=self.view;
    _txt_Pwd.presentInView=self.view;
    _txt_ConfirmPwd.presentInView=self.view;
    _txt_state.presentInView=self.view;
    _txt_Country.presentInView=self.view;
    _txt_MobileNo.presentInView=self.view;
    
    
    _firstName.borderStyle=UITextBorderStyleRoundedRect;
    _lastName.borderStyle=UITextBorderStyleRoundedRect;
    _userName.borderStyle=UITextBorderStyleRoundedRect;
    _txt_Pwd.borderStyle=UITextBorderStyleRoundedRect;
    _txt_ConfirmPwd.borderStyle=UITextBorderStyleRoundedRect;
    _txt_state.borderStyle=UITextBorderStyleRoundedRect;
    _txt_Country.borderStyle=UITextBorderStyleRoundedRect;
    _txt_MobileNo.borderStyle=UITextBorderStyleRoundedRect;
    
    
    _txt_Pwd.secureTextEntry=YES;
    _txt_ConfirmPwd.secureTextEntry=YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back_Btn:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupAlerts{
    [_firstName addRegx:REGEX_USER_NAME_LIMIT withMsg:@"User name charaters limit should be come between 3-40"];
    
    [_firstName addRegx:REGEX_USER_NAME withMsg:@"Only alpha numeric characters are allowed."];
    
    [_lastName addRegx:REGEX_USER_NAME_LIMIT withMsg:@"User name charaters limit should be come between 3-40"];
    
    [_lastName addRegx:REGEX_USER_NAME withMsg:@"Only alpha numeric characters are allowed."];
    
//    [_userName addRegx:REGEX_USER_NAME_LIMIT withMsg:@"User name charaters limit should be come between 3-40"];
//    
//    [_userName addRegx:REGEX_USER_NAME withMsg:@"Only alpha numeric characters are allowed."];
    
    _firstName.validateOnResign=NO;
    _lastName.validateOnResign=NO;
//    _userName.validateOnResign=NO;
    
    [_txt_Pwd addRegx:REGEX_PASSWORD_LIMIT withMsg:@"Password characters limit should be come between 6-20"];
    [_txt_Pwd addRegx:REGEX_PASSWORD withMsg:@"Password must contain alpha numeric characters."];
    
    [_txt_ConfirmPwd addRegx:REGEX_PASSWORD_LIMIT withMsg:@"Password characters limit should be come between 6-20"];
    [_txt_ConfirmPwd addRegx:REGEX_PASSWORD withMsg:@"Password must contain alpha numeric characters."];
    
    //[_txt_MobileNo addRegx:REGEX_PHONE_DEFAULT withMsg:@"Please Enter Valid Number"];
    [_txt_ConfirmPwd addConfirmValidationTo:_txt_Pwd withMsg:@"Password mismatch"];
}


- (IBAction)btn_SignUp:(id)sender {
    
    if([_firstName validate] & [_lastName validate] & [_userName validate] & [_txt_Pwd validate] & [_txt_ConfirmPwd validate] & [_txt_state validate] & [_txt_Country validate] & [_txt_MobileNo validate]){
        
        if ([_txt_Pwd.text isEqualToString:_txt_ConfirmPwd.text]) {
            
            SQLiteManager *sqlMng=[[SQLiteManager alloc]init];
            NSString *strQuery = @"insert into UserValidation(fname,lname,username,password,confirmpwd,state,country,mobileno) values (?,?,?,?,?,?,?,?)";
            NSMutableArray *userArray = [[NSMutableArray alloc]init];
            [userArray addObject:_firstName.text];
            [userArray addObject:_lastName.text];
            [userArray addObject:_userName.text];
            [userArray addObject:_txt_Pwd.text];
            [userArray addObject:_txt_ConfirmPwd.text];
            [userArray addObject:_txt_state.text];
            [userArray addObject:_txt_Country.text];
            [userArray addObject:_txt_MobileNo.text];
            
//            [sqlMng ExecuteInsertQuery:strQuery withCollectionOfValues:userArray];
            
             BOOL isSuss = [sqlMng ExecuteInsertQuery:strQuery withCollectionOfValues:userArray];
            
            if (isSuss) {
                
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Success"
                                             message:@"You have SignedUp Successfully!!!"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                //Add Buttons
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                //Handle your yes please button action here
                    [self dismissViewControllerAnimated:YES completion:nil];
                                            }];
                
                UIAlertAction* noButton = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                                               //Handle no, thanks button
                                           }];
                
                //Add your buttons to alert controller
                
                [alert addAction:yesButton];
//                [alert addAction:noButton];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                NSLog(@"success fully inserted");
            }else{
              NSLog(@"faild to insert");
             }
            
    }else{
            [self setupAlerts];
            _txt_Pwd.presentInView=self.view;
            _txt_ConfirmPwd.presentInView=self.view;
        
    }
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
