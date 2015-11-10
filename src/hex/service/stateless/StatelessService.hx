package hex.service.stateless;

import hex.data.IParser;
import hex.error.IllegalStateException;
import hex.error.UnsupportedOperationException;
import hex.event.LightweightClosureDispatcher;
import hex.service.AbstractService;
import hex.service.stateless.IStatelessService;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessService extends AbstractService implements IStatelessService
{
	public static inline var WAS_NEVER_USED     : String = "WAS_NEVER_USED";
    public static inline var IS_RUNNING         : String = "IS_RUNNING";
    public static inline var IS_COMPLETED       : String = "IS_COMPLETED";
    public static inline var IS_FAILED          : String = "IS_FAILED";
    public static inline var IS_CANCELLED       : String = "IS_CANCELLED";
	
	private var _ed                             : LightweightClosureDispatcher<StatelessServiceEvent>;
	private var _result                     	: Dynamic;
    private var _rawResult                		: Dynamic;
	private var _parser                    		: IParser;
    private var _status                     	: String = StatelessService.WAS_NEVER_USED;
	
	private function new() 
	{
		super();
	}
	
	public function call() : Void
	{
		this.wasUsed && this._throwExecutionIllegalStateError( "call" );
		this._status = StatelessService.IS_RUNNING;
	}

	public function cancel() : Void
	{
		this.wasUsed && _status != StatelessService.IS_RUNNING && this._throwCancellationIllegalStateError();
		this._status = StatelessService.IS_CANCELLED;
		this.handleCancel();
	}
	
	@:final 
	public var wasUsed( get, null ) : Bool;
    public function get_wasUsed() : Bool
    {
        return this._status != StatelessService.WAS_NEVER_USED;
    }

	@:final 
	public var isRunning( get, null ) : Bool;
    public function get_isRunning() : Bool
    {
        return this._status == StatelessService.IS_RUNNING;
    }

	@:final 
	public var hasCompleted( get, null ) : Bool;
    public function get_hasCompleted() : Bool
    {
        return this._status == StatelessService.IS_COMPLETED;
    }

	@:final 
	public var hasFailed( get, null ) : Bool;
    public function get_hasFailed() : Bool
    {
        return this._status == StatelessService.IS_FAILED;
    }

	@:final 
	public var isCancelled( get, null ) : Bool;
    public function get_isCancelled() : Bool
    {
        return this._status == StatelessService.IS_CANCELLED;
    }
	
	override public function setConfiguration( configuration : ServiceConfiguration ) : Void
	{
		this.wasUsed && this._throwExecutionIllegalStateError( "setConfiguration" );
        this._configuration = configuration;
	}
	
	private function _throwExecutionIllegalStateError( methodName : String ) : Bool
	{
		var msg : String = "";

		if ( this.isRunning )
		{
			msg = methodName + "() failed. This service is already processing.";
		}
		else if ( this.isCancelled )
		{
			msg = methodName + "() failed. This service is cancelled.";
		}
		else if ( this.hasCompleted )
		{
			msg = methodName + "() failed. This service is completed and can't be called twice.";
		}
		else if ( this.hasFailed )
		{
			msg = methodName + "() failed. This service has failed and can't be called twice.";
		}

		this._release();
		throw new IllegalStateException( msg );
	}
	
	private function _throwCancellationIllegalStateError() : Bool
	{
		var msg : String = "";

		if ( isCancelled )
		{
			msg = "cancel() failed. This service was already cancelled.";
		}
		else if ( hasCompleted )
		{
			msg = "cancel() failed. This service was already completed.";
		}
		else if ( hasFailed )
		{
			msg = "cancel() failed. This service has already failed.";
		}

		this._release();
		throw new IllegalStateException( msg );
	}
	
	private function _resetAllHandlers() : Void
	{
		this._ed.removeAllListeners();
	}

	private function _release() : Void
	{
		this._resetAllHandlers();
	}
	
	private function _onResultHandler( result : Dynamic ) : Void
	{
		this.result = result;
		this.handleComplete();
	}

	private function _onFaultHandler( result : Dynamic ) : Void
	{
		this.result = null;
		this.handleFail();
	}
	
	public var result( get, set ) : Dynamic;
	public function get_result() : Dynamic
	{
		return this._result;
	}
	
	public function set_result( response : Dynamic ) : Dynamic
	{
		this._rawResult = response;
		this._result = this._parser != null ? this._parser.parse( this._rawResult ) : this._rawResult;
		return this._result;
	}
	
	public var rawResult( get, null ) : Dynamic;
    public function get_rawResult() : Dynamic
    {
        return this._rawResult;
    }

	public function release() : Void
	{
		this.removeAllListeners();

		this._result    = null;
		this._parser    = null;
	}

	public function setParser( parser : IParser ) : Void
	{
		this._parser = parser;
	}

	/**
	 * Event handling
	 */
	public function handleComplete() : Void
	{
		this._doComplete();
	}

	public function handleFail() : Void
	{
		this._doFail();
	}

	public function handleCancel() : Void
	{
		this._doCancel();
	}

	@:final 
	public function removeAllListeners() : Void
	{
		this._ed.removeAllListeners();
	}

	public function addStatelessServiceListener( listener : IStatelessServiceListener ) : Void
	{
		this._ed.addEventListener( StatelessServiceEvent.SUCCESS, listener.onStatelessServiceSuccess );
		this._ed.addEventListener( StatelessServiceEvent.ERROR, listener.onStatelessServiceError );
		this._ed.addEventListener( StatelessServiceEvent.CANCEL, listener.onStatelessServiceCancel );
	}

	public function removeStatelessServiceListener( listener : IStatelessServiceListener ) : Void
	{
		this._ed.removeEventListener( StatelessServiceEvent.SUCCESS, listener.onStatelessServiceSuccess );
		this._ed.removeEventListener( StatelessServiceEvent.ERROR, listener.onStatelessServiceError );
		this._ed.removeEventListener( StatelessServiceEvent.CANCEL, listener.onStatelessServiceCancel );
	}

	override public function addHandler( eventType : String, handler : StatelessServiceEvent->Void ) : Void
	{
		this._ed.addEventListener( eventType, handler );
	}

	override public function removeHandler( eventType : String, handler : StatelessServiceEvent->Void ) : Void
	{
		this._ed.addEventListener( eventType, handler );
	}
	
	//
	private function getRemoteArguments() : Array<Dynamic>
	{
		throw new UnsupportedOperationException( this + ".getRemoteArguments() is unsupported." );
	}

	private function _doComplete() : Void
	{
		this._status = StatelessService.IS_COMPLETED;
		this._ed.dispatchEvent( new StatelessServiceEvent ( StatelessServiceEvent.SUCCESS, this ) );
		this._release();
	}

	private function _doFail() : Void
	{
		this._status = StatelessService.IS_FAILED;
		this._ed.dispatchEvent( new StatelessServiceEvent ( StatelessServiceEvent.ERROR, this ) );
		this._release();
	}

	private function _doCancel() : Void
	{
		this._status = StatelessService.IS_CANCELLED;
		this._ed.dispatchEvent( new StatelessServiceEvent ( StatelessServiceEvent.CANCEL, this ) );
		this._release();
	}

	private function _reset() : Void
	{
		this._status = StatelessService.WAS_NEVER_USED;
	}
}