//
//  LocationController.m
//  HealthRecords
//
//  Created by Dhivya Narayanan on 12/6/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

@import CoreLocation;

#import "LocationController.h"


@interface LocationController ()

@property CLLocationManager *mgr;
@property(strong,nonatomic) NSMutableArray *nearbyHospitals;
@property (assign) BOOL findCurlocation;
@property(strong,nonatomic)NSString* enteredZipCode;
@property(assign)NSInteger miles;

@end

@implementation LocationController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    //intializing and creating all the arrays
    
    //setting the delegate and datasoure for pickerview and textfield
    
    
}

//Actions to be done when there is update locations

- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations: (NSArray *)locations
{
    static int updates = 0;
    NSLog(@"Update : %d",++updates);
    
    //getting current latitude and longitude value
    self.currentLatitude = [[locations lastObject] coordinate].latitude;
    self.currentLongitude = [[locations lastObject]coordinate].longitude;
    NSLog(@"currentLatitude: %g",self.currentLatitude);
    NSLog(@"currentLongitude: %g",self.currentLongitude);
    
    //call to model which returns all the continents under which the current location falls.
    
    //call to model to get all the countries and flags belongs to the specific continent
    // Getting all the flags image files of the selected continent from the model
    
    //Retrieving the coutry name from the image files and storing it as an array
   
    
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _nearbyHospitals.count;
}


-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return _nearbyHospitals[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
       
}

// CLLocationManagerDelegate method that receives location updates

// CLLocationManagerDelegate method that receives location error notification
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error
{
    // static int errs = 0;
    
    switch ( error.code )
    {
        case kCLErrorDenied:
            NSLog(@" User denied access to location service\n\n");
            break;
        case kCLErrorLocationUnknown:
            NSLog(@"Unable to obtain location\n\n");
            break;
        case kCLErrorNetwork:
            NSLog( @"Encountered network problem when attempting to obtain location\n\n");
            break;
    }
}


- (IBAction)getcurlocation:(id)sender {
    //self.getCurLocation = (UISwitch *)sender;
    if ([self.getCurLocation isOn]) {
        NSLog(@"its on!");
        self.findCurlocation = YES;
        
    } else {
        NSLog(@"its off!");
        self.findCurlocation = NO;
        [self.mgr stopUpdatingLocation];
    }
}

- (IBAction)findHospital:(id)sender {
    
    if(self.findCurlocation == NO){
        self.enteredZipCode = self.zipcodeTxt.text;
        self.miles = [self.milesaroundTxt.text integerValue];
    }
    else{
        [self.mgr startUpdatingLocation];
    }
}
@end

