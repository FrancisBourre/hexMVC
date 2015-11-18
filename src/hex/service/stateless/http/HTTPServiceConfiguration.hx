package hex.service.stateless.http;

/**
 * ...
 * @author Francis Bourre
 */
class HTTPServiceConfiguration extends ServiceURLConfiguration
{
	public var requestMethod            : String;
	public var dataFormat               : String;
	public var parameters	            : HTTPServiceParameters;
	public var requestHeaders           : Array<HTTPRequestHeader>;
	public var parameterFactory         : IHTTPServiceParameterFactory;
		
	public function new( url : String = null, method : String = "POST", dataFormat : String = "text", timeout : UInt = 5000 ) 
	{
		super( url, timeout );
		
		this.requestMethod 		= method;
        this.dataFormat 		= dataFormat;
		this.parameters 		= new HTTPServiceParameters();
		this.requestHeaders 	= [];
		this.parameterFactory 	= new DefaultHTTPServiceParameterFactory();
	}
}