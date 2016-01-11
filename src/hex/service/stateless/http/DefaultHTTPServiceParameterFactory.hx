package hex.service.stateless.http;

import haxe.Http;
import hex.service.stateless.http.HTTPServiceParameters;

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
		var fieldList 		: Array<String> = Reflect.fields( parameters );
		var fieldListLength : UInt = fieldList.length;
		var parameter 		: String;
		var property 		: Dynamic;
		
		for ( i in 0...fieldListLength ) 
		{
			parameter = fieldList[ i ];
			property = Reflect.getProperty( parameters, parameter );
			
			if ( !Reflect.isFunction( property ) && ( excludedParameters == null || excludedParameters.indexOf( parameter ) == -1 ) )
			{
				httpRequest.addParameter( parameter, property );
			}
		}
		
		return httpRequest;
	}
}