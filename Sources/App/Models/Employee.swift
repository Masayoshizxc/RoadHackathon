//
//  File.swift
//  
//
//  Created by Adilet on 7/3/23.
//

import Fluent
import Vapor

final class Employee: Model, Content {
    static let schema = "employee"
    
   
//    static let shema = "employee"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "name") var name: String
    
    @Field(key: "job") var job: String
    
    @Field(key: "selery") var selery: Int
    
    @Field(key: "number") var number: String
    
    
    init() { }
    
    init(id: UUID? = nil, name: String, job: String, selery: Int, number: String) {
        self.id = id
        self.job = job
        self.name = name
        self.selery = selery
        self.number = number
    }
}

//final class Todo: Model, Content {
//    static let schema = "todos"
//
//    @ID(key: .id)
//    var id: UUID?
//
//    @Field(key: "title")
//    var title: String
//
//    init() { }
//
//    init(id: UUID? = nil, title: String) {
//        self.id = id
//        self.title = title
//    }
//}
