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
	
	
	public function parse(serializedContent:Dynamic, target:Dynamic = null):Dynamic 
	{
		var jsonResult:Dynamic = Json.parse(serializedContent);
		
		var serviceResultVO:ServiceResultVO<DataType> = new ServiceResultVO<DataType>();
		
		serviceResultVO.success = jsonResult.success;
		serviceResultVO.errorCode = jsonResult.errorCode;
		
		serviceResultVO.data = this._parseData( Reflect.getProperty(jsonResult, this.dataProperty) );
		
		return serviceResultVO;
	}
	
	private function _parseData( data:Dynamic ) : DataType
	{
		return data;
	}
	
}