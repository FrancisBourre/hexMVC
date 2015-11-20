package hex.service.stateless;

/**
 * @author Francis Bourre
 */
interface IAsyncStatelessServiceListener<EventClass> extends IStatelessServiceListener<EventClass>
{
	function onAsyncStatelessServiceTimeout( event : EventClass ) : Void;
}