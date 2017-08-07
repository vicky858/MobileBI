//
//  ViewController.m
//  ChartModels
//
//  Created by Vijayaamirtharaj on 16/02/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import "ViewController.h"
#import "XlsxReaderWriter-swift-bridge.h"
#import "CSVParser.h"
#import "TextFieldValidator.h"
#import "SamplechartView.h"
#import "SQLiteManager.h"
#import "FMDatabase.h"


#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z]+([._%+-]{1}[A-Z0-9a-z]+)*@[A-Z0-9a-z]+([.-]{1}[A-Z0-9a-z]+)*(\\.[A-Za-z]{2,4}){0,1}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"


@interface ViewController ()
@property(nonatomic,strong)NSArray *ArrReceiveCSV;
@end

@implementation ViewController
{
       NSMutableArray *xarray;
    NSMutableArray *yarray;
    TextFieldValidator *txtDemo;
    __weak IBOutlet UIView *viewContainer;
    sqlite3 *adddata;
    NSString *databasePath;
    __weak IBOutlet UILabel *lblStatus;
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAlerts];
    txtDemo=[[TextFieldValidator alloc] initWithFrame:CGRectMake(20, 200, 280, 30)];
    _txtName.borderStyle=UITextBorderStyleRoundedRect;
    _txtEmail.borderStyle=UITextBorderStyleRoundedRect;
    txtDemo.delegate=self;
    _txtEmail.presentInView=self.view;
    _txtName.presentInView=self.view;
    [viewContainer addSubview:txtDemo];
    //[txtDemo addRegx:REGEX_EMAIL withMsg:@"Enter valid email."];

    _ArrReceiveCSV=[[NSArray alloc]init];
    xarray=[[NSMutableArray alloc]init];
    yarray=[[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view, typically from a nib.
//    [self xlsfilereader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)xlsfilereader
{
    NSString *documentPath = [[NSBundle mainBundle] pathForResource:@"CARD" ofType:@"xlsx"];
    BRAOfficeDocumentPackage *spreadsheet = [BRAOfficeDocumentPackage open:documentPath];
    
    //Save
//    [spreadsheet save];
    
    //Save a copy
//    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"workbookCopy.xlsx"];
//    [spreadsheet saveAs:fullPath];
    
    //First worksheet in the workbook
    BRAWorksheet *firstWorksheet = spreadsheet.workbook.worksheets[0];
    
    //Worksheet named "Foo"
//    BRAWorksheet *fooWorksheet = [spreadsheet.workbook createWorksheetNamed:@"Foo"];
    NSString *formula = [[firstWorksheet cellForCellReference:@"D4"] formulaString];
    NSString *string = [[firstWorksheet cellForCellReference:@"D3"] stringValue];    
    NSAttributedString *attributedString = [[firstWorksheet cellForCellReference:@"B5"] attributedStringValue];
    NSLog(@"%@",formula);
     NSLog(@"%@",string);
     NSLog(@"%@",attributedString);
    NSMutableArray *Xxls=[[NSMutableArray alloc]init];
    NSMutableArray *Yxls=[[NSMutableArray alloc]init];
    for(int i=2; i<=32;i++) {
        NSString *valOne=[NSString stringWithFormat:@"G%d",i];
        NSString *valTwo=[NSString stringWithFormat:@"H%d",i];
        
      CGFloat XcellFloatValue = [[firstWorksheet cellForCellReference:valOne] floatValue];
      CGFloat YcellFloatValue = [[firstWorksheet cellForCellReference:valTwo] floatValue];
        [Xxls addObject:[NSString stringWithFormat:@"%f",XcellFloatValue]];
        [Yxls addObject:[NSString stringWithFormat:@"%f",YcellFloatValue]];
    }
    NSLog(@"%@",Xxls);
    NSLog(@"%@",Yxls);
//    [self parseCsvfile];

}


-(void)setupAlerts{
    [_txtName addRegx:REGEX_USER_NAME_LIMIT withMsg:@"User name charaters limit should be come between 3-10"];
    
    [_txtName addRegx:REGEX_USER_NAME withMsg:@"Only alpha numeric characters are allowed."];
    
    _txtName.validateOnResign=NO;
    
    
    [_txtEmail addRegx:REGEX_PASSWORD_LIMIT withMsg:@"Password characters limit should be come between 6-20"];
    [_txtEmail addRegx:REGEX_PASSWORD withMsg:@"Password must contain alpha numeric characters."];
}

- (IBAction)btn_SignIn:(id)sender
{
    
    [_txtName resignFirstResponder];
    [_txtEmail resignFirstResponder];
    lblStatus.text = @"";
    

    if ([_txtName.text length] <= 0 || [_txtEmail.text length] <= 0 ) {
       
        lblStatus.text =@"Username or password is Empty. Please enter it again.";
    }else{
        //// check user name passward in local DB
        
        _txtName.text= [_txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *strQuery =[NSString stringWithFormat:@"select *FROM UserValidation where username == '%@' and password == '%@'", _txtName.text,_txtEmail.text];
        SQLiteManager *objSQL= [[SQLiteManager alloc]init];
        FMResultSet *objResults = [objSQL ExecuteQuery:strQuery];
        NSString *strpass = @"";
        if ([objResults next]) {
            strpass = [objResults stringForColumn:@"password"];
        }
        if ([strpass isEqualToString:_txtEmail.text]) {
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SamplechartView *controler=[storyboard instantiateViewControllerWithIdentifier:@"PatientTableID"];
            [self presentViewController:controler animated:YES completion:nil];

            NSLog(@"password is correct");
            _txtName.text = @"";
            _txtEmail.text = @"";
            
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Incorrect UserName or Password" message:@"UserName & Password Dosen't Match" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];

            NSLog(@"incorrect password");
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(void)parseCsvfile
{
           //    NSLog(@"%@", self.array);
        NSString *file = [[NSBundle mainBundle] pathForResource:@"DrawChart" ofType:@"csv"];
        [CSVParser parseCSVIntoArrayOfArraysFromFile:file
                        withSeparatedCharacterString:@","
                                quoteCharacterString:nil
                                           withBlock:^(NSArray *array, NSError *error) {
                                               self.ArrReceiveCSV = array;
                                               for (int i=1; i<_ArrReceiveCSV.count; i++) {
                                                   NSArray *ArrX=[_ArrReceiveCSV objectAtIndex:i];
                                                   if (ArrX.count>1) {
                                                       [xarray addObject:[ArrX objectAtIndex:0]];
                                                       [yarray addObject:[ArrX objectAtIndex:1]];
                                                   }
                                               }
                                               NSLog(@"xxxx:%@",xarray);
                                               NSLog(@"yyyuy:%@",yarray);
                                               [xarray removeAllObjects];
                                               [yarray removeAllObjects];
                                               
                                               
                                               // NSLog(@"%@", self.ArrReceiveCSV);
                                           }];
        

}

@end
