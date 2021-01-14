//
//  PASessionViewModel.swift
//  Projectart
//
//  Created by Infostride on 22/08/19.
//  Copyright © 2019 Infostride. All rights reserved.
//

import Foundation

class PASessionViewModel: NSObject {
    var sessionList:[PASessionModel] = []
    fileprivate var sessionObj:PASessionModel?
    
    func getSession(onSuceess:@escaping() -> Void) {
        if !NetworkState.state.isConnected {
            return
        }
        SMUtility.shared.showHud()
        Server.Request.dataTask(method: .get) { (result) in
            switch result{
            case .success(let data, let code):
                async {
                    SMUtility.shared.hideHud()
                    guard let response = data.JKDecoder(sessionResponseModel.self).object else{return}
                    print("THE RESPONSE IS THE-------------->",response)
                    guard let  status  = response.status else{return}
                    if status == "success"{
                        if let list  = response.data{
                            self.sessionList = list
                        }
                        onSuceess()
                    }
                    else{
                        alertMessage = response.message
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    SMUtility.shared.hideHud()
                    alertMessage = error.localizedDescription
                    
                }
            }
        }.request(request:  kGetSession , headers: nil, params: nil)
    }
    
    func addSession(title:String, startDate:String, endDate:String, onSuceess:@escaping() -> Void) {
        if !NetworkState.state.isConnected {
            return
        }
        SMUtility.shared.showHud()
        let Params = ["title":title,"startDate":startDate,"endDate":endDate]
        
        Server.Request.dataTask(method: .post) { (result) in
            switch result{
            case .success(let data, let code):
                async {
                    SMUtility.shared.hideHud()
                    guard let response = data.JKDecoder(CreateSessionResponseModel.self).object else{return}
                    print("THE RESPONSE IS THE-------------->",response)
                    guard let  status  = response.status else{return}
                    if status == "success"{
                        onSuceess()
                    }
                    else{
                        alertMessage = response.message
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    SMUtility.shared.hideHud()
                    alertMessage = error.localizedDescription
                    
                }
            }
        }.request(request:  kAddSession , headers: nil, params: Params)
    }
    
    func updateSession( title:String, startDate:String, endDate:String, onSuceess:@escaping() -> Void) {
        guard NetworkState.state.isConnected , let obj = sessionObj else {
            return
        }
        SMUtility.shared.showHud()
        let Params = ["title":title,"startDate":startDate,"endDate":endDate]
        
        Server.Request.dataTask(method: .put) { (result) in
            switch result{
            case .success(let data, let code):
                async {
                    SMUtility.shared.hideHud()
                    guard let response = data.JKDecoder(CreateSessionResponseModel.self).object else{return}
                    print("THE RESPONSE IS THE-------------->",response)
                    guard let  status  = response.status else{return}
                    if status == "success"{
                        onSuceess()
                    }
                    else{
                        alertMessage = response.message
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    SMUtility.shared.hideHud()
                    alertMessage = error.localizedDescription
                    
                }
            }
        }.request(request:  kUpdateSession + "\(obj.sessionId!)" , headers: nil, params: Params)
    }
    func deleteSession(onSuceess:@escaping() -> Void) {
        guard NetworkState.state.isConnected , let obj = sessionObj else {
            return
        }
        SMUtility.shared.showHud()
        let Params = ["sessionId":"\(obj.sessionId!)"]
        
        Server.Request.dataTask(method: .put) { (result) in
            switch result{
            case .success(let data, let code):
                async {
                    SMUtility.shared.hideHud()
                    guard let response = data.JKDecoder(CreateSessionResponseModel.self).object else{return}
                    print("THE RESPONSE IS THE-------------->",response)
                    guard let  status  = response.status else{return}
                    if status == "success"{
                        onSuceess()
                    }
                    else{
                        alertMessage = response.message
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    SMUtility.shared.hideHud()
                    alertMessage = error.localizedDescription
                    
                }
            }
        }.request(request:  kDeleteSession , headers: nil, params: Params)
    }
    
}
extension PASessionViewModel{
    
    var sessionCount:Int{
        return sessionList.count
    }
    subscript(sessionAt indexPath:IndexPath)->PASessionModel?{
        return sessionList[indexPath.row]
    }
    func editArchiveSession(index:Int){
        self.sessionObj = self[sessionAt: IndexPath(row: index, section: 0)]
    }
    
    var sessionTitle:String{
        return self.sessionObj?.title ?? ""
    }
    var startSessionDate:String{
        return self.sessionObj?.startDate ?? ""
    }
    var endSessionDate:String{
        return self.sessionObj?.endDate ?? ""
    }
    
}
