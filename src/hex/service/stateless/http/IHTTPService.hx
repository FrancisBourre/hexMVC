package hex.service.stateless.http;

import hex.service.stateless.IAsyncStatelessService;

/**
 * @author Francis Bourre
 */
interface IHTTPService extends IAsyncStatelessService
{
	var url( get, null ) : String;
	var method( get, null ) : String;
	var dataFormat( get, null ) : String;
	var timeout( get, null ) : UInt;
	function addHeader( header : HTTPRequestHeader ) : Void;
}