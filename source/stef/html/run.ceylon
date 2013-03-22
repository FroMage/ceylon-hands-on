doc "Run the module `ceylon.html`."
shared void run() {
    Html html = Html{
        head = Head {
            title = "Welcome to Ceylon";
        };
        body = Body {
            P {
                "hello",
                B {
                    "devoxx"
                }
            }
        };
    };
    
    print(html);
}