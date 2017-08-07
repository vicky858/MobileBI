//
//  SamplechartView.m
//  ChartModels
//
//  Created by Manickam on 18/07/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import "SamplechartView.h"
#import "FSInteractiveMapView.h"
#import <MapKit/MapKit.h>
#import "AFNetworking.h"
#import "SQLiteManager.h"
#import "FMResultSet.h"
#import "PieChartViewController.h"
#import "CSVParser.h"
#import "ISColorWheel.h"
#import "ChartSingleten.h"
#import "FSSVG.h"



@interface SamplechartView () <UIScrollViewDelegate,getcurlocation,UITextFieldDelegate,UIPickerViewDelegate,ISColorWheelDelegate>
{
    CGRect touchpt;
    CGRect touchLbl;
    NSString *strLbl;
    UILabel *lblTouch;
    UIView *vewDynamic;
    FSInteractiveMapView *map3;
    FSSVG* svg;
    ISColorWheel* _colorWheel;
    UISlider* _brightnessSlider;
    UIView* _wellView;
    UIView* _TotalColorView;
    UIColor *DynColorChange;
}




@property (weak, nonatomic) IBOutlet UIButton *applyColor;

@property (nonatomic, weak) CAShapeLayer* oldClickedLayer;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollviw;
@property (weak, nonatomic) IBOutlet UIView *ColorPickViw;




@property(nonatomic,strong)NSArray *ArrReceiveCSV;
@end

@implementation SamplechartView
{
    
   //properties of maps
    __weak IBOutlet UIPickerView *StatePickerView;
    __weak IBOutlet UIPickerView *PopulationPicker;
    __weak IBOutlet UITextField *txtfild_State;
    __weak IBOutlet UITextField *Txtfild_Population;
    __weak IBOutlet UIImageView *slider_Value;
    
    NSMutableArray *xarray;
    NSMutableArray *yarray;
    NSMutableArray *warray;
    NSMutableArray *zarray;
    
    
    UIPickerView *pickrView;
    NSMutableArray *arrayNo;

}
#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.title = self.detailItem;
        self.detailLabel.text = @"";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayNo = [[NSMutableArray alloc] init];
    [arrayNo addObject:@"iOS"];
    [arrayNo addObject:@"Android"];
    [arrayNo addObject:@"Blackberry"];
    //csv file data stored array
    xarray=[[NSMutableArray alloc]init];
    yarray=[[NSMutableArray alloc]init];
    warray=[[NSMutableArray alloc]init];
    zarray=[[NSMutableArray alloc]init];

    
    _ArrReceiveCSV=[[NSArray alloc]init];
    txtfild_State.delegate=self;
    
    
    
    //Tab gesture controls
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollviw addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollviw addGestureRecognizer:twoFingerTapRecognizer];
    self.scrollviw.delegate=self;
    vewDynamic = [[UIView alloc] initWithFrame:self.scrollviw.bounds];
    vewDynamic.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollviw addSubview:vewDynamic];
    
    [self configureView];
    [self initExample3];
//    svg=[[FSSVG alloc]init];
    txtfild_State.textAlignment=NSTextAlignmentCenter;
    


}
- (void)viewDidAppear:(BOOL)animated
{
    
    
    
    //Get Staes name From Singlton class
    ChartSingleten *singleTon=[ChartSingleten sharedinstence];
    xarray=singleTon.states;
    NSLog(@"list of sts USA :%@",singleTon.states);
    [StatePickerView reloadAllComponents];
    self.scrollviw.contentMode = UIViewContentModeScaleAspectFit;
    self.scrollviw.contentSize = vewDynamic.frame.size;
    CGRect scrollViewFrame = self.scrollviw.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollviw.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollviw.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollviw.minimumZoomScale = 0.2;
     self.scrollviw.maximumZoomScale = 3.0f;
    self.scrollviw.zoomScale = minScale;
    
    [self centerScrollViewContents];
   
    lblTouch = [[UILabel alloc] initWithFrame:CGRectZero];
    lblTouch.backgroundColor = [UIColor clearColor];
    lblTouch.textAlignment=NSTextAlignmentCenter;
    lblTouch.adjustsFontSizeToFitWidth=YES;
    lblTouch.alpha=1.0;
    //    lblTouch.hidden = YES;
    [vewDynamic addSubview:lblTouch];

    
}
- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollviw.bounds.size;
    CGRect contentsFrame = vewDynamic.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    vewDynamic.frame = contentsFrame;
}


- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // 1
    CGPoint pointInView = [recognizer locationInView:vewDynamic];
    
    // 2
    CGFloat newZoomScale = self.scrollviw.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollviw.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.scrollviw.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.scrollviw zoomToRect:rectToZoomTo animated:YES];
}
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollviw.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollviw.minimumZoomScale);
    [self.scrollviw setZoomScale:newZoomScale animated:YES];
}

