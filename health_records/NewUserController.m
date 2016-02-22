//
//  Name of the file: NewUserController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File gets the profile details from the user. And except firstname and lastname, other fields can be NULL


//  Created by Dhivya Narayanan on 12/2/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewUserController.h"

@interface NewUserController()
@property(nonatomic)UIImage* myImage;
@property(strong, nonatomic)NSString* imageFilePath;
@end

@implementation NewUserController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.scrollView.delegate = self;      //delegate to scrollView
    self.scrollView.scrollEnabled = YES;  //enabling scroll to scrollView
    //TapGestureRecognizer - tap on ImageView
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandler:)];
    tapGR.numberOfTapsRequired = 1;
    self.profilePic.userInteractionEnabled = YES;
    [self.profilePic addGestureRecognizer:tapGR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Action for tap on Imageview
-(void) tapHandler: (UITapGestureRecognizer * )sender
{
    NSLog (@"in tapHandler");
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    //pick a image from gallery and set it to imageview
    [picker dismissModalViewControllerAnimated:YES];
    self.myImage = image;
    [self.profilePic setImage:self.myImage];
    
}
//load image from the path
- (UIImage*)loadImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"savedmyImage.png"];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)submitEntry:(id)sender {
}

//Check for empty fields
-(BOOL)isEmpty{
    
    if(self.firstNameTxt.text && self.firstNameTxt.text.length>0){
        if(self.lastNameTxt.text && self.lastNameTxt.text.length>0){
            return NO;
        }
    }
    return YES;
}

//
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog( @"Transition via segue: '%@'", segue.identifier);
    [super prepareForSegue:segue sender:sender];
    
    // pick up destination view controller from segue object
    //If it satisfied no empty fields condition, then pass the control to CreateAuthController to create auth details
    if(![self isEmpty]){
    
    CreateAuthController *cac = segue.destinationViewController;
    cac.itemFirstName = self.firstNameTxt.text;
    cac.itemLastName = self.lastNameTxt.text;
    cac.itemDob = self.dobTxt.text;
    cac.itemAge = self.ageTxt.text;
    cac.itemGender = self.genderTxt.text;
    if([self.ext text] && self.ext.text.length > 0)
      cac.itemContactno = [self.ext.text stringByAppendingString:self.phoneTxt.text];
    else
        cac.itemContactno = self.phoneTxt.text;
    cac.itemBloodGroup = self.bloodGroupTxt.text;
    cac.itemEmail = self.emailTxt.text;
    cac.itemAddr = self.addressTxt.text;
    cac.itemCity = self.cityTxt.text;
    cac.itemState = self.stateTxt.text;
    cac.itemCountry = self.countryTxt.text;
    cac.itemZipcode = self.zipcodeTxt.text;
    cac.imagePic = self.myImage;
}
    //pop up alert if firstname and lastname fields are empty
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Fields!"
                                                        message:@"FirstName and LastName field should not be Empty!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
