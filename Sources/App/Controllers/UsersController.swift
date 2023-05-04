//
//  UsersController.swift
//  
//
//  Created by Adilet on 16/3/23.
//

import Vapor
import Fluent

struct UsersController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let usersGroup = routes.grouped("users")
        usersGroup.post(use: createHandler)
        usersGroup.get(use: getAllHandler)
        usersGroup.get(":id", use: getHandler)
        usersGroup.post("auth", use: authHandler)
    }
    //MARK: CRUD - Create
    func createHandler(_ req: Request) async throws -> User.Public {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        return user.convertToPublic()
    }
    //MARK: CRUD - Retrieve All
    func getAllHandler(_ req: Request) async throws -> [User.Public] {
        let users = try await User.query(on: req.db).all()
        let publics = users.map { user in
            user.convertToPublic()
        }
        return publics
    }
    //MARK: CRUD - Retrieve
    func getHandler(_ req: Request) async throws -> User.Public {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.custom(code: 498, reasonPhrase: "Nu hz vashe"))
        }
        
        return user.convertToPublic()
    }
    //MARK: Authorizing
    func authHandler(_ req: Request) async throws -> User.Public {
        let userDTO = try req.content.decode(AuthUserDTO.self)
        guard let user = try await User
            .query(on: req.db)
            .filter("login", .equal ,userDTO.login)
            .first() else {throw Abort(.notFound)}
        let isPassEqual = try Bcrypt.verify(userDTO.password, created: user.password)
        guard isPassEqual else { throw Abort(.unauthorized)}
        return user.convertToPublic()
    }
}


struct AuthUserDTO: Content {
    let login: String
    let password: String
}
