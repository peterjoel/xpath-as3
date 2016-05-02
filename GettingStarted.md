Basic overview of how to use the XPath library

# Executing XPath Statements #

XPath queries are evaluated using the XPathQuery object.

```
// create the XPathQuery instance and parse the path
var myQuery:XPathQuery = new XPathQuery("path/to/evaluate");
// execute the statement on an XML object and get the result
var result:XMLList = myQuery.exec(myXML);
```


# Using namespaces #

To use namespaces, you need to register namespace prefixes with the corresponding URI. This prefix does not need to match the prefix used in the XML document, but must match the prefix that you use in your XPath statements.

```
var myQuery:XPathQuery = new XPathQuery("ns1:path/to/ns2:evaluate");
myQuery.context.namespaces["ns1"] = "http://domain.com/2006/ns1";
myQuery.context.namespaces["ns2"] = "http://domain.com/2007/ns2";
```


## Short-hand Namespace handling ##
There are two more convenient ways of adding the namespaces, by either opening all the namespaces, or automatically declaring the same prefixes as the document.

By setting 'useSourceNamespacePrefixes' to true, any namespace declarations in you the XML document will be automatically declared for the XPath expression, using the same prefixes:

```
var myQuery:XPathQuery = new XPathQuery("ns1:path/to/ns2:evaluate");
myQuery.context.useSourceNamespacePrefixes = true;
```

The easiest (although perhaps least safe) way is with the `openAllNamespaces` property. Although, if there are several namespaces used in the document, there is a chance of name conflicts:

```
// no need for prefixes in this statement
var myQuery:XPathQuery = new XPathQuery("path/to/evaluate");
myQuery.context.openAllNamespaces = true;
```


# The XPathContext object #
The XPathContext object is how you can specify namespaces, variables and custom functions to use in your XPath statements. By creating an instance of XPathContext, you can pass it as an argument to the constructor all of your XPathQueries, so you do not have to set them all up individually.

```
// create the context instance
var context:XPathContext = new XPathContext();
// declare a namespace
context.namespaces["ns1"] = "http://domain.com/2006/ns1";
// define a custom variable
context.variables["myCustomVar"] = true;
// Pass the context to the XPathQuery instance
var myQuery:XPathQuery = new XPathQuery("path/to/evaluate", context);
```

Alternatively, you can customise the default XPathContext, which will then apply to all XPathQueries, as long as you don't also pass one as an argument.

```
// this namespace will be available to all XPathQuery objects
XPathQuery.defaultContext.namespaces["ns1"] = "http://domain.com/2006/ns1";
```

## Extending XPathContext ##

Sometimes it is more convenient to extend XPathContext and use instances of the subclass in your expressions. If you do this, it is important to override the copy() method, which is used internally in sub-expressions.

```
public class MyContext extends XPathContext {
  public function MyContext(){
    // add the custom functions to the functions table
    functions['custom-function'] = customXPathFunction;
  }
  
  // custom XPath functions must receive a reference to the 
  // context as their first argument. You may have any number of other 
  // arguments of any type, and the return value can be any type.
  private function customXPathFunction( context:MyContext, arg1, arg2.. ):String
  { 
     // add code here
  }

  // extensions to MyContext must implement copy()
  public override function copy():XPathContext
  {
     var clone:MyContext = new MyContext();
     // use the utility method to make sure that all the built-in and
     // internal properties are copied
     copyProperties( clone, this );
     return clone;
  }
}
```

```
var path:String = "path/to/evaluate[@att = custom-function(1,2)]";
var myQuery:XPathQuery = new XPathQuery(path, new MyContext());
```