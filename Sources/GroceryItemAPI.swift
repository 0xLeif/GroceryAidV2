//
//  GroceryItemAPI.swift
//  TechExPackageDescription
//
//  Created by Zach Eriksen on 9/13/17.
//

import Foundation

class GroceryItemAPI {
	
	static func toDictionary(items: [GroceryItem]) -> [[String: Any]] {
		var json: [[String: Any]] = []
		for row in items {
			json.append(row.asDictionary())
		}
		return json
	}
	
	static func allAsDictionary() throws -> [[String: Any]] {
		let all = try GroceryItem.all()
		return toDictionary(items: all)
	}
	
	static func all() throws -> String {
		return try allAsDictionary().jsonEncodedString()
	}
	
	static func first() throws -> String {
		if let first = try GroceryItem.first() {
			return try first.asDictionary().jsonEncodedString()
		} else {
			return try [].jsonEncodedString()
		}
	}
	
	static func matchingShort(_ matchingShort: String) throws -> String {
		let items = try GroceryItem.items(withName: matchingShort)
		return try toDictionary(items: items).jsonEncodedString()
	}
	
	static func notMatchingShort(_ notMatchingShort: String) throws -> String {
		let items = try GroceryItem.items(withoutName: notMatchingShort)
		return try toDictionary(items: items).jsonEncodedString()
	}
	
	static func delete(id: Int) throws {
		let item = try GroceryItem.item(forId: id)
		try item.delete()
	}
	
	static func deleteFirst() throws -> String {
		guard let item = try GroceryItem.first() else {
			return "No item to update"
		}
		
		try item.delete()
		return try all()
	}
	
	static func newItem(withName name: String, amount: String) throws -> [String: Any] {
		let item = GroceryItem()
		item.name = name
		item.amount = amount
		try item.save { id in
			item.id = id as! Int
		}
		return item.asDictionary()
	}
	
	static func newItem(withJSONRequest json: String?) throws -> String {
		guard let json = json,
			let dict = try json.jsonDecode() as? [String: String],
			let name = dict["name"],
			let amount = dict["amount"] else {
				return "Invalid parameters"
		}
		
		return try newItem(withName: name, amount: amount).jsonEncodedString()
	}
	
	static func updateItem(withJSONRequest json: String?) throws -> String {
		guard let json = json,
			let dict = try json.jsonDecode() as? [String: Any],
			let id = dict["id"] as? Int,
			let name = dict["name"] as? String,
			let amount = dict["amount"] as? String else {
				return "Invalid parameters"
		}
		
		let item = try GroceryItem.item(forId: id)
		item.name = name
		item.amount = amount
		try item.save()
		
		return try item.asDictionary().jsonEncodedString()
	}
	
}
