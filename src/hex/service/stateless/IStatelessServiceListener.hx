package hex.service.stateless;

import hex.service.stateless.StatelessServiceEvent;

/**
 * @author Francis Bourre
 */
interface IStatelessServiceListener 
{
	function onStatelessServiceSuccess( e : StatelessServiceEvent ) : Void;
	function onStatelessServiceError( e : StatelessServiceEvent ) : Void;
	function onStatelessServiceCancel( e : StatelessServiceEvent ) : Void;
}