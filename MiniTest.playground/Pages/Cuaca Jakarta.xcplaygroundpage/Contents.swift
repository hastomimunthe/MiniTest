import Foundation

let API_KEY = "94c7f36ec63deb583ad1bd2e9685e2fc"
let CITY_NAME = "Jakarta"
let API_ENDPOINT = "http://api.openweathermap.org/data/2.5/forecast?q=\(CITY_NAME),ID&appid=\(API_KEY)"

// HTTP Request
let url = URL(string: API_ENDPOINT)!
let request = URLRequest(url: url)
let task = URLSession.shared.dataTask(with: request) { data, response, error in
    // Checking for error
    if error != nil {
        print("Error: \(error!)")
        return
    }
    
    // Parse the response
    let responseDictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
    let list = responseDictionary["list"] as! [[String: Any]]
    
    // For 5 days but only one time in a day
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, dd MMM yyyy"
    let calendar = Calendar.current
    let now = Date()
    let forecast = (0..<5).map { i in
        let day = calendar.date(byAdding: .day, value: i, to: now)!
        let dateString = formatter.string(from: day)
        let forecastForDay = list.first {
            let dt = $0["dt"] as! Int
            let date = Date(timeIntervalSince1970: TimeInterval(dt))
            return calendar.isDate(date, inSameDayAs: day)
        }!
        let main = forecastForDay["main"] as! [String: Any]
        var temperature = main["temp"] as! Double
        var temperatureCelcius = temperature - 273.15
        return (dateString, temperatureCelcius)
    }
    
    // Result
    print("Weather Forecast:")
    forecast.forEach { date, temperatureCelcius in
        print("\(date): \(String(format: "%.2f", temperatureCelcius))ºC")
    }

}
task.resume()
