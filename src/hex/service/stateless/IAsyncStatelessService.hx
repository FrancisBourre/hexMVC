package hex.service.stateless;

/**
 * @author Francis Bourre
 */

interface IAsyncStatelessService<ServiceConfigurationType:ServiceConfiguration> extends IStatelessService<ServiceConfigurationType>
{
	var timeoutDuration( get, set ) : UInt;
}