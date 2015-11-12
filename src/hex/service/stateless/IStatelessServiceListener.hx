package hex.service.stateless;

import hex.service.stateless.StatelessServiceEvent;

/**
 * @author Francis Bourre
 */
interface IStatelessServiceListener 
{
	function onStatelessServiceComplete( e : StatelessServiceEvent ) : Void;
	function onStatelessServiceFail( e : StatelessServiceEvent ) : Void;
	function onStatelessServiceCancel( e : StatelessServiceEvent ) : Void;
}