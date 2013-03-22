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
        visitChildren(function(Visitable child) child.visitPrefix(f), f);
    }

    shared void visitPostfix(void f(Visitable|Integer v)){
        visitChildren(function(Visitable child) child.visitPostfix(f), f);
        f(this);
    }
}

abstract class Tree() satisfies Numeric<Tree> & Visitable { 
    shared actual Tree plus(Tree other) {
        return Addition(this, other);
    }
    shared actual Tree divided(Tree other) {
        return Division(this, other);
    }
    shared actual Tree minus(Tree other) {
        return Subtraction(this, other);
    }
    shared actual Tree negativeValue {
        return Negative(this);
    }
    shared actual Tree positiveValue {
        return Positive(this);
    }
    shared actual Tree times(Tree other) {
        return Multiplication(this, other);
    }
    shared formal Integer evaluate();
}

class Binary(Tree|Integer left, Tree|Integer right, Integer f(Integer a, Integer b), description) extends Tree(){
    shared actual String description;
    
    shared actual Integer evaluate() {
        return f(resolve(left), resolve(right));
    }
    shared actual default String string = "(" left " " description " " right ")";
    
    shared actual Iterator<Visitable|Integer> iterator {
        return {left, right}.iterator;
    }
}

class Multiplication(Tree|Integer left, Tree|Integer right) extends Binary(left, right, function(Integer a, Integer b) a * b, "*"){
}

class Addition(Tree|Integer left, Tree|Integer right) extends Binary(left, right, function(Integer a, Integer b) a + b, "+"){
}

class Subtraction(Tree|Integer left, Tree|Integer right) extends Binary(left, right, function(Integer a, Integer b) a - b, "-"){
}

class Division(Tree|Integer left, Tree|Integer right) extends Binary(left, right, function(Integer a, Integer b) a / b, "/"){
}

Integer resolve(Tree|Integer left) {
    switch(left)
            case (is Tree){ return left.evaluate(); }
    case (is Integer){ return left; }
}

class Unary(Tree|Integer node, Integer f(Integer n), description) extends Tree(){
    shared actual String description;
    
    shared actual Integer evaluate() {
        return f(resolve(node));
    }
    shared actual String string = "(" description " " node ")";

    shared actual Iterator<Visitable|Integer> iterator {
        return {node}.iterator;
    }
}

class Negative(Tree|Integer node) extends Unary(node, function(Integer n) - n, "1-"){
}

class Positive(Tree|Integer node) extends Unary(node, function(Integer n) + n, "1+"){
}

class Constant(Integer c) extends Tree(){
    shared actual Integer evaluate() {
        return c;
    }
    shared actual String string = c.string;
    shared actual Iterator<Visitable|Integer> iterator = {}.iterator;
    shared actual String description = string;
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