shared interface Visitor{
    shared default void openTag(String name){}
    shared default void closeTag(String name){}
    shared default void text(String text){}
    shared void tag(String name){
        openTag(name);
        closeTag(name);
    }
}

shared interface Visitable{
    shared formal void visit(Visitor visitor);
    shared default void visitAroundText(Visitor visitor, String name, String text){
        visitor.openTag(name);
        visitor.text(text);
        visitor.closeTag(name);
    }
    shared default void visitAroundTags(Visitor visitor, String name, {Tag|String*} tags){
        visitor.openTag(name);
        for(tag in tags){
            if(is Tag tag){
                tag.visit(visitor);
            }else if(is String text = tag){
                visitor.text(text);
            }
        }
        visitor.closeTag(name);
    }
}

class PrintVisitor() satisfies Visitor {
    StringBuilder builder = StringBuilder();
    variable Integer level = 0;
    void indent() {
        builder.append("\n");
        for(i in 0:level){
            builder.append(" ");
        }
    }
    shared actual void openTag(String name){
        indent();
        builder.append("<").append(name).append(">");
        level++;
    }
    shared actual void closeTag(String name){
        level--;
        indent();
        builder.append("</").append(name).append(">");
    }
    shared actual void text(String text){
        indent();
        builder.append(text);
    }
    shared actual String string {
        return builder.string;
    }
}
