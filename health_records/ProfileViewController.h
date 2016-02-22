//
//  Name of the file:ProfileViewController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File allows you to add user's current medical record values like height, weight, etc.
//  Created by Dhivya Narayanan on 12/3/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface ProfileViewController : UIViewController{
    sqlite3 *db;
}

//variables to store values from previous controller
@property (strong,nonatomic) NSString *itemFirstName;
@property (strong,nonatomic) NSString *itemLastName;
@property (strong,nonatomic) NSString *itemDob;
@property (strong,nonatomic) NSString *itemAge;
@property (strong,nonatomic) NSString *itemGender;
@property (strong,nonatomic) NSString *itemBloodGroup;
@property (strong,nonatomic) NSString *itemContactno;
@property (strong,nonatomic) NSString *itemEmail;
@property (strong,nonatomic) NSString *itemAddr;
@property (strong,nonatomic) NSString *itemCity;
@property (strong,nonatomic) NSString *itemState;
@property (strong,nonatomic) NSString *itemCountry;
@property (strong,nonatomic) NSString *itemZipcode;
@property(strong, nonatomic)NSString * itemUsername;
@property(strong,nonatomic)NSString* itemImagePath;
@property(strong,nonatomic)NSString* itemImgName;

//IBOutlet and IBAction for textfields and buttons
@property (weak, nonatomic) IBOutlet UITextField *weightTxt;
@property (weak, nonatomic) IBOutlet UITextField *heightTxt;
@property (weak, nonatomic) IBOutlet UITextField *bmiTxt;
@property (weak, nonatomic) IBOutlet UITextField *sugarTxt;
@property (weak, nonatomic) IBOutlet UITextField *systolicTxt;
@property (weak, nonatomic) IBOutlet UITextField *diastolicTxt;
@property (weak, nonatomic) IBOutlet UITextField *conditionsTxt;

@property (weak, nonatomic) IBOutlet UITextField *AllergiesTxt;
@property (weak, nonatomic) IBOutlet UITextField *medicationsTxt;
@property (weak, nonatomic) IBOutlet UITextField *immunizationTxt;
@property (weak, nonatomic) IBOutlet UITextField *proceduresTxt;
@property (weak, nonatomic) IBOutlet UITextField *devicesTxt;


- (IBAction)done:(id)sender;
- (IBAction)calendarBt:(id)sender;
- (IBAction)clear:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *dateTxt;
@property (weak, nonatomic) IBOutlet UITextField *commentsWeightTxt;
@property (weak, nonatomic) IBOutlet UITextField *commentsHeightTxt;
@property (weak, nonatomic) IBOutlet UITextField *commentSugarTxt;
@property (weak, nonatomic) IBOutlet UITextField *commentsBPTxt;

//Methods to insert values into the table
- (IBAction)addnewConditions:(id)sender;
- (IBAction)addnewAllergy:(id)sender;
- (IBAction)addnewMedication:(id)sender;

- (IBAction)addnewProcedures:(id)sender;
- (IBAction)addnewDevices:(id)sender;

//variables to store current medical reports entered by the user
@property (strong,nonatomic) NSString *itemCurWeight;
@property (strong,nonatomic) NSString *itemCurHeight;
@property (strong,nonatomic) NSString *itemCurBMI;
@property (strong,nonatomic) NSString *itemCurBloodSugar;
@property (strong,nonatomic) NSString *itemCurSystolic;
@property (strong,nonatomic) NSString *itemCurDiastolic;
@property(strong,nonatomic) NSMutableArray* curCondArr;
@property (strong,nonatomic) NSString *itemCurConditions;
@property(strong,nonatomic) NSMutableArray* curAllergyArr;
@property (strong,nonatomic) NSString *itemCurAllergies;
@property(strong,nonatomic) NSMutableArray* curMedArr;
@property (strong,nonatomic) NSString *itemCurMedications;
@property (strong,nonatomic) NSString *itemCurProcedures;
@property(strong,nonatomic) NSMutableArray* curDevicesArr;
@property (strong,nonatomic) NSString *itemCurDevices;
@property(strong,nonatomic) NSMutableArray* curImmArr;
@property (strong,nonatomic) NSString *itemCurImmunization;

@property (strong,nonatomic) NSDate *selectedDate;
@property(strong,nonatomic) NSString* selectedDateStr;


-(NSString *) filePath;  //database get stored at this path
-(void)openDB;

//Methods to insert values into corresponding table
-(void)insertCondition;
-(void)insertAllergy;
-(void)insertProcedure;
-(void)insertDevice;
-(void)insertWeight;
-(void)insertHeight;
-(void)insertBMI;
-(void)insertSugar;
-(void)insertBP;
-(void)insertMedication;
-(void)updateCurVal;   //update current status of the user



@end




