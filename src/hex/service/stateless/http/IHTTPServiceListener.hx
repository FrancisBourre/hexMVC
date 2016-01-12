package hex.service.stateless.http;

/**
 * @author Francis Bourre
 */

interface IHTTPServiceListener
{
	function onServiceComplete( service : HTTPService ) : Void;
	function onServiceFail( service : HTTPService ) : Void;
	function onServiceCancel( service : HTTPService ) : Void;
	function onServiceTimeout( service : HTTPService ) : Void;
} 