//
//  Name of the file:MedicationsController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  displays medications history of the user in the tableview and allows the option to restrict their view to 1 months history and 6 months history//  Created by Dhivya Narayanan on 12/5/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#ifndef HealthRecords_MedicationsController_h
#define HealthRecords_MedicationsController_h

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface MedicationsController : UIViewController{
    sqlite3 *db;
}


@property (strong,nonatomic) NSString *itemUserName;

-(NSString *) filePath;  //database get stored at this path
-(void)openDB;
-(void)retrieveCondDetails;

//class variables to store retrieve values
@property(strong,nonatomic)NSString* retUsername;
@property(strong,nonatomic)NSDate* retDateTime;
@property(strong,nonatomic)NSString* retConditions;
@property(strong,nonatomic)NSString* retComments;
@property(strong,nonatomic)NSDate* curDate;
@property(strong,nonatomic)NSDate* fromDate;

//IBOutlet and IBActions
@property (weak, nonatomic) IBOutlet UITextField *fromdateTxt;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentchange;

@property (weak, nonatomic) IBOutlet UITableView *tableViewTxt;


@end


#endif
