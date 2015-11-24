package hex.service.stateless;

/**
 * @author Francis Bourre
 */
interface IAsyncStatelessServiceListener<EventClass> extends IStatelessServiceListener<EventClass>
{
	function onServiceTimeout( event : EventClass ) : Void;
}