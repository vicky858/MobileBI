 //
//  ForgetPasswordView.m
//  ChartModels
//
//  Created by Vignesh on 27/07/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import "ForgetPasswordView.h"
#import "SQLiteManager.h"
#import "UpdatePasswordView.h"


@interface ForgetPasswordView ()

@end

@implementation ForgetPasswordView{
    
    __weak IBOutlet UITextField *_userName;
    __weak IBOutlet UILabel *lblstatus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btn_ForgetPwd:(id)sender {
   
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)btn_Continue:(id)sender {
    
    [_userName resignFirstResponder];
   
    lblstatus.text = @"";
    
    
    if ([_userName.text length] <= 0 ) {
        
        lblstatus.text =@"Username is invalid.";
    }else{
        //// check user name passward in local DB
        
        _userName.text= [_userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *strQuery =[NSString stringWithFormat:@"select *FROM UserValidation where username == '%@'", _userName.text];
        SQLiteManager *objSQL= [[SQLiteManager alloc]init];
        FMResultSet *objResults = [objSQL ExecuteQuery:strQuery];
        NSString *strpass = @"";
        if ([objResults next]) {
            strpass = [objResults stringForColumn:@"username"];
        }
        if ([strpass isEqualToString:_userName.text]) {
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UpdatePasswordView *controler=[storyboard instantiateViewControllerWithIdentifier:@"UserID"];
            [self presentViewController:controler animated:YES completion:nil];
            
            
            NSLog(@"username is correct");
            _userName.text = @"";
            
            
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Incorrect UserName" message:@"UserName Dosen't Match" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
            NSLog(@"incorrect UserID");
        }
    }

}

@end
