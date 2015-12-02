package hex.service.stateful;

import hex.error.IllegalStateException;
import hex.event.IEvent;
import hex.event.IEventDispatcher;
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
	@inject
	public var dispatcher	: IEventDispatcher<IEventListener, IEvent>;
	
	private var _ed			: LightweightClosureDispatcher<EventClass>;
	
	@:isVar public var inUse(get, null):Bool = false;

	public function new() 
	{
		super();
	}
	
	override public function setConfiguration( configuration : ConfigurationClass ) : Void
	{
		this.inUse && this._throwExecutionIllegalStateError( "setConfiguration" );
        this._configuration = configuration;
	}
	
	private function _lock():Void
	{
		this.inUse = true;
	}

	private function _release():Void
	{
		this.inUse = false;
	}

	private function get_inUse():Bool
	{
		return this.inUse;
	}
	
	override public function addHandler(eventType:String, handler:EventClass->Void):Void 
	{
		this._ed.addEventListener( eventType, handler );
	}
	
	override public function removeHandler(eventType:String, handler:EventClass->Void):Void 
	{
		this._ed.addEventListener( eventType, handler );
	}
	
	private function _throwExecutionIllegalStateError( methodName : String ):Bool
	{
		var msg : String = "";

		msg = methodName + "() failed. This service is already in use.";
		
		return this._throwIllegalStateError( msg );
	}
	
	private function _throwIllegalStateError( msg : String ) : Bool 
	{
		throw new IllegalStateException( msg );
	}
}