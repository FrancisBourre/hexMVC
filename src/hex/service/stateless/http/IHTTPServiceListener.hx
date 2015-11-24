package hex.service.stateless.http;

/**
 * @author Francis Bourre
 */

interface IHTTPServiceListener<EventClass> 
{
	function onServiceComplete( e : EventClass ) : Void;
	function onServiceFail( e : EventClass ) : Void;
	function onServiceCancel( e : EventClass ) : Void;
	function onServiceTimeout( e : EventClass ) : Void;
} 