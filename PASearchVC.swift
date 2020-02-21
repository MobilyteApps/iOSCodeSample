//
//  PASearchVC.swift
//  Projectart
//
//  Created by Sunil Garg on 10/08/19.
//  Copyright © 2019 Sunil Garg. All rights reserved.
//

import UIKit
var isSearchController  = false
class PASearchVC: UIViewController {
    @IBOutlet var objPASearchWaitingViewModel: PASearchWaitingViewModel!
    @IBOutlet var searchTF: UITextField!
    @IBOutlet var selectCityTF: UITextField!
    @IBOutlet var selectBranchTF: UITextField!
    @IBOutlet var selectClassesTF: UITextField!
    @IBOutlet var selectSessionTF: UITextField!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    fileprivate var cityIdValue       = ""
    fileprivate var branchIdValue     = ""
    fileprivate var classIdValue      = ""
    fileprivate var sessionIdValue    = ""
    fileprivate var searchTextValue   = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.reloadData()
        
        PASearchFilterViewModel.shared.clearFilter(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isSearchController {
            self.title = "Search"
            objPASearchWaitingViewModel.removeAllSearchStudentData()
        }else{
            self.title = "Student Waiting List"
            objPASearchWaitingViewModel.removeAllSearchStudentWaitingData()
        }
        tableView.reloadData()
        getSearchData()
        
    }
    
