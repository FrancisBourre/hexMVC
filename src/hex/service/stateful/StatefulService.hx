package hex.service.stateful;

import hex.error.IllegalStateException;
import hex.event.CompositeDispatcher;
import hex.event.Dispatcher;
import hex.event.MessageType;
import hex.service.AbstractService;
import hex.service.ServiceConfiguration;
import hex.service.stateful.IStatefulService;

/**
 * ...
 * @author duke
 */
class StatefulService<ServiceConfigurationType:ServiceConfiguration> extends AbstractService<ServiceConfigurationType> implements IStatefulService<ServiceConfigurationType>
{
	var _dispatcher				: Dispatcher<{}>;
	var _compositeDispatcher	: CompositeDispatcher;
	
	var _inUse 					: Bool = false;

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
	
	override public function setConfiguration( configuration : ServiceConfigurationType ) : Void
	{
		this._inUse && this._throwExecutionIllegalStateError( "setConfiguration" );
        this._configuration = configuration;
	}
	
	function _lock() : Void
	{
		this._inUse = true;
	}

	function _release() : Void
	{
		this._inUse = false;
	}

	public function inUse() : Bool
	{
		return this._inUse;
	}
	
	override public function addHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void 
	{
		this._dispatcher.addHandler( messageType, scope, callback );
	}
	
	override public function removeHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void 
	{
		this._dispatcher.removeHandler( messageType, scope, callback );
	}
	
	override public function removeAllListeners( ):Void
	{
		this._dispatcher.removeAllListeners();
	}
	
	function _throwExecutionIllegalStateError( methodName : String ) : Bool
	{
		return this._throwIllegalStateError( methodName + "() failed. This service is already in use." );
	}
	
	function _throwIllegalStateError( msg : String ) : Bool 
	{
		throw new IllegalStateException( msg );
	}
}