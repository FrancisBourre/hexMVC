package hex.model;

/**
 * @author Francis Bourre
 */
interface IModelDispatcher<ListenerType:IModelListener>
{
	function addListener( listener : ListenerType ) : Bool;

	function removeListener( listener : ListenerType ) : Bool;
}