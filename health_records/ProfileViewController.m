//
//  Name of the file:ProfileViewController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File allows you to add user's current medical record values like height, weight, etc.
//  Created by Dhivya Narayanan on 12/3/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import"ProfileViewController.h"
#import "ListViewController.h"
#import "PreviewController.h"

@interface ProfileViewController()

@end
@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad {
   
    self.navigationItem.hidesBackButton = YES;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; //[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    self.selectedDate = [NSDate date];
    NSString *dateString=[formatter stringFromDate:self.selectedDate];
    self.dateTxt.text = dateString;
    self.curCondArr = [[NSMutableArray alloc]init];
     self.curAllergyArr = [[NSMutableArray alloc]init];
     self.curMedArr = [[NSMutableArray alloc]init];
     self.curDevicesArr = [[NSMutableArray alloc]init];
     self.curImmArr = [[NSMutableArray alloc]init];
      [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"myhrrecords.db"];
}

//open the db
-(void)openDB{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
}



-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
     [textField resignFirstResponder];
    return YES;
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // note which segue chosen (need to know if more than one segue from current view controller)
    NSLog( @"Transition via segue: '%@'", segue.identifier);
    
    if([segue.identifier isEqualToString:@"tolists"]){
        ListViewController *ncv = segue.destinationViewController;
        ncv.itemUsername = self.itemUsername;
    }
    
    [super prepareForSegue:segue sender:sender];
    
}

//Store all the entered values into corresponding table in the database

- (IBAction)done:(id)sender {
    
    [self.view endEditing:YES];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; //[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:self.selectedDate];
    
    //Get values from the textfields
    self.itemCurWeight = self.weightTxt.text;
    self.itemCurHeight = self.heightTxt.text;
    self.itemCurBMI = self.bmiTxt.text;
    self.itemCurBloodSugar = self.sugarTxt.text;
    self.itemCurSystolic = self.systolicTxt.text;
    self.itemCurDiastolic = self.diastolicTxt.text;
    self.itemCurConditions = self.conditionsTxt.text;
    self.itemCurDevices = self.devicesTxt.text;
    self.itemCurAllergies = self.AllergiesTxt.text;
    self.itemCurProcedures = self.proceduresTxt.text;
    self.itemCurMedications = self.medicationsTxt.text;
    
    //insert values into the table
   [self insertCondition];
    [self insertAllergy];
    [self insertProcedure];
    [self insertDevice];
    [self insertWeight];
    [self insertHeight];
    [self insertBMI];
    [self insertBP];
    [self insertSugar];
    [self insertMedication];
    [self updateCurVal];
    
    
}

// updates the current record of the user
-(void)updateCurVal{
    
    if(self.weightTxt.text && self.weightTxt.text.length>0){
        self.itemCurWeight = self.weightTxt.text;
    }
    if(self.heightTxt.text && self.heightTxt.text.length>0){
        self.itemCurHeight = self.heightTxt.text;
    }
    if(self.bmiTxt.text && self.bmiTxt.text.length>0){
        self.itemCurBMI = self.bmiTxt.text;
    }
    if(self.sugarTxt.text && self.sugarTxt.text.length>0){
        self.itemCurBloodSugar= self.sugarTxt.text;
    }
    if(self.systolicTxt.text && self.systolicTxt.text.length>0){
        self.itemCurSystolic = self.systolicTxt.text;
    }
    if(self.diastolicTxt.text && self.diastolicTxt.text.length>0){
        self.itemCurDiastolic = self.diastolicTxt.text;
    }
    if(self.conditionsTxt.text && self.conditionsTxt.text.length>0){
        self.itemCurConditions = self.conditionsTxt.text;
        [self.curCondArr addObject:self.itemCurConditions];
    }
    if(self.AllergiesTxt.text && self.AllergiesTxt.text.length>0){
        self.itemCurAllergies = self.AllergiesTxt.text;
        [self.curAllergyArr addObject:self.itemCurAllergies];
    }
    if(self.medicationsTxt.text && self.medicationsTxt.text.length>0){
        self.itemCurMedications = self.medicationsTxt.text;
        [self.curMedArr addObject:self.itemCurMedications];
    }
    
    if(self.proceduresTxt.text && self.proceduresTxt.text.length>0){
        self.itemCurProcedures = self.proceduresTxt.text;
    }
    if(self.devicesTxt.text && self.devicesTxt.text.length>0){
        self.itemCurDevices = self.devicesTxt.text;
        [self.curDevicesArr addObject:self.itemCurDevices];
    }
    if(self.immunizationTxt.text && self.immunizationTxt.text.length>0){
        self.itemCurImmunization = self.immunizationTxt.text;
        [self.curImmArr addObject:self.itemCurImmunization];
    }
}
- (IBAction)calendarBt:(id)sender {
    
}

