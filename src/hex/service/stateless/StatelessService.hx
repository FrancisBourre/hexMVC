package hex.service.stateless;

import hex.data.IParser;
import hex.error.IllegalStateException;
import hex.error.UnsupportedOperationException;
import hex.event.Dispatcher;
import hex.event.IDispatcher;
import hex.event.MessageType;
import hex.service.AbstractService;
import hex.service.ServiceConfiguration;
import hex.service.stateless.IStatelessService;
import hex.service.stateless.StatelessServiceMessage;

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
	
	private var _ed            					: IDispatcher<{}>;
	
	private var _result                     	: Dynamic;
    private var _rawResult                		: Dynamic;
	private var _parser                    		: IParser;
    private var _status                     	: String = StatelessService.WAS_NEVER_USED;
	
	private function new() 
	{
		super();
		this._ed = new Dispatcher<{}>();
	}

	override public function setConfiguration( configuration : ServiceConfiguration ) : Void
	{
		this.wasUsed && this._throwExecutionIllegalStateError( "setConfiguration" );
        this._configuration = configuration;
	}
	
	override public function addHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void
	{
		this._ed.addHandler( messageType, scope, callback );
	}

	override public function removeHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void
	{
		this._ed.removeHandler( messageType, scope, callback );
	}
	
	override public function release() : Void
	{
		if ( !this.wasUsed )
		{
			this.cancel();
		}
		else 
		{
			this._release();
		}
	}
	
	public function call() : Void
	{
		this.wasUsed && this._throwExecutionIllegalStateError( "call" );
		this._status = StatelessService.IS_RUNNING;
	}

	public function cancel() : Void
	{
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
		return this._throwIllegalStateError( msg );
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
		return this._throwIllegalStateError( msg );
	}

	private function _throwIllegalStateError( msg : String ) : Bool 
	{
		throw new IllegalStateException( msg );
	}

	private function _release() : Void
	{
		this.removeAllListeners();
		this._result = null;
		this._parser = null;
	}
	
	private function _onResultHandler( result : Dynamic ) : Void
	{
		if ( this._status == StatelessService.IS_RUNNING )
		{
			this._setResult( result );
			this.handleComplete();
		}
	}

	private function _onErrorHandler( result : Dynamic ) : Void
	{
		this._rawResult = null;
		this._result = null;
		this.handleFail();
	}
	
	@:final 
	public function getResult() : Dynamic
	{
		return this._result;
	}
	
	private function _setResult( response : Dynamic ) : Dynamic
	{
		this._rawResult = response;
		this._result = this._parser != null ? this._parser.parse( this._rawResult ) : this._rawResult;
		return this._result;
	}
	
	public function getRawResult() : Dynamic
	{
		return this._rawResult;
	}

	public function setParser( parser : IParser ) : Void
	{
		this._parser = parser;
	}

	@:final 
	public function handleComplete() : Void
	{
		this.wasUsed && this._status != StatelessService.IS_RUNNING && this._throwIllegalStateError( "handleComplete failed" );
		this._status = StatelessService.IS_COMPLETED;
		this._ed.dispatch( StatelessServiceMessage.COMPLETE, [this] );
		this._release();
	}

	@:final 
	public function handleFail() : Void
	{
		this.wasUsed && this._status != StatelessService.IS_RUNNING && this._throwIllegalStateError( "handleFail failed" );
		this._status = StatelessService.IS_FAILED;
		this._ed.dispatch( StatelessServiceMessage.FAIL, [this] );
		this._release();
	}

	@:final 
	public function handleCancel() : Void
	{
		this.wasUsed && this._status != StatelessService.IS_RUNNING && this._throwIllegalStateError( "handleCancel failed" );
		this._status = StatelessService.IS_CANCELLED;
		this._ed.dispatch( StatelessServiceMessage.CANCEL, [this] );
		this._release();
	}

	@:final 
	public function removeAllListeners() : Void
	{
		this._ed.removeAllListeners();
	}
	
	//
	private function _getRemoteArguments() : Array<Dynamic>
	{
		throw new UnsupportedOperationException( this + ".getRemoteArguments is unsupported." );
	}

	private function _reset() : Void
	{
		this._status = StatelessService.WAS_NEVER_USED;
	}
}