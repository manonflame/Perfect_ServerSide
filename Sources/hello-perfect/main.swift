import PerfectLib
import PerfectHTTP
import PerfectHTTPServer


let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"




//내 앱의 라우트를 관리해주는 친구
var routes = Routes()


//----------------String표시 ------------------------------------


//내 앱의 경로를 정해주고
//응답에 적어줄 String을 바디를 지정하여 정해주면
//local host에서 아래의 메서드에 지정된 내용을 볼 수 있다.
routes.add(method: .get, uri: "/", handler: {
    request, response in
    response.setBody(string: "Hello, Perfect!").completed()
})

//--------------------------------------------------------------


//------------------JSON-------------------------------------

//JSON을 리턴할 메서드를 지정해놓고
//do에서 응답에 헤더와 바디를 지정해줌
func returnJSONMessage(message: String, response: HTTPResponse){
    do{
        try response.setBody(json: ["message" : message])
        .setHeader(.contentType, value: "application/json")
        .completed()
    }catch{
        response.setBody(string: "Error handling request: \(error)")
            .completed(status: .internalServerError)
    }
}

//그리고 json으로 뿌려줄 경로를 지정해 주면 됨
routes.add(method: .get, uri: "hello", handler:{
    request, response in
    returnJSONMessage(message: "hello JSON!", response: response)
})

routes.add(method: .get, uri: "hello/there", handler:{
    request, response in
    returnJSONMessage(message: "I am tired of saying hello!", response: response)
})

routes.add(method: .get, uri: "/beers/{num_beers}", handler:{
    request, response in
    guard let numBeersString = request.urlVariables["num_beers"],
        let numBeersInt = Int(numBeersString) else {
            response.completed(status: .badRequest)
            return
    }
    returnJSONMessage(message: "Take one down, pass it around, \(numBeersInt - 1) bottles of beer on the wall", response: response)
})

routes.add(method: .post, uri: "post", handler: {
    request, response in
    guard let name = request.param(name: "name") else {
        response.completed(status: .badRequest)
        return
    }
    returnJSONMessage(message: "Hello, \(name)!", response: response)
})


//--------------------------------------------------------------



server.addRoutes(routes)

do {
    try server.start()
}catch PerfectError.networkError(let err, let msg){
    print("Network error thrown: \(err) \(msg)")
}


