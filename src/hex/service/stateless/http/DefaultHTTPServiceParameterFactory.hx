package hex.service.stateless.http;
import hex.service.stateless.http.HTTPServiceParameters;
import haxe.Http;

/**
 * ...
 * @author Francis Bourre
 */
class DefaultHTTPServiceParameterFactory implements IHTTPServiceParameterFactory
{
	public function new() 
	{
		
	}

	public function setParameters( httpRequest : Http, parameters : HTTPServiceParameters, ?excludedParameters : Array<String> ) : Http 
	{
		var fieldList:Array<String> = Reflect.fields(parameters);
		var l:UInt = fieldList.length;
		var param:String;
		var property:Dynamic;
		
		for (i in 0...l) 
		{
			param = fieldList[i];
			property = Reflect.getProperty( parameters, param );
			if ( !Reflect.isFunction(property) && ( excludedParameters == null || excludedParameters.indexOf(param) == -1 ) )
			{
				httpRequest.addParameter(param, property);
			}
		}
		
		return httpRequest;
	}
}