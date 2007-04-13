package memorphic.xpath.parser
{
	import flash.utils.Dictionary;
	
	import memorphic.parser.Token;
	import memorphic.parser.TreeWalker;
	import memorphic.xpath.model.Axis;
	import memorphic.xpath.model.AxisNames;
	import memorphic.xpath.model.BinaryOperation;
	import memorphic.xpath.model.FilterExpr;
	import memorphic.xpath.model.FunctionCall;
	import memorphic.xpath.model.IExpression;
	import memorphic.xpath.model.INodeTest;
	import memorphic.xpath.model.LocationPath;
	import memorphic.xpath.model.NameTest;
	import memorphic.xpath.model.NodeTypeTest;
	import memorphic.xpath.model.NodeTypes;
	import memorphic.xpath.model.PathExpr;
	import memorphic.xpath.model.Predicate;
	import memorphic.xpath.model.PrimitiveValue;
	import memorphic.xpath.model.Step;
	import memorphic.xpath.model.VariableReference;
	import memorphic.xpath.model.PredicateList;

	public class XPathParser
	{

		internal const rule:Namespace = XPathSyntaxTree.rule;
		
		public var tokenizer:XPathTokenizer;
		public var syntaxTree:XPathSyntaxTree;
		
		private var modelMap:Dictionary;
		
		private var treeWalker:TreeWalker;
		
		private var currentToken:Token;
		
		private var treeRoot:Token;
		
/*
		[Embed(source="xpathStructure.xml", mimeType="application/octet-stream")]
		private static const XPATH_LANG_RAW:Class;
		private static const XPATH_LANG:XML = parseRawXML(new XPATH_LANG_RAW());

		private static function parseRawXML(data:ByteArray):XML{
			return new XML(data.readUTFBytes(data.length));

		}
*/

		public function XPathParser(){
		}


		public function parseXPath(source:String):LocationPath
		{
			tokenizer = new XPathTokenizer();
			syntaxTree = new XPathSyntaxTree(tokenizer);
			modelMap = new Dictionary();
			syntaxTree.reset();
			tokenizer.rawData = source;
			syntaxTree.rule::LocationPath();
			treeRoot = syntaxTree.getTree();
			treeWalker = new TreeWalker(treeRoot);
			walkTree();
			var path:LocationPath = LocationPath( getModelForToken(treeRoot) );
			cleanUp();
			return path;
		}
		
		
	
		
		
		private function cleanUp():void
		{
			tokenizer = null;
			syntaxTree = null;
			modelMap = null;
			treeWalker = null;
			currentToken = null;
			treeRoot = null;
		}
		
		
		
		private function eachToken():void
		{
			switch(currentToken.tokenType){
			case XPathSyntaxTree.LOCATION_PATH:
				parseLocationPath();
				break;
			case XPathSyntaxTree.RELATIVE_LOCATION_PATH:
				parseRelativeLocationPath();
				break;
			case XPathSyntaxTree.ABSOLUTE_LOCATION_PATH:
				parseAbsoluteLocationPath();
				break;
			case XPathSyntaxTree.ABBREVIATED_ABSOLUTE_LOCATION_PATH:
				parseAbbreviatedAbsoluteLocationPath();
				break;
			case XPathSyntaxTree.STEP:
				parseStep();
				break;
			case XPathToken.NODE_TYPE:
				associateTokenWithModel(new NodeTypeTest(currentToken.value));
				break;
			case XPathSyntaxTree.NODE_TEST:
				condenseToken();
				break;
			case XPathToken.NAME_TEST:
				parseNameTest();
				break;
			case XPathToken.AXIS_NAME:
				associateTokenWithModel(currentToken.value);
				break
			case XPathSyntaxTree.ABBREVIATED_AXIS_SPECIFIER:
				parseAbbreviatedAxisSpecifier();
				break;
			case XPathSyntaxTree.AXIS_SPECIFIER:
				associateTokenWithModel(new Axis(getModelForToken(currentToken.children[0]) as String));
				break;
			case XPathToken.OPERATOR:
				parseOperator();
				break;
			case XPathSyntaxTree.EXPR:
			case XPathSyntaxTree.PRIMARY_EXPR:
				condenseToken();
				break;
			case XPathToken.MULTIPLY_OPERATOR:
				// ignore it. MULTIPLICATIVE_EXPR will find it as a child
				break;
			case XPathSyntaxTree.OR_EXPR:
			case XPathSyntaxTree.AND_EXPR:
			case XPathSyntaxTree.EQUALITY_EXP:
			case XPathSyntaxTree.RELATIONAL_EXP:
			case XPathSyntaxTree.MULTIPLICATIVE_EXPR:
			case XPathSyntaxTree.ADDITIVE_EXPR:
			case XPathSyntaxTree.UNION_EXPR:
				parseBinaryOperation();
				break;
			case XPathSyntaxTree.UNARY_EXPR:
				parseUnaryExpr();
				break;
			case XPathToken.LITERAL:
				associateTokenWithModel(new PrimitiveValue(currentToken.value));
				break;
			case XPathToken.NUMBER:
				associateTokenWithModel(new PrimitiveValue(parseFloat(currentToken.value)));
				break;
			case XPathSyntaxTree.FILTER_EXPR:
				parseFilterExpr();
				break;
			case XPathSyntaxTree.PATH_EXPR:
				parsePathExpr();
				break;
			case XPathSyntaxTree.PREDICATE:
				parsePredicate();
				break;
			case XPathSyntaxTree.PREDICATE_EXPR:
				condenseToken();
				break;
			case XPathSyntaxTree.FUNCTION_CALL:
				parseFunctionCall();
				break;
			case XPathToken.FUNCTION_NAME:
				associateTokenWithModel(currentToken.value);
				break;
			case XPathSyntaxTree.ARGUMENT:
				parseFunctionArgument();
				break;
			case XPathSyntaxTree.ABBREVIATED_STEP:
				parseAbbreviatedStep();
				break;
			case XPathToken._EXPR_TOKEN_MISC:
				parseMiscToken();
				break;
			case XPathToken.VARIABLE_REFERENCE:
				associateTokenWithModel(new VariableReference(QNameToken(currentToken).prefix, QNameToken(currentToken).localName));
				break;
			default:
				// ignore other tokens (For now!!!)
				throw new SyntaxError(currentToken.tokenType + " is not yet supported");
			}	
		}
		

		
		private function walkTree():void
		{
			do {
				currentToken = treeWalker.nextItem();
				// TODO: replace this with a (hopefully faster) function look-up
				eachToken();
			}while(treeRoot != currentToken);
		}
		
		
		
		private function parseLocationPath():void
		{
			associateTokenWithModel(getModelForToken(currentToken.children[0]));
		}
		
		
		private function parseAbsoluteLocationPath():void
		{
			var path:LocationPath = LocationPath(getModelForToken(currentToken.children[0]));
			path.absolute = true;
			associateTokenWithModel(path);
		}
		
		
		private function parseAbbreviatedAbsoluteLocationPath():void
		{
			var step:Step = Step(getModelForToken(currentToken.children[0]));
			var path:LocationPath = LocationPath(getModelForToken(currentToken.children[1]));
			path.absolute = true;
			path.steps.unshift(step);
			associateTokenWithModel(path);
		}
		
		private function parseRelativeLocationPath():void
		{
			var path:LocationPath = new LocationPath(false);
			var children:Array = currentToken.children;
			var n:int = children.length;
			for(var i:int=0; i<n; i++){
				path.steps.push(Step(getModelForToken(children[i])));
			}	
			associateTokenWithModel(path);
		}
		

		
		private function parseStep():void
		{
			var children:Array = currentToken.children;
			if(children.length == 1){
				// then it's an abbreviated step, which we have already parsed
				associateTokenWithModel(getModelForToken(children[0]));
			}else{
				var axis:Axis = getModelForToken(children[0]) as Axis;
				var nodeTest:INodeTest = getModelForToken(children[1]) as INodeTest;
		/*		var pred:Predicate;
				var predicates:Array = new Array();
				var n:int = children.length;
				for(var i:int=2; i<n; i++){
					pred = getModelForToken(children[i]) as Predicate;
					predicates.push(pred);
				}
				*/
				var step:Step = new Step(axis, nodeTest, collectPredicates(children.slice(2)));
				associateTokenWithModel(step);
			}
		}
		
		private function collectPredicates(children:Array):PredicateList
		{
			var pred:Predicate;
			var predicates:Array = new Array();
			var n:int = children.length;
			for(var i:int=0; i<n; i++){
				pred = Predicate(getModelForToken(children[i]));
				predicates.push(pred);
			}
			if(predicates.length > 0){
				return new PredicateList(predicates);
			}else{
				return null;
			}
		}
		
		
		private function parseAbbreviatedStep():void
		{
			var abbr:String = currentToken.children[0].value;
			if(abbr == ".."){
				associateTokenWithModel(new Step(new Axis(AxisNames.PARENT), new NodeTypeTest(NodeTypes.NODE), null));
			}else if(abbr == "."){
				associateTokenWithModel(new Step(new Axis(AxisNames.SELF), new NodeTypeTest(NodeTypes.NODE), null));
			}else{
				throw new Error("this shouldn't happen");
			}
		}
		
		
		// nothing realy happens here... it's for debuggin really...
		private function parseMiscToken():void
		{
			switch(currentToken.value){
			case "..":
			case ".":
			case "@":
				break;
			default:
				throw new Error("this token isn't implemented: " + currentToken.tokenType + " " + currentToken.value);
			}
		}
		
		
		
				
		private function parsePredicate():void
		{
			var expr:IExpression = getModelForToken(currentToken.children[0]) as IExpression;
			associateTokenWithModel(new Predicate(expr));
		}
		

		
		private function parsePathExpr():void
		{
			var children:Array = currentToken.children;
			var n:int = children.length;
			if(n==1){
				// this is just a single LocationPath or FilterExpr
				condenseToken();
				return;
			}
			// if n==2 then it's a FilterExpr followed by a LocationPath
			var filterExpr:FilterExpr = getModelForToken(children[0]) as FilterExpr;
			var path:LocationPath = getModelForToken(children[n-1]) as LocationPath;
			if(n==3){
				// if n==2 then it's a FilterExpr followed by a "//" step, then a LocationPath
				// so just add the step on to the start of the path
				var step:Step = getModelForToken(children[1]) as Step;
				path.steps.unshift(step);
			}
			associateTokenWithModel(new PathExpr(filterExpr, path));
		}
		
		
		
		private function parseFilterExpr():void
		{
			var children:Array = currentToken.children;
			if(children.length == 1){
				// just treat a FilterExpression as normal primary expression if there are no predicates
				condenseToken();
			}else{
				var primaryExpr:IExpression = getModelForToken(children[0]) as IExpression;
				associateTokenWithModel(new FilterExpr(primaryExpr, collectPredicates(children.splice(1))));
			}
		}
		
		private function parseFunctionArgument():void
		{
			// argument is just an expression, so use the thing we parsed already
			associateTokenWithModel(getModelForToken(currentToken.children[0]));
		}
		
		private function parseFunctionCall():void
		{
			var children:Array = currentToken.children;
			var funcName:String = getModelForToken(children[0]) as String;
			var funcArgs:Array = new Array();
			var n:int = children.length;
			for(var i:int=1; i<n; i++){
				funcArgs.push(getModelForToken(children[i]));
			}
			associateTokenWithModel(new FunctionCall(funcName, funcArgs));
		}
		
		
		
		
		private function parseNameTest():void
		{
			if(currentToken is QNameToken){
				var qName:QNameToken = QNameToken(currentToken); 
				associateTokenWithModel(new NameTest(qName.prefix, qName.localName));
			}else{
				// should be * at this point
				associateTokenWithModel(new NameTest(qName.prefix, qName.localName));
			}
		}
		
		
		
		private function parseBinaryOperation():void
		{
			if(condenseToken()){
				return;
			}
			var leftArg:IExpression = getModelForToken(currentToken.children[0]) as IExpression;
			var rightArg:IExpression = getModelForToken(currentToken.children[2]) as IExpression;
			var operator:String = currentToken.children[1].value;
			associateTokenWithModel(new BinaryOperation(leftArg, rightArg, operator));
		}
		
		
		private function parseUnaryExpr():void
		{
			if(condenseToken()){
				return;
			}
			// expand "-Expr" to "0 - Expr"
			var leftArg:IExpression = new PrimitiveValue(0);
			var rightArg:IExpression = getModelForToken(currentToken.children[1]) as IExpression;
			var op:String = currentToken.children[0].value;
			associateTokenWithModel(new BinaryOperation(leftArg, rightArg, op));
		}
		
		
		private function parseAbbreviatedAxisSpecifier():void
		{
			if(currentToken.value == "@"){
				associateTokenWithModel(AxisNames.ATTRIBUTE);
			}else{
				associateTokenWithModel(AxisNames.CHILD);
			}
		}
		
	
		
		
		private function parseOperator():void
		{
			// n.b. We only need to deal with "//" here. 
			// "/" is removed by the Syntax Tree and all other operators are binary, have no special meaning 
			// apart from their token value, and thus are dealt with as child tokens in parseBinaryOperation().
			if(currentToken.value == "//"){
				// "//" is equivalent to "/descendant-or-self::node()/"
				associateTokenWithModel(createStepForAbbrStep());
			}
		}
		
		
		private function createStepForAbbrStep():Step
		{
			// TODO: test if I can just re-use the same instance each time
			return new Step(new Axis(AxisNames.DESCENDANT_OR_SELF), new NodeTypeTest(NodeTypes.NODE), null);
		}
		
		
		protected function condenseToken():Boolean
		{
			if(currentToken.children.length == 1){
				associateTokenWithModel(getModelForToken(currentToken.children[0]));
				return true;
			}else return false;
		}
		
		protected function getModelForToken(token:Token):Object
		{
			return modelMap[token];
		}
		protected function associateTokenWithModel(model:Object):void
		{
			modelMap[currentToken] = model;
		}
	}
}