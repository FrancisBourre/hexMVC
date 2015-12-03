package hex.service.stateful;

import hex.event.CompositeClosureDispatcher;

/**
 * @author Francis Bourre
 */
interface IStatefulService<EventClass:ServiceEvent, ConfigurationClass:ServiceConfiguration> extends IService<EventClass, ConfigurationClass>
{
	var inUse( get, null ) : Bool;
	function getDispatcher() : CompositeClosureDispatcher<EventClass>;
}