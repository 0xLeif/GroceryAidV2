//
//  GroceryItem.swift
//  TechExPackageDescription
//
//  Created by Zach Eriksen on 9/13/17.
//

import Foundation
import StORM
import PostgresStORM

class GroceryItem: PostgresStORM {
	var id: Int = 0
	var name: String = ""
	var amount: String = ""
	
	override open func table() -> String { return "groceries" }
	
	override func to(_ this: StORMRow) {
		id = this.data["id"] as? Int ?? 0
		name	= this.data["name"] as? String	?? ""
		amount = this.data["amount"] as? String	?? ""
	}
	
	func rows() -> [GroceryItem] {
		var rows = [GroceryItem]()
		for i in 0..<self.results.rows.count {
			let row = GroceryItem()
			row.to(self.results.rows[i])
			rows.append(row)
		}
		return rows
	}
	
	func asDictionary() -> [String: Any] {
		return [
			"id": self.id,
			"name": self.name,
			"amount": self.amount
		]
	}
	
	static func all() throws -> [GroceryItem] {
		let getObj = GroceryItem()
		try getObj.findAll()
		return getObj.rows()
	}
	
	static func first() throws -> GroceryItem? {
		let getObj = GroceryItem()
		let cursor = StORMCursor(limit: 1, offset: 0)
		try getObj.select(whereclause: "true", params: [], orderby: [], cursor: cursor)
		return getObj.rows().first
	}
	
	static func item(forId id:Int) throws -> GroceryItem {
		let getObj = GroceryItem()
		var findObj = [String: Any]()
		findObj["id"] = "\(id)"
		try getObj.find(findObj)
		return getObj
	}
	
	static func items(withName name:String) throws -> [GroceryItem] {
		let getObj = GroceryItem()
		var findObj = [String: Any]()
		findObj["name"] = name
		try getObj.find(findObj)
		return getObj.rows()
	}
	
	static func items(withoutName name:String) throws -> [GroceryItem] {
		let getObj = GroceryItem()//TODO
		try getObj.select(whereclause: "name != $1", params: ["name"], orderby: ["id"])
		return getObj.rows()
	}
}
