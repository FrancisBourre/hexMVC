package hex.service.stateless;

import haxe.Timer;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncStatelessService extends StatelessService implements IAsyncStatelessService
{
	private var _timer 				: Timer;
	private var _timeoutDuration 	: UInt;
	
	private function new()
	{
		super();
		this._timeoutDuration = 0;
	}

	override public function call() : Void
	{
		super.call();
		this._startTimer();
		AsyncStatelessService._detainService( this );
	}
	
	override public function getConfiguration() : ServiceConfiguration
	{
		this._configuration.serviceTimeout = this.timeoutDuration;
		return super.getConfiguration();
	}

	override public function setConfiguration( configuration : ServiceConfiguration ) : Void
	{
		super.setConfiguration( configuration );
		this.timeoutDuration = this._configuration.serviceTimeout;
	}
	
	public var timeoutDuration( get, set ) : UInt;
	public function get_timeoutDuration() : UInt
	{
		return this._timeoutDuration;
	}

	public function set_timeoutDuration( duration : UInt ) : UInt
	{
		this.wasUsed && this._throwIllegalStateError( "timeoutDuration value can't be changed after service call" );
		this._timeoutDuration = duration;
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
	public function addAsyncServiceListener( listener : IAsyncStatelessServiceListener ) : Void
	{
		super.addStatelessServiceListener( listener );
		this._ed.addEventListener( AsyncStatelessServiceEvent.TIMEOUT, listener.onAsyncStatelessServiceTimeout );

	}

	public function removeAsyncServiceListener( listener : IAsyncStatelessServiceListener ) : Void
	{
		super.removeStatelessServiceListener( listener );
		this._ed.removeEventListener( AsyncStatelessServiceEvent.TIMEOUT, listener.onAsyncStatelessServiceTimeout );
	}
	
	override public function addHandler( eventType : String, handler : StatelessServiceEvent->Void ) : Void
	{
		this._ed.addEventListener( eventType, handler );
	}

	override public function removeHandler( eventType : String, handler : StatelessServiceEvent->Void ) : Void
	{
		this._ed.addEventListener( eventType, handler );
	}
	
	/**
     * Memory handling
     */
    static private var _POOL : Map<AsyncStatelessService, Bool> = new Map<AsyncStatelessService, Bool>();

    static private function _isServiceDetained( service : AsyncStatelessService ) : Bool
    {
        return AsyncStatelessService._POOL.exists( service );
    }

    static private function _detainService( service : AsyncStatelessService ) : Void
    {
        AsyncStatelessService._POOL.set( service, true );
    }

    static private function _releaseService( service : AsyncStatelessService ) : Void
    {
        if ( AsyncStatelessService._POOL.exists( service ) )
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
		
		this._ed.dispatchEvent( new AsyncStatelessServiceEvent( AsyncStatelessServiceEvent.TIMEOUT, this ) );
		this._onErrorHandler( null );
	}

	private function _startTimer() : Void
	{
		if ( this.timeoutDuration > 0 ) 
		{
			this._timer = new Timer( this._timeoutDuration );
			this._timer.run = this._onTimeoutHandler;
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