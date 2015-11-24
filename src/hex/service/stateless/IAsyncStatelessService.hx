package hex.service.stateless;

/**
 * @author Francis Bourre
 */

interface IAsyncStatelessService<EventClass:ServiceEvent, ConfigurationClass:ServiceConfiguration> extends IStatelessService<EventClass, ConfigurationClass>
{
	var timeoutDuration( get, set ) : UInt;

    function addAsyncStatelessServiceListener( listener : IAsyncStatelessServiceListener<EventClass> ) : Void;

    function removeAsyncStatelessServiceListener( listener : IAsyncStatelessServiceListener<EventClass> ) : Void;
}