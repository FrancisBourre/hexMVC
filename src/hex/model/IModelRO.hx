package hex.model;

/**
 * @author duke
 */
@:generic
interface IModelRO<ListenerType:{}>
{
	function addListener( listener : ListenerType ) : Void;
	function removeListener( listener : ListenerType ) : Void;
}