    func getSearchData(){
        guard NetworkState.state.isConnected else {
            return
        }
        SMUtility.shared.showHud()
        let group = DispatchGroup()
        group.enter()
        objPASearchWaitingViewModel.citiesList(false) { (success) in
            group.leave()
        }
        group.enter()
        objPASearchWaitingViewModel.getSession(false) { (success) in
            group.leave()
        }
        if isSearchController == true {
            group.enter()
            self.getSearchStudentList(true) { (success) in
                group.leave()
            }
        }else{
            group.enter()
            self.getSearchStudentWaitingList(true) { (success) in
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            SMUtility.shared.hideHud()
            self.tableView.reloadData()
        }
    }
    
    func getSearchStudentList(_ isLoader:Bool = true, onCompletion:@escaping(Bool)->Void){
        objPASearchWaitingViewModel.searchStudent(isLoader, searchText: searchTF.text ?? "", cityId: cityIdValue, branchId: branchIdValue, ClassId: classIdValue, SessionId: sessionIdValue, onSuceess: onCompletion)
        
    }
    func getSearchStudentWaitingList(_ isLoader:Bool = true, onCompletion:@escaping(Bool)->Void){
        objPASearchWaitingViewModel.searchWaitingStudent(isLoader, searchText: searchTF.text ?? "", cityId: cityIdValue, branchId: branchIdValue, ClassId: classIdValue, SessionId: sessionIdValue, onSuceess: onCompletion)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == SegueIdentity.kSearchStudentDetailSegueVC ,let btn = sender as? UIButton{
            objPASearchWaitingViewModel.editSearchStudentDetail(index: btn.tag)
            let controller = segue.destination as! PAStudentProfileVC
            controller.objPASearchWaitingViewModel = self.objPASearchWaitingViewModel
            controller.isFromSearchVC = true
            controller.isForSearchStudent = true
        }
        else if segue.identifier == SegueIdentity.kFilterVCSegue
        {
            let controller = segue.destination as! PAFilterVC
        }
        else if segue.identifier == SegueIdentity.kChangeStudentClassSegueVC, let btn = sender as? UIButton{
            let controller = segue.destination as! PAChangeStudentClassVC
            controller.isFromSearchVC = true
            controller.isForSearchStudent = true
            controller.objPASearchWaitingViewModel = self.objPASearchWaitingViewModel
            objPASearchWaitingViewModel.editSearchStudentDetail(index: btn.tag)
            controller.completion = {(issuccess,message) in
                if issuccess{
                    self.showAlert(message:message) { (index) in
                        self.getSearchStudentList(true) { (success) in
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        else if segue.identifier == SegueIdentity.kPAEditStudentSegueVC, let btn = sender as? UIButton{
            objPASearchWaitingViewModel.editSearchStudentDetail(index: btn.tag)
            let controller = segue.destination as! PAEditStudentVC
            controller.objPASearchWaitingViewModel = self.objPASearchWaitingViewModel
            controller.completion = {(issuccess,message) in
                if issuccess{
                    self.getSearchStudentList(true) { (success) in
                        self.tableView.reloadData()
                    }
                }
            }
        }
            
        else  if segue.identifier == SegueIdentity.kWaitingStudentDetailSegueVC ,let btn = sender as? UIButton{
            objPASearchWaitingViewModel.editSearchStudentWaitingDetail(index: btn.tag)
            let controller = segue.destination as! PAStudentProfileVC
            controller.objPASearchWaitingViewModel = self.objPASearchWaitingViewModel
            controller.isFromSearchVC = true
            controller.isForSearchStudent = false
        }
        else if segue.identifier == SegueIdentity.kWaitingChangeStudentClassSegueVC, let btn = sender as? UIButton{
            objPASearchWaitingViewModel.editSearchStudentWaitingDetail(index: btn.tag)
            let controller = segue.destination as! PAChangeStudentClassVC
            controller.isFromSearchVC = true
            controller.isForSearchStudent = false
            controller.objPASearchWaitingViewModel = self.objPASearchWaitingViewModel
            
            controller.completion = {(issuccess,message) in
                if issuccess{
                    self.showAlert(message:message) { (index) in
                        self.getSearchStudentWaitingList(true) { (success) in
                            self.tableView.reloadData()
                        }
                    }
                    
                }
            }
        }
    }
    
    @IBAction func filterBtn(_ sender: UIButton) {
    }
    
    @IBAction func cityDropdownBtn(_ sender: UIButton) {
        if objPASearchWaitingViewModel.cityListCount == 0{
            self.showAlert(message: "No Cities List")
            
        }else{
            self.popOver(sender: sender, arrowDirection: .up,type:.searchCities)
        }
    }
    
    @IBAction func branchDropdownBtn(_ sender: UIButton) {
        if selectCityTF.text == "" {
        }
        else{
            if objPASearchWaitingViewModel.branchListCount == 0{
                self.showAlert(message: "No Branches List")
            }else{
                self.popOver(sender: sender, arrowDirection: .up,type:.searchBranches)
            }
            
        }
    }
    
    @IBAction func classesDropdownBtn(_ sender: UIButton) {
        if selectBranchTF.text == "" {
        }
        else{
            if objPASearchWaitingViewModel.classListCount == 0{
                self.showAlert(message: "No Classes List")
            }else {
                self.popOver(sender: sender, arrowDirection: .down,type:.searchClasses)
            }
            
        }
    }
    
    @IBAction func sessionDropdownBtn(_ sender: UIButton) {
        if objPASearchWaitingViewModel.sessionListCount == 0{
            self.showAlert(message: "No Session List")
            
        }else{
            self.popOver(sender: sender, arrowDirection: .up,type:.searchSession)
        }
    }
    
    @IBAction func searchBtn(_ sender: JKButton) {
        if isSearchController == true {
            self.getSearchStudentList(true) { (success) in
                async {
                    self.tableView.reloadData()
                }
            }
        }
        else{
            self.getSearchStudentWaitingList(true) { (success) in
                async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    @IBAction func clearBtn(_ sender: JKButton) {
        self.searchTF.text = ""
        self.selectCityTF.text = ""
        self.selectBranchTF.text = ""
        self.selectClassesTF.text = ""
        self.selectSessionTF.text = ""
        
        self.cityIdValue = ""
        self.branchIdValue = ""
        self.classIdValue = ""
        self.sessionIdValue = ""
    }
    
    
    func popOver(sender:UIButton,arrowDirection:UIPopoverArrowDirection,type:PADropDownType)
    {
        let popoverContent = PADropDownVC.instance(from: .Dashboard)
        popoverContent.objPASearchWaitingViewModel = self.objPASearchWaitingViewModel
        popoverContent.dropDownType = type
        popoverContent.complitionHandler = {(name, sessionId, cityId, branchId, ClassId) in
            
            self.dismiss(animated: true, completion: nil)
            switch type {
                
            case .searchCities:
                
                self.selectCityTF.text = name
                self.selectBranchTF.text = ""
                self.selectClassesTF.text = ""
                self.branchIdValue = ""
                self.classIdValue = ""
                
                self.cityIdValue = "\(cityId)"
                self.objPASearchWaitingViewModel.branchList(cityId: self.cityIdValue , onSuceess: {
                    
                })
                
            case .searchBranches:
                
                self.selectBranchTF.text = name
                self.selectClassesTF.text = ""
                self.classIdValue = ""
                
                self.cityIdValue = "\(cityId)"
                self.branchIdValue = "\(branchId)"
                self.objPASearchWaitingViewModel.classList(cityId: self.cityIdValue, branchId: self.branchIdValue, onSuceess: {
                    
                })
            case .searchClasses:
                self.selectClassesTF.text = name
                self.cityIdValue = "\(cityId)"
                self.branchIdValue = "\(branchId)"
                self.classIdValue = "\(ClassId)"
                
            case .searchSession:
                self.selectSessionTF.text = name
                self.sessionIdValue = "\(sessionId)"
                
            default:break
                
            }
        }
        popoverContent.modalPresentationStyle = .popover
        if let popover = popoverContent.popoverPresentationController {
            
            if let viewForSource = sender as? UIView
            {
                popover.sourceView = viewForSource
                popover.permittedArrowDirections = arrowDirection
                popover.sourceRect = viewForSource.bounds
                
                popover.delegate = self
            }
        }
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    @IBAction func deleteStudentBtn(_ sender: UIButton) {
        objPASearchWaitingViewModel.editSearchStudentDetail(index: sender.tag)
        
        self.showAlertAction(title: "Branch", message: "Are you want to delete student?", cancelTitle: "NO", otherTitle: "YES") { (buttonIndex) in
            switch buttonIndex {
            case 2:
                self.objPASearchWaitingViewModel.deleteStudent {
                    self.getSearchStudentList { (success) in
                        async {
                            self.tableView.reloadData()
                        }
                    }
                }
                break
            default:
                break
            }
        }
    }
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        objPASearchWaitingViewModel.editSearchStudentWaitingDetail(index: sender.tag)
        
        self.showAlertAction(title: "", message: "Are you want to confirm student?", cancelTitle: "NO", otherTitle: "YES") { (buttonIndex) in
            switch buttonIndex {
            case 2:
                self.objPASearchWaitingViewModel.confirmStudent {
                    self.getSearchStudentWaitingList(true) { (success) in
                        async {
                            self.tableView.reloadData()
                        }
                    }
                }
                break
            default:
                break
            }
        }
    }
    
}
extension PASearchVC:UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchController == true {
            tableViewHeight.constant = CGFloat((objPASearchWaitingViewModel.searchStudentListCount * 150))
            return objPASearchWaitingViewModel.searchStudentListCount
        }
        else{
            tableViewHeight.constant = CGFloat((objPASearchWaitingViewModel.searchStudentWaitingListCount * 150))
            return objPASearchWaitingViewModel.searchStudentWaitingListCount
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSearchController == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchListCell", for: indexPath) as! PASearchWaitingListCell
            cell.objSearch = self.objPASearchWaitingViewModel[searchStudentListAt: indexPath]
            cell.rowSearch = indexPath.row
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WaitingListCell", for: indexPath) as! PASearchWaitingListCell
            cell.objWaiting = self.objPASearchWaitingViewModel[searchStudentWaitingListAt: indexPath]
            cell.rowWaiting = indexPath.row
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PASearchVC:UIPopoverPresentationControllerDelegate
{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
}

