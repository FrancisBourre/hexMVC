package hex.service.stateless;

/**
 * @author Francis Bourre
 */
interface IStatelessServiceListener<EventClass> 
{
	function onServiceComplete( e : EventClass ) : Void;
	function onServiceFail( e : EventClass ) : Void;
	function onServiceCancel( e : EventClass ) : Void;
}