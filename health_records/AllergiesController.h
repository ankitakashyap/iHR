//
//  Name of the file:AllergiesController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  displays allergies history of the user in the tableview and allows the option to restrict their view to 1 months history and 6 months history


//  Created by Dhivya Narayanan on 12/5/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#ifndef HealthRecords_AllergiesController_h
#define HealthRecords_AllergiesController_h


#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface AllergiesController : UIViewController{
    sqlite3* db;
}

//IBOutlet and IBActions
@property (weak, nonatomic) IBOutlet UITableView *tableViewTxt;

@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

- (IBAction)segmentchange:(id)sender;
@property (strong,nonatomic) NSString *itemUserName;

-(NSString *) filePath;  //database get stored at this path
-(void)openDB;
-(void)retrieveCondDetails;

//Class variables to store retrieved values
@property(strong,nonatomic)NSString* retUsername;
@property(strong,nonatomic)NSDate* retDateTime;
@property(strong,nonatomic)NSString* retConditions;
@property(strong,nonatomic)NSString* retComments;
@property(strong,nonatomic)NSDate* curDate;
@property(strong,nonatomic)NSDate* fromDate;

@end




#endif
