struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}


enum Currency: String {
    case USD = "USD"
    case GBP = "GBP"
    case EUR = "EUR"
    case CAN = "CAN"
}

////////////////////////////////////
// Money
//
public struct Money {
    
    var amount : Int
    var currency : String
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    func convert(_ currency: String) -> Money {
        var inUSD : Double
        var inCurrency : Double
        switch self.currency {
        case "USD":
            inUSD = Double(self.amount) / 1.0
        case "GBP":
            inUSD = Double(self.amount) / 0.5
        case "EUR":
            inUSD = Double(self.amount) / 1.5
        case "CAN":
            inUSD = Double(self.amount) / 1.25
        default:
            return Money(amount: 0, currency: "USD")
        }
        switch currency {
        case "USD":
            inCurrency = 1.0 * inUSD
        case "GBP":
            inCurrency = 0.5 * inUSD
        case "EUR":
            inCurrency = 1.5 * inUSD
        case "CAN":
            inCurrency = 1.25 * inUSD
        default:
            return self
        }
        
        let inCurrencyInt = Int(inCurrency.rounded())
        
        return Money(amount: inCurrencyInt, currency: currency)
    }
    
    func add(_ other: Money) -> Money {
        let selfConverted = self.convert(other.currency)
        return Money(amount: selfConverted.amount + other.amount, currency: other.currency)
    }
    
    func subtract(_ other: Money) -> Money {
        let selfConverted = self.convert(other.currency)
        return Money(amount: other.amount - selfConverted.amount, currency: other.currency)
    }
    
}

////////////////////////////////////
// Job
//
public class Job {
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title : String
    var type : JobType
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let wage):
            return Int(wage * Double(hours))
        case .Salary(let wage):
            return Int(wage)
        }
    }
    
    func calculateIncome() -> Int {
        switch self.type {
        case .Hourly(let wage):
            return Int(wage * 2000)
        case .Salary(let wage):
            return Int(wage)
        }
    }

    
    func raise(byAmount: Double) {
        switch type {
        case .Hourly(let wage):
            type = .Hourly(wage + byAmount)
        case .Salary(let wage):
            type = .Salary(UInt(byAmount) + wage)
        }
    }
    
    func raise(byPercent: Double) {
        let adjusted = byPercent + 1.0
        switch type {
        case .Hourly(let wage):
            type = .Hourly(wage * adjusted)
        case .Salary(let wage):
            type = .Salary(UInt(Double(wage) * adjusted))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName : String
    var lastName : String
    var age : Int
    var job : Job? {
        get { return jobWrapped }
        set {
            if age < 16 {
                jobWrapped = nil
            } else {
                jobWrapped = newValue
            }
        }
    }
    
    var spouse : Person? {
        get { return spouseWrapped }
        set {
            if age < 21 {
                spouseWrapped = nil
            } else {
                spouseWrapped = newValue
            }
        }
    }
    private var jobWrapped : Job?
    private var spouseWrapped : Person?
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = nil
        self.spouse = nil
    }
    
    func toString() -> String {
        var spouseString : String
        var jobString : String
        if spouse != nil {
            spouseString = spouse!.firstName
        } else {
            spouseString = "nil"
        }
        if job != nil {
            jobString = String(describing: job!.type)
        } else {
            jobString = "nil"
        }
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobString) spouse:\(spouseString)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members : Array<Person> = []
    init(spouse1: Person, spouse2: Person) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members = [spouse1, spouse2]
    }
    func haveChild(_ child: Person) -> Bool {
        if members[0].age < 21 && members[1].age < 21 {
            return false
        } else {
            members.append(child)
            return true
        }
    }
    func householdIncome() -> Int {
        var sum = 0
        for member in members {
            if member.job != nil {
                sum += member.job!.calculateIncome()
            }
        }
        return sum
    }
}