# pragma - mark Scroll View delegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return vewDynamic;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initExample3
{
    NSDictionary* data = @{@"asia" : @12,
                           @"australia" : @2,
                           @"north_america" : @5,
                           @"south_america" : @14,
                           @"africa" : @5,
                           @"europe" : @20
                           };
    
      map3 = [[FSInteractiveMapView alloc] initWithFrame:CGRectMake(250, 50, self.view.frame.size.width-130, self.view.frame.size.height-350)];
    
    [map3 loadMap:@"usaLow" withData:data colorAxis:@[[UIColor lightGrayColor], [UIColor darkGrayColor]]];
       map3.delegate=self;
    
    [map3 setClickHandler:^(NSString* identifier, CAShapeLayer* layer) {
        
        self.detailLabel.text = [NSString stringWithFormat:@"Clicked on: %@", identifier];
        
        
        if(_oldClickedLayer) {
            //            _oldClickedLayer=nil;
            _oldClickedLayer.zPosition = 0;
            _oldClickedLayer.shadowOpacity = 0;
        }
        
        _oldClickedLayer = layer;
        
        // We set a simple effect on the layer clicked to highlight it
        layer.zPosition = 10;
        layer.shadowOpacity = 0.5;
        layer.shadowColor = [UIColor blueColor].CGColor;
        layer.shadowRadius = 5;
        layer.shadowOffset = CGSizeMake(0, 0);
        layer.shadowOffset = CGSizeMake(0, 0);
        lblTouch.frame = touchLbl;
        lblTouch.text = strLbl;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:lblTouch.bounds];
        imgView.image=[UIImage imageNamed:@"Pinpoint.png"];
        imgView.contentMode= UIViewContentModeLeft;
        [lblTouch addSubview:imgView];
        [lblTouch sendSubviewToBack:imgView];

        [vewDynamic bringSubviewToFront:lblTouch];
        [imgView bringSubviewToFront:lblTouch];

    }];
    [vewDynamic addSubview:map3];
    svg=map3.svg;
    
}
-(void)getCurTouchponit:(CGPoint)pint
{
    NSLog(@"%f%f",pint.x,pint.y);
    touchpt=CGRectMake(pint.x+150, pint.y+50.0,0.0,0.0);
}
-(void)getPostionSates:(CGPoint)value title:(NSString *)str
{
    
    touchLbl=CGRectMake(value.x+150,value.y+50.0,150 ,30);
    strLbl=str;
    txtfild_State.text=str;
    
}



#pragma - Parse .CSV File methods
-(void)parseCsvfile
{
    //    NSLog(@"%@", self.array);
    NSString *file = [[NSBundle mainBundle] pathForResource:@"country-code-to-currency-code-mapping" ofType:@"csv"];
   self.ArrReceiveCSV= [CSVParser parseCSVIntoArrayOfArraysFromFile:file withSeparatedCharacterString:@"," quoteCharacterString:nil];
    NSLog(@" PARSE CHECK :%@",_ArrReceiveCSV);
//    self.ArrReceiveCSV = checkarr;

//    for (int i=0; i<_ArrReceiveCSV.count; i++) {
//        NSArray *ArrX=[_ArrReceiveCSV objectAtIndex:i];
//        if (ArrX.count>1) {
//            [xarray addObject:[ArrX objectAtIndex:0]];
//            [yarray addObject:[ArrX objectAtIndex:1]];
//            [warray addObject:[ArrX objectAtIndex:2]];
//            [zarray addObject:[ArrX objectAtIndex:3]];
//        }
//    }
//
//    NSLog(@"xxxx:%@",xarray);
//    NSLog(@"yyyuy:%@",yarray);
//    NSLog(@"wwww:%@",warray);
//    NSLog(@"zzzzz:%@",zarray);
//    
    
}
#pragma - mark Color Picker delegate

- (void)changeBrightness:(UISlider*)sender
{
    [_colorWheel setBrightness:_brightnessSlider.value];
    [_wellView setBackgroundColor:_colorWheel.currentColor];
}

- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    [_wellView setBackgroundColor:_colorWheel.currentColor];
    DynColorChange=_colorWheel.currentColor;
}

#pragma - IBAction Methods

