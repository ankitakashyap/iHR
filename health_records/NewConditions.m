//
//  NewConditions.m
//  HealthRecords
//
//  Created by Dhivya Narayanan on 12/8/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CKCalendarView.h"
#import "NewConditions.h"
#import "ConditionsController.h"

//@interface NewConditions() <CKCalendarDelegate>

@interface NewConditions()

//@property(nonatomic, weak) CKCalendarView *calendar;
//@property(nonatomic, strong) UILabel *dateLabel;
//@property(nonatomic, strong) NSDateFormatter *dateFormatter;
//@property(nonatomic, strong) NSDate *minimumDate;
//@property(nonatomic, strong) NSArray *disabledDates;

@end

@implementation NewConditions

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

/*- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
*/
- (void)viewDidLoad
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    // NSString* curdatetime = [dateFormat stringFromDate:[NSDate date]];
    NSDate *theDate = [NSDate date];
    self.itemDate = theDate;
    NSString * datestr = [dateFormat stringFromDate:self.itemDate];
    self.dateField.text = datestr;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        dateItem.backgroundColor = [UIColor redColor];
        dateItem.textColor = [UIColor whiteColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    //self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    self.itemDate = date;
    self.dateField.text = [self.dateFormatter stringFromDate:date];
    [calendar removeFromSuperview];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}*/

//file path to db
-(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"myrecords.sql"];
}

//open the db
-(void)openDB{
    if(sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK){
        sqlite3_close(db);
        NSAssert(0,@"Database failed to open");
    }else{
        NSLog(@"Database opened");
    }
}




/*- (IBAction)calendarAction:(id)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
    
    self.disabledDates = @[
                           [self.dateFormatter dateFromString:@"05/01/2013"],
                           [self.dateFormatter dateFromString:@"06/01/2013"],
                           [self.dateFormatter dateFromString:@"07/01/2013"]
                           ];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(50, 50, 300, 320);
    [self.view addSubview:calendar];
    
    //self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
    //[self.view addSubview:self.dateLabel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
    
}*/
/*- (IBAction)radioBtSelected:(id)sender {
}*/
- (IBAction)discard:(id)sender {
    
    ConditionsController *cview = [self.storyboard instantiateViewControllerWithIdentifier:@"conditionsview"];
    cview.itemUserName = self.itemUserName;
    
    cview.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *navController = self.navigationController;
    
    //Get all view controllers in navigation controller currently
    NSMutableArray *controllers=[[NSMutableArray alloc] initWithArray:navController.viewControllers] ;
    
    //Remove the last view controller
    [controllers removeLastObject];
    
    //set the new set of view controllers
    [navController setViewControllers:controllers];
    [cview retrieveCondDetails];
    [cview.tableViewTxt reloadData];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationController pushViewController:cview animated:YES];
    


}

- (IBAction)add:(id)sender {
    
    if (self.conditions.text && self.conditions.text.length > 0)
    {
        [self openDB];
        self.itemConditions = self.conditions.text;
       self.itemComments=@"";
        self.itemComments = self.commentsField.text;
        NSLog(@"itemconditions: %@",self.itemConditions);
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        // NSString* curdatetime = [dateFormat stringFromDate:[NSDate date]];
        NSDate *theDate = [NSDate date];
        self.itemDate = theDate;
        NSString * datestr = [dateFormat stringFromDate:self.itemDate];
        self.itemDatestr = [dateFormat stringFromDate:self.itemDate];
        
        
        NSLog(@"itemusername..before insert conditions list..%@",self.itemUserName);
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO ConditionsList('UserName', 'DateTime', 'Conditions', 'Comments') VALUES ('%@', '%@','%@','%@')", _itemUserName,datestr,self.itemConditions,self.itemComments];
        char *err;
        // sqlite3_bind_text(saveStmt, 1, [dateString UTF8String] , -1, SQLITE_TRANSIENT);
        if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK){
            sqlite3_close(db);
            NSAssert(0,@"could not insert into table - conditionslist");
        } else{
            NSLog(@"values inserted into table - ConditionsList");
        }
        
    }
    ConditionsController *cview = [self.storyboard instantiateViewControllerWithIdentifier:@"conditionsview"];
    cview.itemUserName = self.itemUserName;
    //cview.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *navController = self.navigationController;
    
    //Get all view controllers in navigation controller currently
    NSMutableArray *controllers=[[NSMutableArray alloc] initWithArray:navController.viewControllers] ;
    
    //Remove the last view controller
    [controllers removeLastObject];
    
    //set the new set of view controllers
    [navController setViewControllers:controllers];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:cview animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];

  //  [self.navigationController pushViewController:cview animated:YES];
}

- (IBAction)refresh:(id)sender {
    
    self.dateField.text = @"";
    self.conditions.text =@"";
    self.commentsField.text =@"";
}

- (IBAction)back:(id)sender {
    
   /*ConditionsController *cview = [self.storyboard instantiateViewControllerWithIdentifier:@"conditionsview"];
    cview.itemUserName = self.itemUserName;
    cview.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:cview animated:YES completion:nil] ;*/
}
@end
