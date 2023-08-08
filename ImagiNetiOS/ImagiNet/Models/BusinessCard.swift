import Foundation
import UIKit

public class BusinessCard {
    
    public var firstname: String // Required
    public var lastname: String // Required
    public var company: String?
    public var jobtitle: String // Required
    public var about: String?
    
    // Create basic card with first and last name.
    init(first: String, last: String, jtitle: String) {
        firstname = first
        lastname = last
        jobtitle = jtitle
    }
    
    // Create advanced card with any combination of data.
    init(first: String, last: String, company: String?, jobtitle: String, about: String?) {
        firstname = first
        lastname = last
        self.company = company
        self.jobtitle = jobtitle
        self.about = about
    }
}
