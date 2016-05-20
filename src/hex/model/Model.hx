package hex.model;

import hex.model.IModelDispatcher;

/**
 * ...
 * @author duke
 */
@:generic
class Model<DispatcherType:IModelDispatcher<ListenerType>, ListenerType:{}>
{
	public var dispatcher : DispatcherType;

	public function new() 
	{
		this.dispatcher = new DispatcherType();
	}
	
	public function addListener( listener : ListenerType ) : Void
	{
		this.dispatcher.addListener( listener );
	}

	public function removeListener( listener : ListenerType ) : Void
	{
		this.dispatcher.removeListener( listener );
	}
}