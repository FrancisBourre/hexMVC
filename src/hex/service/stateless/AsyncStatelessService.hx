package hex.service.stateless;

import haxe.Timer;
import hex.collection.HashMap;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncStatelessService<EventClass:ServiceEvent, ConfigurationClass:ServiceConfiguration> extends StatelessService<EventClass, ConfigurationClass> implements IAsyncStatelessService<EventClass, ConfigurationClass>
{
	public static inline var HAS_TIMEOUT : String = "HAS_TIMEOUT";
	
	private var _timer 				: Timer;
	private var _timeoutDuration 	: UInt;
	
	private function new() 
	{
		super();
		this._timeoutDuration = 100;
	}

	override public function call() : Void
	{
		super.call();
		this._startTimer();
		AsyncStatelessService._detainService( this );
	}
	
	override public function setConfiguration( configuration : ConfigurationClass ) : Void
	{
		super.setConfiguration( configuration );
		this.timeoutDuration = this._configuration.serviceTimeout;
	}
	
	@:final 
	public var hasTimeout( get, null ) : Bool;
    public function get_hasTimeout() : Bool
    {
        return this._status == AsyncStatelessService.HAS_TIMEOUT;
    }
	
	public var timeoutDuration( get, set ) : UInt;
	public function get_timeoutDuration() : UInt
	{
		return this._timeoutDuration;
	}

	private function set_timeoutDuration( duration : UInt ) : UInt
	{
		this.wasUsed && this._throwIllegalStateError( "timeoutDuration value can't be changed after service call" );
		this._timeoutDuration = duration;
		if ( this._configuration != null )
		{
			this._configuration.serviceTimeout = this._timeoutDuration;
		}
		return this._timeoutDuration;
	}

	@:final 
	override private function _reset() : Void
	{
		if ( this._timer != null )
		{
			this._timer.stop();
		}
		
		super._reset();
	}
	
	/**
     * Event handling
     */
	override public function addHandler( eventType : String, handler : EventClass->Void ) : Void
	{
		this._ed.addEventListener( eventType, handler );
	}

	override public function removeHandler( eventType : String, handler : EventClass->Void ) : Void
	{
		this._ed.addEventListener( eventType, handler );
	}
	
	/**
     * Memory handling
     */
    static private var _POOL : HashMap<Dynamic, Bool> = new HashMap<Dynamic, Bool>();

    static private function _isServiceDetained( service : Dynamic ) : Bool
    {
        return AsyncStatelessService._POOL.containsKey( service );
    }

    static private function _detainService( service : Dynamic ) : Void
    {
        AsyncStatelessService._POOL.put( service, true );
    }

    static private function _releaseService( service : Dynamic ) : Void
    {
        if ( AsyncStatelessService._POOL.containsKey( service ) )
        {
            AsyncStatelessService._POOL.remove( service );
        }
    }
	
	// private
	private function _onTimeoutHandler() : Void
	{
		if ( this._timer != null )
		{
			this._timer.stop();
		}
		
		this._ed.dispatchEvent( Type.createInstance( this._serviceEventClass, [AsyncStatelessServiceEventType.TIMEOUT, this] ) );
		this._status = AsyncStatelessService.HAS_TIMEOUT;
	}

	private function _startTimer() : Void
	{
		if ( this.timeoutDuration > 0 ) 
		{
			this._timer = new Timer( this._timeoutDuration );
			this._timer.run = this._onTimeoutHandler;
		}
		else
		{
			this._onTimeoutHandler();
		}
	}
	
	override private function _release() : Void
	{
		if ( this._timer != null )
		{
			this._timer.stop();
		}
		
		super._release();
		AsyncStatelessService._releaseService( this );
	}
}