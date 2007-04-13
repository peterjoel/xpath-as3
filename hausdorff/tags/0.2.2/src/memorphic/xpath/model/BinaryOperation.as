package memorphic.xpath.model
{
	import flash.utils.Dictionary;
	
	
	// TODO: type safety and range checking
	
	public class BinaryOperation implements IExpression
	{
		
		
		public static const OR:String = "or";
		public static const AND:String = "and";
		public static const EQUALS:String = "=";
		public static const NOT_EQUALS:String = "!=";
		public static const MULTIPLY:String = "*";
		public static const DIVIDE:String = "/";
		public static const MODULO:String = "mod";
		public static const ADD:String = "+";
		public static const SUBTRACT:String = "-";
		public static const LESS_THAN:String = "<"; 
		public static const GREATER_THAN:String = ">"; 
		public static const LESS_THAN_OR_EQUAL:String = "<=";
		public static const GREATER_THAN_OR_EQUAL:String = ">=";  
		public static const UNION:String = "|";  
		
		
		public var leftArg:IExpression;
		public var rightArg:IExpression;
	
		private var op:Function;
			// for debug only
		private var opName:String;
		

		public function BinaryOperation(a:IExpression, b:IExpression, operation:String)
		{
			leftArg = a;
			rightArg = b;
			opName = operation;
			
			switch(operation){
			case OR: 					op = opOR; 			break;
			case AND: 					op = opAND; 		break;
			case EQUALS: 				op = opEq; 			break;
			case NOT_EQUALS: 			op = opNotEq;		break;
			case MULTIPLY:				op = opMult;		break;
			case DIVIDE:				op = opDiv;			break;
			case MODULO:				op = opMod;			break;
			case ADD: 					op = opAdd; 		break;
			case SUBTRACT:				op = opSubtract;	break;
			case LESS_THAN:				op = opLT;			break;
			case LESS_THAN_OR_EQUAL: 	op = opLTEq;		break;
			case GREATER_THAN:			op = opGT;			break;
			case GREATER_THAN_OR_EQUAL:	op = opGTEq;		break;
			case UNION:					op = opUnion;		break;
			// 
			}
		}
		
		
		public function exec(context:XPathContext):Object
		{
			return op(context);
		}
		
		
		private function opOR(context:XPathContext):Boolean
		{
			return TypeConversions.toBoolean(leftArg.exec(context))
								|| TypeConversions.toBoolean(rightArg.exec(context));
		}
		
		
		private function opAND(context:XPathContext):Boolean
		{

			return (TypeConversions.toBoolean(leftArg.exec(context))
								&& TypeConversions.toBoolean(rightArg.exec(context)));
		}
		
		
		private function opEq(context:XPathContext):Boolean
		{
			return (TypeConversions.toString(leftArg.exec(context))
								== TypeConversions.toString(rightArg.exec(context)));
		}
		private function opNotEq(context:XPathContext):Boolean
		{
			return !opEq(context);
		}
		
		private function opAdd(context:XPathContext):Number
		{
			return (TypeConversions.toNumber(leftArg.exec(context))
								+ TypeConversions.toNumber(rightArg.exec(context)));
		}
		
		private function opSubtract(context:XPathContext):Number
		{
			return (TypeConversions.toNumber(leftArg.exec(context))
								- TypeConversions.toNumber(rightArg.exec(context)));
		}
		
		private function opMult(context:XPathContext):Number
		{
			return (TypeConversions.toNumber(leftArg.exec(context))
								* TypeConversions.toNumber(rightArg.exec(context)));
		}
		
		private function opDiv(context:XPathContext):Number
		{
			return (TypeConversions.toNumber(leftArg.exec(context))
								/ TypeConversions.toNumber(rightArg.exec(context)));
		}
		
		private function opMod(context:XPathContext):Number
		{
			return (TypeConversions.toNumber(leftArg.exec(context))
								% TypeConversions.toNumber(rightArg.exec(context)));
		}
		
		private function opLT(context:XPathContext):Boolean
		{
			return (TypeConversions.toNumber(leftArg.exec(context))
								< TypeConversions.toNumber(rightArg.exec(context)));
		}
		
		private function opGT(context:XPathContext):Boolean
		{
			return (TypeConversions.toNumber(leftArg.exec(context))
								> TypeConversions.toNumber(rightArg.exec(context)));
		}
		
		private function opLTEq(context:XPathContext):Boolean
		{
			return (TypeConversions.toNumber(leftArg.exec(context))
								<= TypeConversions.toNumber(rightArg.exec(context)));
		}
		
		private function opGTEq(context:XPathContext):Boolean
		{
			return (TypeConversions.toNumber(leftArg.exec(context))
								>= TypeConversions.toNumber(rightArg.exec(context)));
		}
		
		private function opUnion(context:XPathContext):XMLList
		{
			return XMLList(leftArg.exec(context)) + XMLList(rightArg.exec(context));
		}
		
	}
}