package hex.service.stateful;

import hex.event.CompositeDispatcher;

/**
 * @author Francis Bourre
 */
interface IStatefulService extends IService
{
	var inUse( get, null ) : Bool;
	function getDispatcher() : CompositeDispatcher;
}