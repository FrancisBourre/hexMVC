package hex.service.monitor;

import hex.error.Exception;

/**
 * ...
 * @author Francis Bourre
 */
interface IServiceMonitor
{
	function handleError<ServiceType:Service>( service : ServiceType, error : Exception ) : Bool;
	function mapStrategy<ServiceType:Service>( serviceClass : Class<ServiceType>, strategy : IServiceMonitorStrategy<ServiceType> ) : Bool;
}