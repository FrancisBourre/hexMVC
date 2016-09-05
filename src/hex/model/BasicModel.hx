package hex.model;

import hex.model.IModelDispatcher;

#if ( haxe_ver >= "3.3" )
import haxe.Constraints.Constructible;
#end

/**
 * ...
 * @author duke
 */
@:generic
#if ( haxe_ver >= "3.3" )
class BasicModel<DispatcherType:(IModelDispatcher<ListenerType>, haxe.Constraints.Constructible<Void->Void>), ListenerType: {}>
#else
class BasicModel<DispatcherType:IModelDispatcher<ListenerType>, ListenerType: {}>
#end
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