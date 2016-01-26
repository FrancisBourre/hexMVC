package hex.service.stateless;

import haxe.Timer;
import hex.collection.HashMap;
import hex.service.ServiceConfiguration;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncStatelessService<ServiceConfigurationType:ServiceConfiguration> extends StatelessService<ServiceConfigurationType> implements IAsyncStatelessService<ServiceConfigurationType>
{
	public static inline var HAS_TIMEOUT : String = "HAS_TIMEOUT";
	
	var _timer 				: Timer;
	var _timeoutDuration 	: UInt;
	
	function new() 
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
	
	override public function setConfiguration( configuration : ServiceConfigurationType ) : Void
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
	
	@:isVar
	public var timeoutDuration( get, set ) : UInt;
	public function get_timeoutDuration() : UInt
	{
		return this._timeoutDuration;
	}

	function set_timeoutDuration( duration : UInt ) : UInt
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
	override function _reset() : Void
	{
		if ( this._timer != null )
		{
			this._timer.stop();
		}
		
		super._reset();
	}
	
	/**
     * Memory handling
     */
    static var _POOL = new HashMap<Dynamic, Bool>();

    static function _isServiceDetained( service : Dynamic ) : Bool
    {
        return AsyncStatelessService._POOL.containsKey( service );
    }

    static function _detainService( service : Dynamic ) : Void
    {
        AsyncStatelessService._POOL.put( service, true );
    }

    static function _releaseService( service : Dynamic ) : Void
    {
        if ( AsyncStatelessService._POOL.containsKey( service ) )
        {
            AsyncStatelessService._POOL.remove( service );
        }
    }
	
	// private
	function _onTimeoutHandler() : Void
	{
		if ( this._timer != null )
		{
			this._timer.stop();
		}
		
		this._ed.dispatch( AsyncStatelessServiceMessage.TIMEOUT, [this] );
		this._status = AsyncStatelessService.HAS_TIMEOUT;
	}

	function _startTimer() : Void
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
	
	override function _release() : Void
	{
		if ( this._timer != null )
		{
			this._timer.stop();
		}
		
		super._release();
		AsyncStatelessService._releaseService( this );
	}
}