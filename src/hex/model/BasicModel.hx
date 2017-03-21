package hex.model;

import hex.model.IModelDispatcher;
import haxe.Constraints.Constructible;

/**
 * ...
 * @author duke
 */
@:generic
class BasicModel<DispatcherType:(IModelDispatcher<ListenerType>, haxe.Constraints.Constructible<Void->Void>), ListenerType: {}>
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