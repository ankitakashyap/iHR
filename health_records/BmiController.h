//
//  Name of the file:BmiController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  displays BMI history of the user in the tableview and allows the option to restrict their view to 1 months history and 6 months history



//  Created by Dhivya Narayanan on 12/9/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#ifndef HealthRecords_BmiController_h
#define HealthRecords_BmiController_h

#import <UIKit/UIKit.h>
#import "sqlite3.h"


@interface BmiController : UIViewController{
    sqlite3* db;
}

//IBOutlet and IBAction for tableview, label and segmentcontrol in the view
@property (weak, nonatomic) IBOutlet UITableView *tableViewTxt;

@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

- (IBAction)segmentchange:(id)sender;
@property (strong,nonatomic) NSString *itemUserName;

-(NSString *) filePath;  //database get stored at this path
-(void)openDB;
-(void)retrieveDetails;

//class variables to store retrieved values
@property(strong,nonatomic)NSString* retUsername;
@property(strong,nonatomic)NSDate* retDateTime;
@property(strong,nonatomic)NSString* retBmi;
@property(strong,nonatomic)NSString* retComments;
@property(strong,nonatomic)NSDate* curDate;
@property(strong,nonatomic)NSDate* fromDate;


@end



#endif
