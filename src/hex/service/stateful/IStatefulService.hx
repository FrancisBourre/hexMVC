package hex.service.stateful;

import hex.event.CompositeDispatcher;

/**
 * @author Francis Bourre
 */
interface IStatefulService<ServiceConfigurationType:ServiceConfiguration> extends IService<ServiceConfigurationType>
{
	var inUse( get, null ) : Bool;
	function getDispatcher() : CompositeDispatcher;
}