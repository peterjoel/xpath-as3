/*
	Copyright (c) 2007 Memorphic Ltd. All rights reserved.
	
	Redistribution and use in source and binary forms, with or without 
	modification, are permitted provided that the following conditions 
	are met:
	
		* Redistributions of source code must retain the above copyright 
		notice, this list of conditions and the following disclaimer.
	    	
	    * Redistributions in binary form must reproduce the above 
	    copyright notice, this list of conditions and the following 
	    disclaimer in the documentation and/or other materials provided 
	    with the distribution.
	    	
	    * Neither the name of MEMORPHIC LTD nor the names of its 
	    contributors may be used to endorse or promote products derived 
	    from this software without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
	A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
	OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
	LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
	DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
	THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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