//
//  User.swift
//  
//
//  Created by Adilet on 16/3/23.
//

import Fluent
import Vapor

final class User: Model, Content {
    
    static let schema = "users"
    
    @ID var id: UUID?
    
    @Field(key: "name") var name: String

    @Field(key: "login") var login: String
    
    @Field(key: "password") var password: String
    
    @Field(key: "role") var role: String
    
    final class Public: Content {
        var id: UUID?
        var name: String
        var login: String
        var role: String
        
        init(id: UUID? = nil, name: String, login: String, role: String) {
            self.id = id
            self.name = name
            self.login = login
            self.role = role
        }
    }
}

extension User {
    
    func convertToPublic() -> User.Public {
        let pub = User.Public(id: self.id, name: self.name, login: self.login, role: self.role)
        return pub
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$login
    static let passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
    
    
}

enum UserRole: String {
    case manager = "Manager"
    case director = "Director"
    case admin = "Admin"
}
