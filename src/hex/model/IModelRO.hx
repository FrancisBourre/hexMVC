package hex.model;

import hex.model.IModelListener;

/**
 * @author duke
 */
interface IModelRO<ListenerType : IModelListener>
{
	function addListener( listener : ListenerType ) : Void;
	
	function removeListener( listener : ListenerType ) : Void;
}