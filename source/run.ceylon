Iterable<Element> filter<Element>(Iterable<Element> stream, Boolean predicate(Element s)){
    object iterable satisfies Iterable<Element> {
        shared actual Iterator<Element> iterator {
            Iterator<Element> wrapped = stream.iterator;
            object iter satisfies Iterator<Element> {
                shared actual Element|Finished next() {
                    while(!is Finished next = wrapped.next()){
                        if(predicate(next)){
                            return next;
                        }
                    }
                    return exhausted;
                }
            }
            return iter;
        }
    }
    return iterable;
}

Iterable<Result> map<Element, Result>(Iterable<Element> stream, Result f(Element s)){
    object iterable satisfies Iterable<Result> {
        shared actual Iterator<Result> iterator {
            Iterator<Element> wrapped = stream.iterator;
            object iter satisfies Iterator<Result> {
                shared actual Result|Finished next() {
                    if(!is Finished next = wrapped.next()){
                        return f(next);
                    }
                    return exhausted;
                }
            }
            return iter;
        }
    }
    return iterable;
}

Result fold<Element, Result>(Iterable<Element> stream, Result initial, Result f(Result accum, Element s)){
    variable Result ret := initial;
    for(Element elem in stream){
        ret := f(ret, elem);
    }
    return ret;
}

void run(){
    String s = "Hello World";
    value filtered = filter(s, function (Character elem) !elem.uppercase);
    value mapped = map(filtered, function (Character elem) elem.uppercased.string);
    String newString = fold(mapped, "", function (String partial, String elem) partial + elem);
    process.writeLine(newString);
}