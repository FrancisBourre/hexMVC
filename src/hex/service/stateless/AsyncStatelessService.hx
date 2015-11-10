package hex.service.stateless;

import haxe.Timer;
import hex.event.LightweightClosureDispatcher;

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
	}
	
	override public function call() : Void
	{
		super.call();
		this.startTimer();
		AsyncStatelessService.detainService( this );
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
		this._timeoutDuration = duration;
		return this._timeoutDuration;
	}
	
	private function onTimeoutHandler() : Void
	{
		this._timer.stop();
		this._ed.dispatchEvent( new StatelessServiceEvent( StatelessServiceEvent.ERROR, this ) );
		this._onFaultHandler( null );
	}

	private function startTimer() : Void
	{
		if ( this.timeoutDuration > 0 ) 
		{
			this._timer = new Timer( this._timeoutDuration );
			this._timer.run = this.onTimeoutHandler;
			this._timer.run();
		}
	}
	
	override private function _release() : Void
	{
		this._timer.stop();
		super._release();
		AsyncStatelessService.releaseService( this );
	}

	@:final 
	override private function _reset() : Void
	{
		this._timer.stop();
		super._reset();
	}
	
	public function addAsyncServiceListener( listener : IAsyncStatelessServiceListener ) : Void
	{
		super.addStatelessServiceListener( listener );
		this._ed.addEventListener( StatelessServiceEvent.TIMEOUT, listener.onAsyncStatelessServiceTimeout );

	}

	public function removeAsyncServiceListener( listener : IAsyncStatelessServiceListener ) : Void
	{
		super.removeStatelessServiceListener( listener );
		this._ed.removeEventListener( StatelessServiceEvent.TIMEOUT, listener.onAsyncStatelessServiceTimeout );
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

    static private function isServiceDetained( service : AsyncStatelessService ) : Bool
    {
        return AsyncStatelessService._POOL.exists( service );
    }

    static private function detainService( service : AsyncStatelessService ) : Void
    {
        AsyncStatelessService._POOL.set( service, true );
    }

    static private function releaseService( service : AsyncStatelessService ) : Void
    {
        if ( AsyncStatelessService._POOL.exists( service ) )
        {
            AsyncStatelessService._POOL.remove( service );
        }
    }
}