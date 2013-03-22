interface Visitable satisfies Iterable<Visitable|Integer>{
    shared formal String description;
    
    void visitChildren(void visit(Visitable v), void f(Visitable|Integer v)) {
        for(child in this){
            if(is Integer child){
                f(child);
            }else if(is Visitable child){
                visit(child);
            }
        }
    }
    
    shared void visitPrefix(void f(Visitable|Integer v)){
        f(this);
        visitChildren(function(Visitable child) => child.visitPrefix(f), f);
    }

    shared void visitPostfix(void f(Visitable|Integer v)){
        visitChildren(function(Visitable child) => child.visitPostfix(f), f);
        f(this);
    }
}

abstract class Tree() satisfies Numeric<Tree> & Visitable { 
    plus(Tree other) => Addition(this, other);
    divided(Tree other) => Division(this, other);
    minus(Tree other) => Subtraction(this, other);
    negativeValue => Negative(this);
    positiveValue => Positive(this);
    times(Tree other) => Multiplication(this, other);
    shared formal Integer evaluate();
}

class Binary(Tree|Integer left, Tree|Integer right, Integer f(Integer a, Integer b), description) extends Tree(){
    shared actual String description;
    
    evaluate() => f(resolve(left), resolve(right));

    string => "(``left`` ``description`` ``right``)";
    
    iterator() => {left, right}.iterator();
}

class Multiplication(Tree|Integer left, Tree|Integer right) extends Binary(left, right, function(Integer a, Integer b) => a * b, "*"){
}

class Addition(Tree|Integer left, Tree|Integer right) extends Binary(left, right, function(Integer a, Integer b) => a + b, "+"){
}

class Subtraction(Tree|Integer left, Tree|Integer right) extends Binary(left, right, function(Integer a, Integer b) => a - b, "-"){
}

class Division(Tree|Integer left, Tree|Integer right) extends Binary(left, right, function(Integer a, Integer b) => a / b, "/"){
}

Integer resolve(Tree|Integer left) {
    switch(left)
    case (is Tree){ return left.evaluate(); }
    case (is Integer){ return left; }
}

class Unary(Tree|Integer node, Integer f(Integer n), description) extends Tree(){
    shared actual String description;
    
    evaluate() => f(resolve(node));

    string => "(``description`` ``node``)";

    iterator() => {node}.iterator();
}

class Negative(Tree|Integer node) extends Unary(node, function(Integer n) => - n, "1-"){
}

class Positive(Tree|Integer node) extends Unary(node, function(Integer n) => + n, "1+"){
}

class Constant(Integer c) extends Tree(){
    evaluate() => c;
    string => c.string;
    iterator() => {}.iterator();
    description => string;
}

void testTree(){
    Tree t = - Constant(1) * Constant(2) + Constant(3) / Constant(4) - + Constant(5);
    print(t);
    print(t.evaluate());
    void visitor(Visitable|Integer elem){
        if(is Integer elem){
            process.write(elem.string);
        }else if(is Visitable elem){
            process.write(elem.description);
        }
        process.write(" ");
    }
    t.visitPrefix(visitor);
    process.writeLine("");
    t.visitPostfix(visitor);
    process.writeLine("");
}