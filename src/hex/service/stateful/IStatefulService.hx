package hex.service.stateful;

import hex.event.CompositeDispatcher;

/**
 * @author Francis Bourre
 */
interface IStatefulService<ServiceConfigurationType:ServiceConfiguration> extends IService<ServiceConfigurationType>
{
	function inUse():Bool;
	function getDispatcher() : CompositeDispatcher;
}