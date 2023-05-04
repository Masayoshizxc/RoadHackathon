//
//  File.swift
//  
//
//  Created by Adilet on 7/3/23.
//

import Fluent
import Vapor

struct CreateEmployee: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        
        let schema = database.schema("employee")
            .id()
            .field("name", .string, .required)
            .field("job", .string, .required)
            .field("selery", .int, .required)
            .field("number", .string, .required)
        try await schema.create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("employee").delete()
    }
}

//import Fluent
//
//struct CreateTodo: AsyncMigration {
//    func prepare(on database: Database) async throws {
//        try await database.schema("todos")
//             .id()
//            .field("title", .string, .required)
//            .create()
//    }
//
//    func revert(on database: Database) async throws {
//        try await database.schema("todos").delete()
//    }
//}
