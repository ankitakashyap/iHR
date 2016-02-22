//
//  Name of the file:AllergiesController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  displays allergies history of the user in the tableview and allows the option to restrict their view to 1 months history and 6 months history

//
//  Created by Dhivya Narayanan on 12/5/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllergiesController.h"
#import "AuthViewController.h"

@interface AllergiesController()

@property(nonatomic)NSMutableArray *conditions;
@property(nonatomic)NSMutableArray *condDisplay;
@property(nonatomic)NSInteger curdate;
@property(nonatomic)NSInteger curmonth;
@property(nonatomic)NSInteger curyear;


@end

@implementation AllergiesController
@synthesize segment, labelText;

- (void)viewDidLoad
{
    
    self.labelText.numberOfLines = self.conditions.count;
    self.conditions = [[NSMutableArray alloc]init];
    self.condDisplay = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    [self retrieveCondDetails];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = logoutButton;
     [self.navigationController setToolbarHidden:YES animated:YES];
    NSString* str = @"";
    for(int i=0; i< self.conditions.count;i++){
        [self.condDisplay addObject:self.conditions[i][1]];
        NSLog(@"conditions[i][1] : %@",self.conditions[i][1]);
        str =  [str stringByAppendingString:self.conditions[i][1]];
        str = [str stringByAppendingString:@"\n"];
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)logout:(id)sender{
   
    AuthViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
      [self.navigationController pushViewController:avc animated:YES];
    
    
}

//file path to db
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




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.condDisplay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; // reuse identifier
    
    
    // check if we can reuse a cell from row that just went off screen
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // create new cell, if needed
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // set text attibute of cell
    cell.textLabel.text = [self.condDisplay objectAtIndex:indexPath.row];
    
    // set accessory type to standard detail disclosure indicator
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


//Method to retrieve allergy values from the table
-(void)retrieveCondDetails{
    
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from AllergyTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* tdate =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.retConditions =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                NSString* tcomments =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                
                
                if([self.retUsername isEqualToString:self.itemUserName]){
                    NSMutableArray *dateCond = [NSMutableArray arrayWithObjects:tdate,self.retConditions,tcomments, nil];
                    [self.conditions addObject:dateCond];
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }

    // [self createTableCond:@"ConditionsList" withField1:@"UserName" withField2:@"DateTime" withField3:@"Conditions" withField4:@"Comments"];
   /* [self openDB];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM AllergiesList "];
    sqlite3_stmt *statement;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        while(sqlite3_step(statement)==SQLITE_ROW){
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc]initWithUTF8String:field1];
            self.retUsername = field1Str;
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc]initWithUTF8String:field2];
            //self.retDateTime = [dateFormat dateFromString:field2Str];
            //self.retDateTime =[dateFormat dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc]initWithUTF8String:field3];
            self.retConditions = field3Str;
            char *field4 = (char *) sqlite3_column_text(statement,3);
            NSString *field4Str = [[NSString alloc]initWithUTF8String:field4];
            self.retComments = field4Str;
            
            
            //
            //NSDate *date = [dateFormatter dateFromString:dateTime]; //to retrieve date from string
            
            //NSLog(@"My Date was : %@", [formatter stringFromDate:myDate]);
            NSLog(@"Values retrieved- Conditionslist");
            NSLog(@"itemusername...before retrieve -conditions list..%@",self.itemUserName);
            if([self.retUsername isEqualToString:self.itemUserName]){
                //  NSDate *tdate = [formatter dateFromString:<#(NSString *)#>]
                // NSString *myDate = [formatter stringFromDate:];
                NSMutableArray *dateCond = [NSMutableArray arrayWithObjects:field2Str,self.retConditions, self.retComments,nil];
                [self.conditions addObject:dateCond];
            }
            
        }
    }*/
    
}

- (IBAction)segmentchange:(id)sender {

        
        //[_segment layoutIfNeeded];
        
        //called when segment changes
        if (self.segment.selectedSegmentIndex==0) {
            [self.condDisplay removeAllObjects];
            
            NSLog(@"At segment 0: ");
            NSString* str = @"";
            for(int i=0; i< self.conditions.count;i++){
                [self.condDisplay addObject:self.conditions[i][1]];
                NSLog(@"conditions[i][1] : %@",self.conditions[i][1]);
                str =  [str stringByAppendingString:self.conditions[i][1]];
                str = [str stringByAppendingString:@"\n"];
            }
            NSLog(@"conditions :: %@",str);
            //self.labelText.text = str;
            [self.tableViewTxt reloadData];
            
        }
        else if(self.segment.selectedSegmentIndex==1) {
            
            NSLog(@"At segment 1: ");   //past 1 month
            [self.condDisplay removeAllObjects];
            
            self.curDate = [NSDate date];
            // NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            NSDateFormatter *monthFormatter=[[NSDateFormatter alloc] init];
            NSDateFormatter *dayFormatter=[[NSDateFormatter alloc] init];
            NSDateFormatter *yearFormatter=[[NSDateFormatter alloc] init];
            
            //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
           // NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //NSLog(@"%@",[dateFormatter stringFromDate:self.curDate]);
            [monthFormatter setDateFormat:@"MM"];
            // self.curmonth =[monthFormatter stringFromDate:self.curDate].integerValue;
            //NSInteger prevmonth = self.curmonth-1;
            //NSLog(@"%ld",(long)prevmonth);  //12
            [dayFormatter setDateFormat:@"dd"];
            //self.curdate =[dayFormatter stringFromDate:self.curDate].integerValue;
            //NSInteger prevday = self.curdate-1;
            //NSLog(@"%ld",(long)prevday); //05
            [yearFormatter setDateFormat:@"yyyy"];
            //self.curyear =[yearFormatter stringFromDate:self.curDate].integerValue;
            //NSInteger prevyear = self.curyear-1;
            //NSLog(@"%ld",(long)prevyear); //2015
            NSString* str=@"";
            NSDate* date = [NSDate date];
            
            NSDateComponents* comps = [[NSDateComponents alloc]init];
            comps.month = -1;
            
            NSCalendar* calendar = [NSCalendar currentCalendar];
            
            NSDate* prev_month = [calendar dateByAddingComponents:comps toDate:date options:0];
            
            for(int i=0; i< self.conditions.count;i++){
                
                NSDate *fdate = [dateFormat dateFromString:self.conditions[i][0]];
                // NSDate *fdate = self.conditions[i][0];
                NSComparisonResult result;
                //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
                
                result = [fdate compare:prev_month]; // comparing two dates
                
                if(result==NSOrderedAscending)
                    NSLog(@"falls more than 1 month");
                else if(result==NSOrderedDescending){
                    [self.condDisplay addObject:self.conditions[i][1]];
                    str =  [str stringByAppendingString:self.conditions[i][1]];
                    str = [str stringByAppendingString:@"\n"];
                    NSLog(@"falls within 1month");
                }
                
                else{
                    [self.condDisplay addObject:self.conditions[i][1]];
                    str =  [str stringByAppendingString:self.conditions[i][1]];
                    str = [str stringByAppendingString:@"\n"];
                    NSLog(@"same day");
                }
                
                
                //NSInteger mon = [monthFormatter stringFromDate:fdate].integerValue;
                //NSInteger day = [dayFormatter stringFromDate:fdate].integerValue;
                //NSInteger yr = [dayFormatter stringFromDate:fdate].integerValue;
                
                /* if(mon != 01){
                 if((mon == prevmonth && day >=self.curdate && yr == self.curyear) || (mon == self.curmonth && day <= self.curdate && yr == self.curyear)){
                 [self.condDisplay addObject:self.conditions[i][1]];
                 str =  [str stringByAppendingString:self.conditions[i][1]];
                 str = [str stringByAppendingString:@"\n"];
                 }
                 }
                 else {
                 if((mon == 12 && day >=self.curdate && yr == prevyear) || (mon == self.curmonth && day <= self.curdate && yr == self.curyear)){
                 [self.condDisplay addObject:self.conditions[i][1]];
                 str =  [str stringByAppendingString:self.conditions[i][1]];
                 str = [str stringByAppendingString:@"\n"];
                 }
                 }*/
                
            }
            // self.labelText.text = str;
            NSLog(@"1month...%@",str);
            [self.tableViewTxt reloadData];
            
        }
        else {
            
            NSLog(@"At segment 2: ");  //past 6 months
            [self.condDisplay removeAllObjects];
            
            self.curDate = [NSDate date];
            // NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            NSDateFormatter *monthFormatter=[[NSDateFormatter alloc] init];
            NSDateFormatter *dayFormatter=[[NSDateFormatter alloc] init];
            NSDateFormatter *yearFormatter=[[NSDateFormatter alloc] init];
            
            //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            //  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //NSLog(@"%@",[dateFormatter stringFromDate:self.curDate]);
            [monthFormatter setDateFormat:@"MM"];
            // self.curmonth =[monthFormatter stringFromDate:self.curDate].integerValue;
            //NSInteger prevmonth = self.curmonth-1;
            //NSLog(@"%ld",(long)prevmonth);  //12
            [dayFormatter setDateFormat:@"dd"];
            //self.curdate =[dayFormatter stringFromDate:self.curDate].integerValue;
            //NSInteger prevday = self.curdate-1;
            //NSLog(@"%ld",(long)prevday); //05
            [yearFormatter setDateFormat:@"yyyy"];
            //self.curyear =[yearFormatter stringFromDate:self.curDate].integerValue;
            //NSInteger prevyear = self.curyear-1;
            //NSLog(@"%ld",(long)prevyear); //2015
            NSString* str=@"";
            NSDate* date = [NSDate date];
            
            NSDateComponents* comps = [[NSDateComponents alloc]init];
            comps.month = -6;
            
            NSCalendar* calendar = [NSCalendar currentCalendar];
            
            NSDate* six_month_back= [calendar dateByAddingComponents:comps toDate:date options:0];
            
            for(int i=0; i< self.conditions.count;i++){
                
                NSDate *fdate = [dateFormat dateFromString:self.conditions[i][0]];
                // NSDate *fdate = self.conditions[i][0];
                NSComparisonResult result;
                //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
                
                result = [fdate compare:six_month_back]; // comparing two dates
                
                if(result==NSOrderedAscending)
                    NSLog(@"falls more than 6 month");
                else if(result==NSOrderedDescending){
                    [self.condDisplay addObject:self.conditions[i][1]];
                    str =  [str stringByAppendingString:self.conditions[i][1]];
                    str = [str stringByAppendingString:@"\n"];
                    NSLog(@"falls within 6month");
                }
                
                else{
                    [self.condDisplay addObject:self.conditions[i][1]];
                    str =  [str stringByAppendingString:self.conditions[i][1]];
                    str = [str stringByAppendingString:@"\n"];
                    NSLog(@"same day");
                }
                
                
                //NSInteger mon = [monthFormatter stringFromDate:fdate].integerValue;
                //NSInteger day = [dayFormatter stringFromDate:fdate].integerValue;
                //NSInteger yr = [dayFormatter stringFromDate:fdate].integerValue;
                
                /* if(mon != 01){
                 if((mon == prevmonth && day >=self.curdate && yr == self.curyear) || (mon == self.curmonth && day <= self.curdate && yr == self.curyear)){
                 [self.condDisplay addObject:self.conditions[i][1]];
                 str =  [str stringByAppendingString:self.conditions[i][1]];
                 str = [str stringByAppendingString:@"\n"];
                 }
                 }
                 else {
                 if((mon == 12 && day >=self.curdate && yr == prevyear) || (mon == self.curmonth && day <= self.curdate && yr == self.curyear)){
                 [self.condDisplay addObject:self.conditions[i][1]];
                 str =  [str stringByAppendingString:self.conditions[i][1]];
                 str = [str stringByAppendingString:@"\n"];
                 }
                 }*/
                
            }
            // self.labelText.text = str;
            NSLog(@"6month...%@",str);
            [self.tableViewTxt reloadData];
            
        }
        
    }
@end