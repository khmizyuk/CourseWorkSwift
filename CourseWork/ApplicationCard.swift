import Foundation

class ApplicationCard {
    
    var position: String
    var company: String
    var city: String
    var period: String
    var description: String
    var id: String
    var applied: Bool
    var emailAddress: String
    var tasks: String
    
    init(position: String, company: String, city: String, period: String, description: String, tasks: String, emailAddress: String) {
        self.position = position
        self.company = company
        self.city = city
        self.period = period
        self.description = description
        self.id = "\(company) (\(city)) > \(position)"
        self.applied = false
        self.emailAddress = emailAddress
        self.tasks = tasks
    }
}
