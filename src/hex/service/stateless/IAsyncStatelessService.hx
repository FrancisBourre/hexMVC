package hex.service.stateless;

/**
 * @author Francis Bourre
 */

interface IAsyncStatelessService<EventClass:ServiceEvent> extends IStatelessService<EventClass>
{
	var timeoutDuration( get, set ) : UInt;

    function addAsyncStatelessServiceListener( listener : IAsyncStatelessServiceListener<EventClass> ) : Void;

    function removeAsyncStatelessServiceListener( listener : IAsyncStatelessServiceListener<EventClass> ) : Void;
}