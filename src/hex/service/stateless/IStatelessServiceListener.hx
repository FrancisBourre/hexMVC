package hex.service.stateless;

import hex.service.stateless.StatelessServiceEvent;

/**
 * @author Francis Bourre
 */
interface IStatelessServiceListener<EventClass> 
{
	function onStatelessServiceComplete( e : EventClass ) : Void;
	function onStatelessServiceFail( e : EventClass ) : Void;
	function onStatelessServiceCancel( e : EventClass ) : Void;
}