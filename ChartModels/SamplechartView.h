//
//  SamplechartView.h
//  ChartModels
//
//  Created by Manickam on 18/07/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SamplechartView : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
