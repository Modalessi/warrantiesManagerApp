//
//  AlertController.swift
//  Thmanat
//
//  Created by Mohammed Alessi on 26/01/1442 AH.
//  Copyright © 1442 Mohammed Alessi. All rights reserved.
//

import Foundation
import UIKit


class AlertController {
    
    // alerts
    var errorAlert: UIAlertController = UIAlertController()
    var attentionAlert: UIAlertController = UIAlertController()
    var doneAlert: UIAlertController = UIAlertController()
    
    // commonActions
    let okAction = UIAlertAction(title: "موافق", style: .cancel, handler: nil)
    
    // errors
    enum errors {
        case camerNotFound
        case contextNotSaved
        case dataNotFound
        case someError
        
        var message: String {
            switch self {
            case .camerNotFound:
                return "عذرا لم يتم العثور على كاميرا"
            case .contextNotSaved:
                return "عذرا حدث خطا ما اثناء حفظ البيانات"
            case .dataNotFound:
                return "عذرا حدث خطا ما اثناء تحميل البيانات"
            case .someError:
                return "حدث خطا ما اثناء العملية الرجاء المحاولة مرة اخرى"
            }
        }
        
    }
      
    // attentions
    enum attentions {
        case filedsAreNotFull
        case dataNotSaved
        
        var message: String {
            switch self {
            case .dataNotSaved:
                return "انت لم تقم بحفظ البيانات هل انت متاكد من الخروج ؟"
            
            case .filedsAreNotFull:
                return "عذرا انت لم تقم بملئ جميع الحقول"
            }
        }
    }
    
    // dones
    enum dones {
        case dataSaved
        
        var message: String {
            switch self {
            case .dataSaved:
                return "لقد تم حفظ البيانات"

            }
        }
    }
    
    
    
    // set alerts
    func setErrorAlert(error: errors)-> UIAlertController {
        errorAlert = UIAlertController(title: "عذرا", message: error.message, preferredStyle: .alert)
        errorAlert.addAction(okAction)
        return errorAlert
    }
    
    func setAttentionAlert(attention: attentions, completion: ((UIAlertAction)->Void)?)-> UIAlertController {
        attentionAlert = UIAlertController(title: "عذرا", message: attention.message, preferredStyle: .alert)
        if attention == .filedsAreNotFull {
            attentionAlert.addAction(okAction)
        } else {
            let yesAction = UIAlertAction(title: "نعم", style: .destructive, handler: completion)
            let noAction = UIAlertAction(title: "لا", style: .cancel, handler: nil)
            attentionAlert.addAction(yesAction)
            attentionAlert.addAction(noAction)
        }
        return attentionAlert
    }
    
    func setDoneAlert(done: dones, completion: ((UIAlertAction)->Void)?)-> UIAlertController {
        doneAlert = UIAlertController(title: "تم", message: done.message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "موافق", style: .default, handler: completion)
        doneAlert.addAction(doneAction)
        return doneAlert
    }
    
}
