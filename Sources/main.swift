import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import StORM
import PostgresStORM

PostgresConnector.host = "localhost"
PostgresConnector.username	= "groceryAid"
PostgresConnector.password	= "aid"
PostgresConnector.database	= "groceryAidDB"
PostgresConnector.port		= 5432

let setupObj = GroceryItem()
try? setupObj.setup()

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()

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


let main = MainController()
server.addRoutes(Routes(main.routes))

do {
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