- (IBAction)Btn_selectColor:(id)sender {
    
    if ([txtfild_State.text length ] >0) {
        vewDynamic.hidden=YES;
        _scrollviw.hidden=YES;
        _applyColor.hidden=NO;
        _TotalColorView=[[UIView alloc]initWithFrame:CGRectMake(234, 608, 294.0, 152.0)];
        [self.view bringSubviewToFront:_TotalColorView];
        _TotalColorView.backgroundColor = [UIColor lightGrayColor];
        _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(15.0,10.0,140.0,140.0)];
        _colorWheel.delegate = self;
        _colorWheel.continuous = YES;
        [self.view addSubview:_TotalColorView];
        [_TotalColorView addSubview:_colorWheel];
        [_TotalColorView bringSubviewToFront:_colorWheel];
        _brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(180,80,105.0,15.0)];
        _brightnessSlider.minimumValue = 0.0;
        _brightnessSlider.maximumValue = 1.0;
        _brightnessSlider.value = 1.0;
        _brightnessSlider.continuous = YES;
        [_brightnessSlider addTarget:self action:@selector(changeBrightness:) forControlEvents:UIControlEventValueChanged];
        [_TotalColorView addSubview:_brightnessSlider];
        [_TotalColorView bringSubviewToFront:_brightnessSlider];
        
        _wellView = [[UIView alloc] initWithFrame:CGRectMake(230.0,10.0,57.0,40.0)];
        
        _wellView.layer.borderColor = [UIColor blackColor].CGColor;
        _wellView.layer.borderWidth = 2.0;
        [_TotalColorView addSubview:_wellView];
        [_TotalColorView bringSubviewToFront:_wellView];
        [self.view bringSubviewToFront:_applyColor];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please Select State Name" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    }
- (IBAction)Btn_ApplyColor:(id)sender {
    ChartSingleten *singleton=[ChartSingleten sharedinstence];
    NSMutableArray *scaledPaths=[[NSMutableArray alloc]init];
    scaledPaths=singleton.Arr_ScaledPathSingleTon;
        for(int i=0;i<[scaledPaths count];i++) {
            FSSVGPathElement* element = svg.paths[i];
            if([map3.layer.sublayers[i] isKindOfClass:CAShapeLayer.class]) {
                CAShapeLayer* l = (CAShapeLayer*)map3.layer.sublayers[i];
                NSString *str=[NSString stringWithFormat:@"%@",element.title];
                if ([txtfild_State.text isEqualToString:str]) {
                    l.fillColor=[_colorWheel.currentColor CGColor];
                    element.dynamicColor=_colorWheel.currentColor ;
                }
            }
        }
    [_TotalColorView removeFromSuperview];
     _TotalColorView=nil;
     vewDynamic.hidden=NO;
     _scrollviw.hidden=NO;
     _applyColor.hidden=YES;
}


- (IBAction)Btn_SetRmvclr:(id)sender {
    ChartSingleten *singleton=[ChartSingleten sharedinstence];
    NSMutableArray *scaledPaths=[[NSMutableArray alloc]init];
    scaledPaths=singleton.Arr_ScaledPathSingleTon;
    if ([sender tag]==1) {
     for(int i=0;i<[scaledPaths count];i++) {
         FSSVGPathElement* element = svg.paths[i];
           if([map3.layer.sublayers[i] isKindOfClass:CAShapeLayer.class]) {
            CAShapeLayer* l = (CAShapeLayer*)map3.layer.sublayers[i];
               NSString *str=[NSString stringWithFormat:@"%@",element.title];
            if ([txtfild_State.text isEqualToString:str]) {
                if (element.dynamicColor) {
                    l.fillColor=element.dynamicColor.CGColor;
                }
                else{
                l.fillColor=[[UIColor blueColor] CGColor];
                    l.fillColor=[_colorWheel.currentColor CGColor];
                    element.dynamicColor=_colorWheel.currentColor ;
                }
            }
        }
    }
  }
    else if ([sender tag]==2){
    for(int i=0;i<[scaledPaths count];i++) {
        FSSVGPathElement* element = svg.paths[i];
        if([map3.layer.sublayers[i] isKindOfClass:CAShapeLayer.class] && element.fill) {
            CAShapeLayer* l = (CAShapeLayer*)map3.layer.sublayers[i];
            NSString *str=[NSString stringWithFormat:@"%@",element.title];
            if ([txtfild_State.text isEqualToString:str]) {
                l.fillColor=[[UIColor colorWithRed:0.0/255.0 green:187.0/255.0 blue:167.0/255.0 alpha:1.0]CGColor];
                element.dynamicColor=nil;
            }
        }
    }
  }
    
}


- (IBAction)btnBack_Tapped:(id)sender
{
    NSLog(@"back button fired");
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Logout"
                                 message:@"Are You Sure Want to Logout!"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
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
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    

}
#pragma - mark TextFiled Delegate
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textView
{
    if ([txtfild_State tag]==1) {
   
        StatePickerView.hidden=NO;
    }
    return nil;
    
}
#pragma Picker View Delegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView==StatePickerView)
    {
          return [xarray count];
    }
    return 0;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    txtfild_State.text=[xarray objectAtIndex:row];
  }
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [xarray objectAtIndex:row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 100;
    return sectionWidth;
}


@end
