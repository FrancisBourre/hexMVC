package hex.service.stateless;

/**
 * @author Francis Bourre
 */
interface IAsyncStatelessServiceListener extends IStatelessServiceListener
{
	function onAsyncStatelessServiceTimeout( event : StatelessServiceEvent ) : Void;
}