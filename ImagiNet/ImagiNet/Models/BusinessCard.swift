import Foundation
import UIKit

public class BusinessCard {
    
    public var firstname: String // Required
    public var lastname: String // Required
    public var company: String?
    public var jobtitle: String?
    public var about: String?
    public var website: URL?
    public var photo: UIImage?
    
    // Create basic card with first and last name.
    init(first: String, last: String) {
        firstname = first
        lastname = last
    }
    
    // Create advanced card with any combination of data.
    init(first: String, last: String, company: String?, jobtitle: String?, about: String?, website: URL?, photo: UIImage?) {
        firstname = first
        lastname = last
        self.company = company
        self.jobtitle = jobtitle
        self.about = about
        self.website = website
        self.photo = photo
    }
}