//clear entries in all the textfields
- (IBAction)clear:(id)sender {
    self.weightTxt.text=@"";
    self.heightTxt.text=@"";
    self.bmiTxt.text=@"";
    self.sugarTxt.text=@"";
    self.systolicTxt.text=@"";
    self.diastolicTxt.text=@"";
    self.conditionsTxt.text=@"";
    self.AllergiesTxt.text=@"";
    self.medicationsTxt.text=@"";
    self.immunizationTxt.text=@"";
    self.proceduresTxt.text=@"";
    self.devicesTxt.text=@"";
    self.commentsWeightTxt.text=@"";
    self.commentsHeightTxt.text=@"";
    self.commentSugarTxt.text=@"";
    self.commentsBPTxt.text=@"";
    self.curCondArr = [[NSMutableArray alloc]init];
    self.curAllergyArr = [[NSMutableArray alloc]init];
    self.curMedArr = [[NSMutableArray alloc]init];
    self.curDevicesArr = [[NSMutableArray alloc]init];
    self.curImmArr = [[NSMutableArray alloc]init];
}

//insert condition into condition table
-(void)insertCondition{
  
    if (self.conditionsTxt.text && self.conditionsTxt.text.length > 0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd"];  //set the date format
        NSDate *theDate = [NSDate date];         //get the current date
         NSString *comments= @"";
        NSString * datestr = [dateFormat stringFromDate:theDate];
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO ConditionsTable (UserName,DateTime,Conditions,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,datestr,_itemCurConditions,comments];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
        
    }
}

//insert allergy values into AllergyTable
-(void)insertAllergy{
   
    if (self.AllergiesTxt.text && self.AllergiesTxt.text.length > 0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd"];  //sets the dateformat to display to the user
        NSDate *theDate = [NSDate date];       //Get the current date
        NSString *comments= @"";
        NSString * datestr = [dateFormat stringFromDate:theDate];
        
        //open the database to insert into tables
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            //Insert into table
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO AllergyTable (UserName,DateTime,Allergy,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,datestr,_itemCurAllergies,comments];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
        
    }

}

//insert Procedure values into ProceduresTable
-(void)insertProcedure{
   
    if (self.proceduresTxt.text && self.proceduresTxt.text.length > 0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd"];            //sets the date format to display
        NSDate *theDate = [NSDate date];             //get the current date
        NSString *comments= @"";
        NSString * datestr = [dateFormat stringFromDate:theDate];
        
        //open the database to insert the values into the table
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            //Insert values into table
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO ProceduresTable (UserName,DateTime,Procedures,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,datestr,_itemCurProcedures,comments];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
        
    }
    
}
//insert Devices values into DevicesTable

-(void)insertDevice{
   
    if (self.devicesTxt.text && self.devicesTxt.text.length > 0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *theDate = [NSDate date];                   //gets the current date
        NSString *comments= @"";
        NSString * datestr = [dateFormat stringFromDate:theDate];
        
        //open the database to insert values
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            //insert into values
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO DevicesTable (UserName,DateTime,Devices,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,datestr,_itemCurDevices,comments];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
        
    }
    
}

//insert weight values into WeightListTable
-(void)insertWeight{
    
    if (self.weightTxt.text && self.weightTxt.text.length > 0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *theDate = [NSDate date];                         //Get the current date
        NSString *comments= self.commentsWeightTxt.text;
        NSString * datestr = [dateFormat stringFromDate:theDate];
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            //Insert values into the table
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO WeightListTable (UserName,DateTime,Weight,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,datestr,_itemCurWeight,comments];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
        
     }
    
}

