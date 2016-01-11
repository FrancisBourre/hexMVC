package hex.service.stateful;

import hex.error.IllegalStateException;
import hex.event.Dispatcher;
import hex.event.IEvent;
import hex.event.IEventListener;
import hex.event.LightweightClosureDispatcher;
import hex.event.MessageType;
import hex.event.CompositeDispatcher;
import hex.service.AbstractService;
import hex.service.ServiceConfiguration;
import hex.service.stateful.IStatefulService;

/**
 * ...
 * @author duke
 */
class StatefulService extends AbstractService implements IStatefulService
{
	private var _dispatcher				: Dispatcher<{}>;
	private var _compositeDispatcher	: CompositeDispatcher;
	
	@:isVar public var inUse( get, null ) : Bool = false;

	public function new() 
	{
		super();
		
		this._compositeDispatcher 	= new CompositeDispatcher();
		this._dispatcher 			= new Dispatcher<{}>();
		
		this._compositeDispatcher.add( this._dispatcher );
	}
	
	public function getDispatcher() : CompositeDispatcher
	{
		return this._compositeDispatcher;
	}
	
	override public function setConfiguration( configuration : ServiceConfiguration ) : Void
	{
		this.inUse && this._throwExecutionIllegalStateError( "setConfiguration" );
        this._configuration = configuration;
	}
	
	private function _lock() : Void
	{
		this.inUse = true;
	}

	private function _release() : Void
	{
		this.inUse = false;
	}

	private function get_inUse() : Bool
	{
		return this.inUse;
	}
	
	override public function addHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void 
	{
		this._dispatcher.addHandler( messageType, scope, callback );
	}
	
	override public function removeHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void 
	{
		this._dispatcher.removeHandler( messageType, scope, callback );
	}
	
	private function _throwExecutionIllegalStateError( methodName : String ) : Bool
	{
		return this._throwIllegalStateError( methodName + "() failed. This service is already in use." );
	}
	
	private function _throwIllegalStateError( msg : String ) : Bool 
	{
		throw new IllegalStateException( msg );
	}
}