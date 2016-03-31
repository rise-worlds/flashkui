package cn.flashk.utils
{
	import flash.filters.GlowFilter;

	public class Custom
	{
		public static var isCallFunctionsUseTryCatch:Boolean = false;
		public static var textBlackGlowFilters:Array = [new GlowFilter(0x0,1,2,2,5,1)];
		
		public static function deleteInArray(deleteObj:*,array:Array):void
		{
			var len:int = array.length;
			for(var i:int=0;i<len;i++){
				if(array[i] == deleteObj){
					array.splice(i,1);
					break;
				}
			}
		}
		
		public static function deleteInVector(deleteObj:*,vector:*):void
		{
			var len:int = vector.length;
			for(var i:int=0;i<len;i++){
				if(vector[i] == deleteObj){
					vector.splice(i,1);
					break;
				}
			}
		}
		
		public static function callFunctions(functions:Vector.<Function>,...args):void
		{
			var len:int = functions.length;
			if(isCallFunctionsUseTryCatch == false){
				for(var i:int=0;i<len;i++){
					functions[i].apply(null,args);
				}
			}else{
				for(i=0;i<len;i++){
					try{
						functions[i].apply(null,args);
					} 
					catch(error:Error) {
					}
				}
			}
		}
		
	}
}