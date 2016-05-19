package hex.parser;

import haxe.Json;
import hex.data.IParser;
import hex.service.ServiceResultVO;

/**
 * ...
 * @author duke
 */
class JsonResultParser<ResultType> implements IParser<ResultType>
{
	public var dataProperty:String = "data";

	public function new() 
	{
		
	}
	
	public function parse( serializedContent : Dynamic, target : Dynamic = null) : ResultType 
	{
		var jsonResult : Dynamic;
		
		try
		{
			jsonResult = Json.parse( serializedContent );
		}
		catch (error:Dynamic)
		{
			jsonResult = { };
			Reflect.setProperty( jsonResult, this.dataProperty, { } );
		}
		
		var serviceResultVO = new ServiceResultVO<ResultType>();
		
		serviceResultVO.success = jsonResult.success == true ? true : false;
		serviceResultVO.errorCode = Std.parseInt(jsonResult.errorCode);
		
		serviceResultVO.data = Reflect.getProperty( jsonResult, this.dataProperty );
		
		return serviceResultVO;
	}
}