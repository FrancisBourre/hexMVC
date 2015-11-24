package hex.service.stateless.http;

import hex.service.stateless.IAsyncStatelessService;

/**
 * @author Francis Bourre
 */
interface IHTTPService<EventClass:ServiceEvent, ConfigurationClass:ServiceConfiguration> extends IAsyncStatelessService<EventClass, ConfigurationClass>
{
	var url( get, null ) : String;
	var method( get, null ) : HTTPRequestMethod;
	var dataFormat( get, null ) : String;
	var timeout( get, null ) : UInt;
	function addHeader( header : HTTPRequestHeader ) : Void;
}