shared interface Tag satisfies Visitable {}
shared interface BlockTag satisfies Tag{}
shared interface InlineTag satisfies Tag{}


shared class Html(head = null, body = null) satisfies Tag {
    shared Head? head;
    shared Body? body;
    
    shared actual void visit(Visitor visitor){
        visitor.openTag("html");
        if(exists head){
            head.visit(visitor);
        }
        if(exists body){
            body.visit(visitor);
        }
        visitor.closeTag("html");
    }
    
    shared actual String string {
        value pv = PrintVisitor();
        visit(pv);
        return pv.string;
    }
}

shared class Head(title = null) satisfies Tag {
    shared String? title;
    shared actual void visit(Visitor visitor) {
        if(exists title){
            visitor.openTag("head");
            visitAroundText(visitor, "title", title);
            visitor.closeTag("head");
        }else{
            visitor.tag("head");
        }
    }
}

shared abstract class Container<TagType>(String name, TagType|String... initialTags) satisfies Tag 
    given TagType satisfies Tag {
    
    shared Iterable<TagType|String> tags = initialTags;

    shared actual void visit(Visitor visitor) {
        visitAroundTags(visitor, name, tags);
    }
}

shared class Body(Tag|String... initialTags) extends Container<Tag>("body", initialTags...) {}

shared abstract class Block(String name, Tag|String... initialTags) extends Container<Tag>(name, initialTags...) satisfies Tag {}

shared class P(Tag|String... tags) extends Block("p", tags...){}

shared abstract class Inline(String name, InlineTag|String... initialTags) extends Container<InlineTag>(name, initialTags...) satisfies InlineTag {}

shared class B(InlineTag|String... tags) extends Inline("b", tags...){}
