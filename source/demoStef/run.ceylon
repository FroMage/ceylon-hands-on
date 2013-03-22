import ceylon.net.uri { parseURI }
import ceylon.json { 
    parseJson = parse,
    JsonObject = Object,
    JsonArray = Array, nil
}

doc "Run the module `demoStef`."
void run() {
    value uri = parseURI("http://localhost:9000/api/1/search-modules");
    value response = uri.get().execute();
    value json = parseJson(response.contents);
    
    print(json.pretty);
    
    if(is JsonArray modules = json["results"]){
        for(mod in modules){
            if(is JsonObject mod){
                print(mod["module"]);
                for(entry in mod){
                    print(" [" entry.key "] = " entry.item "");
                }
            }
        }
    }
    
    for(mod in json.getArray("results")){
        if(is JsonObject mod){
            print(mod["module"]);
        }        
    }
    
    value talk = JsonObject {
        "title" -> "hands-on",
        "speakers" -> JsonArray {
            "gavin", "emmanuel", "stef"
        },
        "bugs found" -> 1.2
    };
    print(talk.pretty); 
}