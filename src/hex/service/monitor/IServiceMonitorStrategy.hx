package hex.service.monitor;

import hex.error.Exception;

/**
 * @author Francis Bourre
 */

interface IServiceMonitorStrategy<ServiceType:Service> 
{
	function handleError( service : ServiceType, error : Exception ) : Bool;
}