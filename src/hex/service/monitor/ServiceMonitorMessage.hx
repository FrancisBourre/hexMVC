package hex.service.monitor;

import hex.error.Exception;
import hex.event.MessageType;
import hex.service.Service;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceMonitorMessage
{
	static public var ERROR : MessageType = new MessageType( "onServiceMonitorError" );
	static public var FATAL : MessageType = new MessageType( "onFatalServiceMonitorError" );
	
	public var service 	: Service;
	public var error 	: Exception;
	
	public function new<ServiceType:Service>( service : ServiceType, error : Exception )
	{
		this.service 	= service;
		this.error 		= error;
	}
}