
//
//  Name of the file:ConditionsController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  displays conditions history of the user in the tableview and allows the option to restrict their view to 1 months history and 6 months history


#import <Foundation/Foundation.h>

#import "ConditionsController.h"
#import "AuthViewController.h"


@interface ConditionsController()

@property(nonatomic)NSMutableArray *conditions;
@property(nonatomic)NSMutableArray *condDisplay;
@property(nonatomic)NSInteger curdate;
@property(nonatomic)NSInteger curmonth;
@property(nonatomic)NSInteger curyear;

@end

@implementation ConditionsController
@synthesize segment, labelText;

-(void)viewWillAppear:(BOOL)animated{
   
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.conditions = [[NSMutableArray alloc]init];
    self.condDisplay = [[NSMutableArray alloc]init];
    self.labelText.numberOfLines = self.conditions.count;
    
    [self retrieveCondDetails];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logout:)];
    // self.navigationItem.rightBarButtonItem = logoutButton;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:logoutButton,nil];
    NSString* str = @"";
    [self.tableViewTxt reloadData];
    for(int i=0; i< self.conditions.count;i++){
        [self.condDisplay addObject:self.conditions[i][1]];
        NSLog(@"conditions[i][1] : %@",self.conditions[i][1]);
        str =  [str stringByAppendingString:self.conditions[i][1]];
        str = [str stringByAppendingString:@"\n"];
    }[self.tableViewTxt reloadData];
    
    
}

- (void)viewDidLoad
{
        [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
///file path to db
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




-(IBAction)logout:(id)sender{
    //AuthView
    AuthViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
   // [self presentViewController:avc animated:YES completion:nil];
    
    
    [self.navigationController pushViewController:avc animated:YES];
    
    
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
    cell.accessoryType = UITableViewCellAccessoryNone;;
    
    return cell;
}

//retrieve conditions of the user from the table

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
        NSString  * query = @"SELECT * from ConditionsTable";
        
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
    
}
-(IBAction)addentry:(id)sender{
    
}

//Action for segment change 
- (IBAction)segmentchange:(id)sender {
       //called when segment changes
    if (self.segment.selectedSegmentIndex==0) {
        [self.condDisplay removeAllObjects];
        
        NSLog(@"At segment 0: ");
        NSString* str = @"";
        for(int i=0; i< self.conditions.count;i++){
            [self.condDisplay addObject:self.conditions[i][1]];
            
            str =  [str stringByAppendingString:self.conditions[i][1]];
            str = [str stringByAppendingString:@"\n"];
        }
       
        
        [self.tableViewTxt reloadData];
        
    }
    else if(self.segment.selectedSegmentIndex==1) {
        
        NSLog(@"At segment 1: ");   //past 1 month
        [self.condDisplay removeAllObjects];
        
        self.curDate = [NSDate date];
        
        NSDateFormatter *monthFormatter=[[NSDateFormatter alloc] init];
        NSDateFormatter *dayFormatter=[[NSDateFormatter alloc] init];
        NSDateFormatter *yearFormatter=[[NSDateFormatter alloc] init];
        
       
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [monthFormatter setDateFormat:@"MM"];
        
        [dayFormatter setDateFormat:@"dd"];
        [yearFormatter setDateFormat:@"yyyy"];
        
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
            
        }
        
        [self.tableViewTxt reloadData];
        
    }
    else {
        
        NSLog(@"At segment 2: ");  //past 6 months
        [self.condDisplay removeAllObjects];
        
        self.curDate = [NSDate date];
        
        NSDateFormatter *monthFormatter=[[NSDateFormatter alloc] init];
        NSDateFormatter *dayFormatter=[[NSDateFormatter alloc] init];
        NSDateFormatter *yearFormatter=[[NSDateFormatter alloc] init];
    
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
       
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [monthFormatter setDateFormat:@"MM"];
        
        [dayFormatter setDateFormat:@"dd"];
        [yearFormatter setDateFormat:@"yyyy"];
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
            
            
        }
       
        [self.tableViewTxt reloadData];
        
    }
    
}
- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}

@end