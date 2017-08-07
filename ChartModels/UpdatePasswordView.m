//
//  UpdatePasswordView.m
//  ChartModels
//
//  Created by Vignesh on 01/08/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import "UpdatePasswordView.h"
#import "TextFieldValidator/TextFieldValidator.h"
#import "SQLiteManager.h"

#define REGEX_USER_NAME_LIMIT @"^.{3,40}$"
#define REGEX_USER_NAME @"[A-Za-z0-40]{3,40}"
#define REGEX_EMAIL @"[A-Z0-9a-z]+([._%+-]{1}[A-Z0-9a-z]+)*@[A-Z0-9a-z]+([.-]{1}[A-Z0-9a-z]+)*(\\.[A-Za-z]{2,4}){0,1}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"


@interface UpdatePasswordView ()

@end

@implementation UpdatePasswordView{
    
    __weak IBOutlet TextFieldValidator *_txtPwd;
    __weak IBOutlet TextFieldValidator *_txtConfirmPwd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAlerts];
    _txtPwd.secureTextEntry = YES;
    _txtConfirmPwd.secureTextEntry=YES;
    _txtPwd.presentInView=self.view;
    _txtConfirmPwd.presentInView=self.view;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupAlerts{
    
    [_txtPwd addRegx:REGEX_PASSWORD_LIMIT withMsg:@"Password characters limit should be come between 6-20"];
    [_txtPwd addRegx:REGEX_PASSWORD withMsg:@"Password must contain alpha numeric characters."];
    
    [_txtConfirmPwd addRegx:REGEX_PASSWORD_LIMIT withMsg:@"Password characters limit should be come between 6-20"];
    [_txtConfirmPwd addRegx:REGEX_PASSWORD withMsg:@"Password must contain alpha numeric characters."];
    [_txtConfirmPwd addConfirmValidationTo:_txtPwd withMsg:@"Password mismatch"];
}


- (IBAction)btn_Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)btn_Update:(id)sender {
    
    if([_txtPwd validate] & [_txtConfirmPwd validate]){
        
        if ([_txtPwd.text isEqualToString:_txtConfirmPwd.text]) {
            
            SQLiteManager *sqlMng=[[SQLiteManager alloc]init];
            NSString *strQry = @"update UserValidation set password=?,confirmpwd=?";
            NSMutableArray *userArray = [[NSMutableArray alloc]init];
            
            [userArray addObject:_txtPwd.text];
            [userArray addObject:_txtConfirmPwd.text];
            
            
            //[sqlMng ExecuteInsertQuery:strQuery withCollectionOfValues:userArray];
           
        BOOL isSuss = [sqlMng ExecuteInsertQuery:strQry withCollectionOfValues:userArray];
            
            if (isSuss) {
                
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Success"
                                             message:@"Your Password has Changed Successfully!!!"
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
            
            _txtPwd.presentInView=self.view;
            _txtConfirmPwd.presentInView=self.view;
            
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
