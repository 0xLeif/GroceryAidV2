//
//  MainController.swift
//  TechExPackageDescription
//
//  Created by Zach Eriksen on 9/13/17.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMustache

final class MainController {
	let documentRoot = "./webroot"
	
	var routes: [Route] {
		return [
			Route(method: .get, uri: "/ga", handler: indexView),
			Route(method: .post, uri: "/ga", handler: addItem),
			Route(method: .post, uri: "/ga/{id}/delete", handler: deleteItem)
		]
	}
	
	func indexView(request: HTTPRequest, response: HTTPResponse) {
		do {
			
			var values = MustacheEvaluationContext.MapType()
			values["groceries"] = try GroceryItemAPI.allAsDictionary()
			mustacheRequest(request: request, response: response, handler: MustacheHelper(values: values), templatePath: request.documentRoot + "/index.mustache")
			
		} catch {
			response.setBody(string: "Error handling request: \(error)")
				.completed(status: .internalServerError)
		}
	}
	
	func addItem(request: HTTPRequest, response: HTTPResponse) {
		do {
			guard let name = request.param(name: "name"),
				let amount = request.param(name: "amount") else {
					response.completed(status: .badRequest)
					return
			}
			
			_ = try GroceryItemAPI.newItem(withName: name, amount: amount)
			
			response.setHeader(.location, value: "/ga")
				.completed(status: .movedPermanently)
			
		} catch {
			response.setBody(string: "Error handling request: \(error)")
				.completed(status: .internalServerError)
		}
	}
	
	func deleteItem(request: HTTPRequest, response: HTTPResponse) {
		do {
			guard let id = Int(request.urlVariables["id"]!) else {
					response.completed(status: .badRequest)
					return
			}
			try GroceryItemAPI.delete(id: id)
			
			response.setHeader(.location, value: "/ga")
				.completed(status: .movedPermanently)
			
		} catch {
			response.setBody(string: "Error handling request: \(error)")
				.completed(status: .internalServerError)
		}
	}
}
