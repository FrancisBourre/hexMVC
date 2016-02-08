package hex.service.stateless.http;

/**
 * @author Francis Bourre
 */
interface IHTTPServiceErrorHelperListener<ServiceType> 
{
	function onReleaseHelper( service : ServiceType ) : Void;
}