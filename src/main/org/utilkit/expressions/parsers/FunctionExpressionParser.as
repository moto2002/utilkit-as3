/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version 1.1
 * (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 * 
 * The Original Code is the SMILKit library / StyleKit library / UtilKit library.
 * 
 * The Initial Developer of the Original Code is
 * Videojuicer Ltd. (UK Registered Company Number: 05816253).
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 * 	Dan Glegg
 * 	Adam Livesley
 * 
 * ***** END LICENSE BLOCK ******/
package org.utilkit.expressions.parsers
{
	import org.utilkit.util.VectorUtil;

	public class FunctionExpressionParser extends AlgebraicExpressionParser
	{
		public function FunctionExpressionParser()
		{
			super();
		}
		
		public override function calculateValue(value:Object):Object
		{
			if (value is Object && value.hasOwnProperty("name"))
			{
				var functionName:String = value.name;
				var functionArguments:Vector.<Object> = value.arguments;

				// switch, previous + current for the function result
				if (this.configuration.functions.hasItem(functionName))
				{
					var func:Function = this.configuration.functions.getItem(functionName);
					
					return func.apply(null, VectorUtil.vectorToArray(functionArguments));
				}
			}
			
			return super.calculateValue(value);
		}
	}
}
