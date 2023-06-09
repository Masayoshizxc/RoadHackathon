//
//  CreateUser.swift
//  
//
//  Created by Adilet on 16/3/23.
//

import Vapor
import Fluent

struct CreateUser: AsyncMigration {
    
    
    
    func prepare(on database: FluentKit.Database) async throws {
        
        let schema = database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("login", .string, .required)
            .field("password", .string, .required)
            .field("role", .string, .required)
            .unique(on: "login")
        try await schema.create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("users").delete()
    }
    
}
