package hex.service.stateless.http;

import hex.service.stateless.IAsyncStatelessService;

/**
 * @author Francis Bourre
 */
interface IHTTPService<ServiceConfigurationType:ServiceConfiguration> extends IAsyncStatelessService<ServiceConfigurationType>
{
	var url( get, null ) : String;
	var method( get, null ) : HTTPRequestMethod;
	var dataFormat( get, null ) : String;
	var timeout( get, null ) : UInt;
	function addHeader( header : HTTPRequestHeader ) : Void;
	function addHTTPServiceListener( listener : IHTTPServiceListener<ServiceConfigurationType> ) : Void;
	function removeHTTPServiceListener( listener : IHTTPServiceListener<ServiceConfigurationType> ) : Void;
}