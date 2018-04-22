
## SwiftyCurl

### Generate curl commands from URLRequest

Directly from URLRequest:

````
let request = URLRequest(url: url)
let curlCommand = request.curlCommand()
print("curlCommand: \(curlCommand)"
````

Indirectly from URLSessionTask.originalRequest or URLSessionTask.currentRequest:

````
// Allow task to be captured by the closure
var task: URLSessionTask! = nil
task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
    if let curlCommand = task.originalRequest?.curlCommand() {
        print("curlCommand: \(curlCommand)")
    }
})
task.resume()
 
````

Outputs:
````
curl -H "User-Agent:123234345" -X GET "http://api.openweathermap.org/data/2.5/weather?lat=37.78&lon=-122.41&APPID=4199a667b2597ff5b28f33ec06d6a31b"
````

### Generate curl reports from URLSessionTask (prints request, response, and represents payload in text)
````
// Allow task to be captured by the closure
var task: URLSessionTask! = nil
task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
    do {
        let curlReport = try CURL.curlReport(task: task, data: data, error: error)
        print("curl report: \(curlReport)"
    } catch {
        print("Failed to generate curlReport: \(error.localizedDescription)")
    }
})
task.resume()
````

Outputs
````
**************** HTTP SUCCESS 200 **********************
**** REQUEST ****
curl -H "User-Agent:123234345" -X GET "http://api.openweathermap.org/data/2.5/weather?lat=37.78&lon=-122.41&APPID=4199a667b2597ff5b28f33ec06d6a31b"
**** PAYLOAD ****
{
    base = stations;
    clouds =     {
        all = 0;
    };
    cod = 200;
    coord =     {
        lat = "37.78";
        lon = "-122.41";
    };
    dt = 1524425700;
    id = 5391959;
    main =     {
        humidity = 49;
        pressure = 1015;
        temp = "294.62";
        "temp_max" = "297.15";
        "temp_min" = "290.15";
    };
    name = "San Francisco";
    sys =     {
        country = US;
        id = 438;
        message = "0.008";
        sunrise = 1524403425;
        sunset = 1524451963;
        type = 1;
    };
    visibility = 16093;
    weather =     (
                {
            description = "clear sky";
            icon = 01d;
            id = 800;
            main = Clear;
        }
    );
    wind =     {
        deg = 60;
        speed = "1.5";
    };
}
****************************************************
````



