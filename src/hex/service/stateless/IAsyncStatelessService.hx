package hex.service.stateless;

/**
 * @author Francis Bourre
 */

interface IAsyncStatelessService extends IStatelessService
{
	var timeoutDuration( get, set ) : UInt;

    function addAsyncServiceListener( listener : IAsyncStatelessServiceListener ) : Void;

    function removeAsyncServiceListener( listener : IAsyncStatelessServiceListener ) : Void;
}