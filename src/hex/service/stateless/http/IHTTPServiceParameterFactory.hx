package hex.service.stateless.http;
import haxe.Http;

/**
 * @author Francis Bourre
 */
interface IHTTPServiceParameterFactory 
{
	function setParameters( httpRequest : Http, parameters : HTTPServiceParameters, ?excludedParameters : Array<String> ) : Http;
}