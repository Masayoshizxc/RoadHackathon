//
//  File.swift
//  
//
//  Created by Adilet on 8/3/23.
//

import Fluent
import Vapor

struct EmployeeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        let employeeGroup = routes.grouped("employee")
        
        employeeGroup.get(use: getAllHandler)
        employeeGroup.get(":employeeID", use: getHandler)
        
        let basicMW = User.authenticator()
        let guardMW = User.guardMiddleware()
        let protected = employeeGroup.grouped(basicMW,guardMW)
        
        protected.post(use: createHandler)
        protected.delete(use: deleteHandler)
    }
    //MARK: CRUD - Create
    func createHandler(_ req: Request) async throws -> Employee {
        
        guard let emp = try? req.content.decode(Employee.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Caught error while decoding content in employee model"))
        }
        
        try await emp.save(on: req.db)
        return emp
        
    }
    //MARK: CRUD - Retrieve All
    func getAllHandler(_ req: Request) async throws -> [Employee] {
        let employeers = try await Employee.query(on: req.db).all()
        return employeers
    }
    //MARK: CRUD - Retrieve
    func getHandler(_ req: Request) async throws -> Employee {
        guard let emp = try await Employee.find(req.parameters.get("employeeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return emp
    }
    //MARK: CRUD - Delete
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        guard let employee = try await Employee.find(req.parameters.get("employeeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await employee.delete(on: req.db)
        
        return .ok
    }
    //MARK: CRUD - Update
    func updateHandler(_ req: Request) async throws -> Employee {
        guard let employee = try await Employee.find(req.parameters.get("employeeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedProduct = try req.content.decode(Employee.self)
        
        try await employee.update(on: req.db)
        
        return employee
    }
}
