doc "Breaks stuff:
     
     - SHA1
     - You name it
     
     we _do_ break stuff here."
by "Stef"
see (Sha1Breaker)
shared interface Breaker{
    
    doc "Breaks the stuff"
    shared formal void breakIt();
}

doc "Breaks a SHA1"
shared class Sha1Breaker() satisfies Breaker {
    doc "do tons of stuff"
    throws (Exception, "occasionally")
    shared void doStuff(){}
    
    shared actual void breakIt() {}
}