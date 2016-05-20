package hex.model;

import hex.model.IModelDispatcher;
import hex.model.IModelListener;

/**
 * ...
 * @author duke
 */
class Model<DispatcherType:IModelDispatcher<ListenerType>, ListenerType:IModelListener> implements IModelRO<ListenerType>
{
	public var dispatcher : DispatcherType;

	public function new() 
	{
		//this.dispatcher = _createDispatcher();
	}
	
	public function addListener( listener : ListenerType ) : Void
	{
		this.dispatcher.addListener( listener );
	}

	public function removeListener( listener : ListenerType ) : Void
	{
		this.dispatcher.removeListener( listener );
	}
	
	@:generic
	function _createDispatcher<DispatcherType:IModelDispatcher<ListenerType>, ListenerType:IModelListener>() : DispatcherType 
	{
		//TODO Check why it doesn't work?
		return new DispatcherType();
	}
}