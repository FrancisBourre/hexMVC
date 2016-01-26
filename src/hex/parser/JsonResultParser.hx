package hex.parser;

import haxe.Json;
import hex.data.IParser;
import hex.service.ServiceResultVO;

/**
 * ...
 * @author duke
 */
class JsonResultParser<DataType> implements IParser
{
	public var dataProperty:String = "data";

	public function new() 
	{
		
	}
	
	public function parse( serializedContent : Dynamic, target : Dynamic = null) : Dynamic 
	{
		var jsonResult : Dynamic;
		
		try
		{
			jsonResult = Json.parse(serializedContent);
		}
		catch (error:Dynamic)
		{
			jsonResult = { };
			Reflect.setProperty( jsonResult, this.dataProperty, { } );
		}
		
		var serviceResultVO : ServiceResultVO<DataType> = new ServiceResultVO<DataType>();
		
		serviceResultVO.success = jsonResult.success == true ? true : false;
		serviceResultVO.errorCode = Std.parseInt(jsonResult.errorCode);
		
		serviceResultVO.data = this._parseData( Reflect.getProperty( jsonResult, this.dataProperty ) );
		
		return serviceResultVO;
	}
	
	function _parseData( data : Dynamic ) : DataType
	{
		return data;
	}
}