//insert  height values into HeightListTable
-(void)insertHeight{
    
    if (self.heightTxt.text && self.heightTxt.text.length > 0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *theDate = [NSDate date];              //Gets the current date
        NSString *comments= self.commentsHeightTxt.text;
        NSString * datestr = [dateFormat stringFromDate:theDate];
        
        //open the database
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            //Insert values into the table
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO HeightListTable (UserName,DateTime,Height,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,datestr,_itemCurHeight,comments];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
        
    }
    
}

//Insert BMI values into BMIListTable
-(void)insertBMI{
    
    if (self.bmiTxt.text && self.bmiTxt.text.length > 0)
    {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *theDate = [NSDate date];
        NSString *comments= @"";
        NSString * datestr = [dateFormat stringFromDate:theDate];
        //open the database
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            //Insert values into BMIListTable
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO BMIListTable (UserName,DateTime,Bmi,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,datestr,_itemCurBMI,comments];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
        
    }
    
}

//Insert Blood Sugar values into SugarListTable
-(void)insertSugar{
    
    //If the sugar value is entered, then insert value into the table
    if (self.sugarTxt.text && self.sugarTxt.text.length > 0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *theDate = [NSDate date];              //Gets the current date
        NSString *comments= self.commentSugarTxt.text;
        NSString * datestr = [dateFormat stringFromDate:theDate];
        //Open the database
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            //Insert values into table
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO SugarListTable (UserName,DateTime,Sugar,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,datestr,_itemCurBloodSugar,comments];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
        
    }
    
}

//Insert values into the Table
-(void)insertMedication{
    
    if (self.medicationsTxt.text && self.medicationsTxt.text.length > 0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *theDate = [NSDate date];
        NSString *comments= @"";
        NSString * datestr = [dateFormat stringFromDate:theDate];
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO MedicationsTable (UserName,DateTime,Medications,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,datestr,_itemCurMedications,comments];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }

    }

}
//Insert values into BP Table
-(void)insertBP{
    if ((self.systolicTxt.text && self.systolicTxt.text.length > 0) && (self.diastolicTxt.text && self.diastolicTxt.text.length > 0))
    { NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *theDate = [NSDate date];
        NSString *comments= self.commentsBPTxt.text;
        NSString * datestr = [dateFormat stringFromDate:theDate];
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO BPListTable (UserName,DateTime,Systolic,Diastolic,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,datestr,_itemCurSystolic,_itemCurDiastolic,comments];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
        
    }

}

//Add new values into conditions table
- (IBAction)addnewConditions:(id)sender {
    if(self.conditionsTxt.text && self.conditionsTxt.text.length>0){
        self.itemCurConditions = self.conditionsTxt.text;
        [self.curCondArr addObject:self.itemCurConditions];
        [self insertCondition];
    }
    self.conditionsTxt.text=@"";
}

//Add new values into allergy table
- (IBAction)addnewAllergy:(id)sender {
    if(self.AllergiesTxt.text && self.AllergiesTxt.text.length>0){
        self.itemCurAllergies = self.AllergiesTxt.text;
        [self.curAllergyArr addObject:self.itemCurAllergies];
        [self insertAllergy];
    }
    self.AllergiesTxt.text=@"";
}

//Add new values into medicationTable
- (IBAction)addnewMedication:(id)sender {
    if(self.medicationsTxt.text && self.medicationsTxt.text.length>0){
        self.itemCurMedications = self.medicationsTxt.text;
        [self.curMedArr addObject:self.itemCurMedications];
        [self insertMedication];
    }
self.medicationsTxt.text =@"";
}


- (IBAction)addnewProcedures:(id)sender {
}

//Add new values into procedures table
- (IBAction)addnewDevices:(id)sender {
    if(self.devicesTxt.text && self.devicesTxt.text.length>0){
        self.itemCurDevices = self.devicesTxt.text;
        [self.curDevicesArr addObject:self.itemCurDevices];
        [self insertDevice];
    }
    self.devicesTxt.text=@"";
}

@end
