//
//  ViewController.swift
//  CO2Mark1
//
//  Created by Elise Buzzell on 2/11/21.
//

import UIKit

class ViewController: UIViewController {


    private let apiBaseId = "appMvJY9UbFeBYwBC"
    private let apiKey = "keyjOpt1G1EFYthDv"
    private let tableName: String = "SurveyResponses"
    
    @IBAction func calculatePoints(_ sender: UIButton) {
        // upload new survey response
        let newFields = fields(Name: "elise", Carpool: true, PublicTransportation: true, Bike: true, Walked: true)
        let newSurveyResponse = SurveyResponse(fields: newFields)
        createSurveyResponse(newSurveyResponse: newSurveyResponse)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func createSurveyResponse(newSurveyResponse: SurveyResponse) {
        // Prepare URL
        let url = URL(string: "https://api.airtable.com/v0/" + apiBaseId + "/SurveyResponses")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + apiKey, forHTTPHeaderField: "Authorization")
        
        // convert struct to json
        let jsonData = try? JSONEncoder().encode(newSurveyResponse)
         
        // Set HTTP Request Body
        request.httpBody = jsonData
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
//                // Convert HTTP Response Data to a String
//                if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                    print("Response data string:\n \(dataString)")
//                }
            
                guard let data = data else {return}
                do{
                    let surveyResponse = try JSONDecoder().decode(SurveyResponse.self, from: data)
                    print("Response data:\n \(surveyResponse)")
                    print("surveyResponse Id: \(surveyResponse.id)")
                    print("surveyResponse Points: \(surveyResponse.fields.Points ?? 0)")
                    
                    //let points = surveyResponse.fields.Points ?? 0
                    
                } catch let jsonErr{
                    print(jsonErr)
               }
        }
        task.resume()
        
    }

}

struct fields: Codable {
    var Name: String
    var Carpool: Bool?
    var PublicTransportation: Bool?
    var Bike: Bool?
    var Walked: Bool?
    var Points: Int?
}

struct SurveyResponse: Codable {
    var id: String?
    var fields: fields
    var createdTime: String?
}

struct SurveyResponses: Codable {
    var records: [SurveyResponse]
}
