//
//  EmergencyContactsVC.m
//  Humsafar
//
//  Created by Rahul on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "EmergencyContactsVC.h"
#import "UITextField+Validation.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>


@interface ContactModel : NSObject

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *number;

@end

@implementation ContactModel


@end

@interface EmergencyListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *lbl_contact;
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_number;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;

@end

@implementation EmergencyListTableViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.layer.masksToBounds = YES;
}

@end


@interface EmergencyContactsVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CNContactPickerDelegate,CNContactViewControllerDelegate>

@property (nonatomic) NSArray *arrayList;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, strong) CNContactPickerViewController *contactPickerViewController;

@end

@implementation EmergencyContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrayList = [NSArray arrayWithObjects:[ContactModel new],[ContactModel new],[ContactModel new], nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EmergencyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmergencyListTableViewCell" forIndexPath:indexPath];

    ContactModel *model = self.arrayList[indexPath.row];
    
    cell.lbl_contact.text = [NSString stringWithFormat:@"Contact %ld",indexPath.row+1];
    cell.txt_name.text = model.name;
    cell.txt_number.text = model.number;
    
    cell.txt_name.tag = indexPath.row;
    cell.txt_number.tag = indexPath.row;
    cell.btn_add.tag = indexPath.row;
    
    cell.txt_name.delegate = self;
    cell.txt_number.delegate = self;
    
    [cell.btn_add addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 132;
}

#pragma mark - UITextFiled Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    EmergencyListTableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    
    ContactModel *model = self.arrayList[textField.tag];

    if (cell.txt_name == textField) {
        model.name = textField.text;
    }else{
        model.number = textField.text;
    }
}

#pragma mark - AB Delegate

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    
    ContactModel *model = self.arrayList[picker.view.tag];
    
    model.name = contact.givenName;
    model.number = contact.phoneNumbers.firstObject.value.stringValue;
    
    [self.tblView reloadData];

}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    
    ContactModel *model = self.arrayList[picker.view.tag];
    
    model.name = contactProperty.contact.givenName;
    model.number = contactProperty.contact.phoneNumbers.firstObject.value.stringValue;
    
    [self.tblView reloadData];
}

#pragma mark - Btn Action

- (IBAction)cancelBtnAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];

    BOOL isValide = NO;
    
    NSString *cont1 = @"";
    NSString *cont2 = @"";
    NSString *cont3 = @"";
    
    for (int i =0 ; i<self.arrayList.count;i++) {
        
        ContactModel *model = self.arrayList[i];
        if (model.name.length != 0 || model.number.length != 0) {
            
            isValide = YES;
            
            if (model.name.length == 0) {
                [self showAlert:@"Please enter name!"];
                return;
            }
            if (model.number.length < 10) {
                [self showAlert:@"Mobile must contain 10 characters!"];
                return;
            }
            
            switch (i) {
                case 0:
                    cont1 = [NSString stringWithFormat:@"%@,%@",model.name,model.number];
                    break;
                case 1:
                    cont2 = [NSString stringWithFormat:@"%@,%@",model.name,model.number];
                    break;
                case 2:
                    cont3 = [NSString stringWithFormat:@"%@,%@",model.name,model.number];
                    break;

                default:
                    break;
            }
        }
    }
    
    if (!isValide) {
        [self showAlert:@"Please enter at least one contact!"];
        return;
    }
    
    
    
    // hit API
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:AddUpdateEmergencyContacts withParameter:@{ @"userId" : [UIViewController retrieveDataFromUserDefault:@"userId"],@"contact1" : cont1,@"contact2" : cont2,@"contact3" : cont3,} onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
             [self showAlert:@"Updated successfully!"];
        }else{
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
        }
    }];
}

-(void)addBtnAction:(UIButton*)sender {

    [self.view endEditing:YES];
    
    [self showAddressBook:sender.tag];
}

-(void)showAddressBook:(NSInteger)tag{
    
    self.contactPickerViewController = [[CNContactPickerViewController alloc] init];
    self.contactPickerViewController.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"phoneNumbers.@count > 0"];
    self.contactPickerViewController.view.tag = tag;
    [self.contactPickerViewController setDelegate:self];
    [self presentViewController:self.contactPickerViewController animated:YES completion:nil];
}

@end
