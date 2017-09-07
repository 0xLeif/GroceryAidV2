import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()

routes.add(method: .get, uri: "/", handler: {
	request, response in
	response
		.setBody(string: "Hello World!")
		.completed()
})

func JSON(message: String, response: HTTPResponse) {
	do {
		try response
			.setBody(json: ["message": message])
			.setHeader(.contentType, value: "application/json")
			.completed()
	} catch {
		response
			.setBody(string: "Error handling request: \(error)")
			.completed(status: .internalServerError)
	}
}

routes.add(method: .get, uri: "/hello/{times}") { (request, response) in
	guard let times = request.urlVariables["times"],
		let timesCount = Int(times) else {
			response.completed(status: .badRequest)
			return
	}
	var text = ""
	stride(from: 0, to: timesCount, by: 1).forEach{ _ in
		text += "Hello JSON\n"
	}
	JSON(message: text, response: response)
}

server.addRoutes(routes)

do {
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
