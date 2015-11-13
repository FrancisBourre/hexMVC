package hex.service.stateless;

/**
 * @author Francis Bourre
 */

interface IAsyncStatelessService extends IStatelessService
{
	var timeoutDuration( get, set ) : UInt;

    function addAsyncStatelessServiceListener( listener : IAsyncStatelessServiceListener ) : Void;

    function removeAsyncStatelessServiceListener( listener : IAsyncStatelessServiceListener ) : Void;
}