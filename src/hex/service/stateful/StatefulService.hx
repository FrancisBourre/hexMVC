package hex.service.stateful;

import hex.error.IllegalStateException;
import hex.event.CompositeClosureDispatcher;
import hex.event.IEvent;
import hex.event.IEventListener;
import hex.event.LightweightClosureDispatcher;
import hex.service.AbstractService;
import hex.service.stateful.IStatefulService;

/**
 * ...
 * @author duke
 */
class StatefulService<EventClass:ServiceEvent, ConfigurationClass:ServiceConfiguration> extends AbstractService<EventClass, ConfigurationClass> implements IStatefulService<EventClass, ConfigurationClass>
{
	private var _dispatcher				: LightweightClosureDispatcher<EventClass>;
	private var _compositeDispatcher	: CompositeClosureDispatcher<EventClass>;
	
	@:isVar public var inUse( get, null ) : Bool = false;

	public function new() 
	{
		super();
		
		this._compositeDispatcher 	= new CompositeClosureDispatcher();
		this._dispatcher 			= new LightweightClosureDispatcher();
		
		this._compositeDispatcher.add( this._dispatcher );
	}
	
	public function getDispatcher() : CompositeClosureDispatcher<EventClass>
	{
		return this._compositeDispatcher;
	}
	
	override public function setConfiguration( configuration : ConfigurationClass ) : Void
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
	
	override public function addHandler( eventType : String, handler : EventClass->Void ) : Void 
	{
		this._dispatcher.addEventListener( eventType, handler );
	}
	
	override public function removeHandler( eventType : String, handler : EventClass->Void ) : Void 
	{
		this._dispatcher.removeEventListener( eventType, handler );
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