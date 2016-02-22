//
//  Name of the file:NewPrescriptionController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File allows you to add new prescriptions into the table

//  Created by Dhivya Narayanan on 12/4/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NewPrescriptionController.h"
#import "PrescriptionListController.h"

@interface NewPrescriptionController ()
@property(nonatomic)UIImage* myImage;
@property(strong, nonatomic)NSString* imageFilePath;
@property(nonatomic)NSString* imgName;
@end

@implementation NewPrescriptionController

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
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//Attach file from the gallery

- (IBAction)attachFile:(id)sender{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//Capture the image and display it in imageview and stored into table
- (IBAction)takePicture:(id)sender{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    
    // Dismiss the image selection, hide the picker and
    
    //show the image view with the picked image
    
    [picker dismissModalViewControllerAnimated:YES];
    self.myImage = image;
    [self.prescriptionImage setImage:self.myImage];
    
    
}

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Clear all the entries in the textfields

- (IBAction)refresh:(id)sender {
    self.nameField.text=@"";
    self.prescribedByTxt.text =@"";
    self.prescribedOnTxt.text=@"";
    self.commentsTxt.text=@"";
    
}

//add entered values into the database table

- (IBAction)addtoList:(id)sender {
    
    self.enteredPreName= self.nameField.text;
    if([self.nameField text]&& self.nameField.text.length > 0){
    self.enteredPreDrName = self.prescribedByTxt.text;
    self.enteredDate = self.prescribedOnTxt.text;
    self.enteredComments = self.commentsTxt.text;
    if (self.myImage != nil)
    {
        self. imgName = @"preOf";
        self.imgName = [self.imgName stringByAppendingString:self.enteredPreName];
        self.imgName = [self.imgName stringByAppendingString:@".png"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:self.imgName ];
        NSData* data = UIImagePNGRepresentation(self.myImage);
        [data writeToFile:path atomically:NO];
         NSLog(@"PrescriptionImageFile saved..");
    }
   
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
                             stringWithFormat:@"INSERT INTO PrescriptionListTable (UserName,PrescriptionName,PrescribedBy,Date,Prescription,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,_enteredPreName,_enteredPreDrName,_enteredDate,_imgName,_enteredComments];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }

    PrescriptionListController* newView = [self.storyboard instantiateViewControllerWithIdentifier:@"prescriptionlistview"];
    
    newView.itemUserName = self.itemUsername;
    UINavigationController *navController = self.navigationController;
    
    //Get all view controllers in navigation controller currently
    NSMutableArray *controllers=[[NSMutableArray alloc] initWithArray:navController.viewControllers] ;
    
    //Remove the last view controller
    [controllers removeLastObject];
    
    //set the new set of view controllers
    [navController setViewControllers:controllers];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [navController pushViewController:newView animated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Prescription Name!"
                                                        message:@"Please Enter value to presecription name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];

    }
}

//Discard the values entered and return back to previous list view controller
- (IBAction)cancel:(id)sender {
    PrescriptionListController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"prescriptionlistview"];
    newView.itemUserName = self.itemUsername;
    UINavigationController *navController = self.navigationController;
    
    //Get all view controllers in navigation controller currently
    NSMutableArray *controllers=[[NSMutableArray alloc] initWithArray:navController.viewControllers] ;
    
    //Remove the last view controller
    [controllers removeLastObject];
    
    //set the new set of view controllers
    [navController setViewControllers:controllers];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationController pushViewController:newView animated:YES];
    
    
}
@end

