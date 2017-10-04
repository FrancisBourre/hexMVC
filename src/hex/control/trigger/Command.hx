package hex.control.trigger;

import hex.control.Callback;
import hex.control.async.AsyncCallback;
import hex.control.async.Expect;
import hex.control.async.Handler;
import hex.control.command.ICommand;
import hex.control.payload.ExecutionPayload;
import hex.di.IInjectorContainer;
import hex.error.Exception;
import hex.error.VirtualMethodException;
import hex.log.ILogger;
import hex.module.IContextModule;

/**
 * ...
 * @author Francis Bourre
 */
class Command<ResultType> implements Expect<ResultType> implements ICommand implements IInjectorContainer
{
	var _acb 				: Expect<ResultType>;
	var _handler 			: Handler<ResultType>;
	var _owner 				: IContextModule;
	
	@Inject
	@Optional(true)
	public var logger:ILogger;
	
	public function new() 
	{
		this._acb = AsyncCallback.get
		(
			function( handler )
			{
				this._handler = handler;
			}
		);
	}
	
	public function execute() : Void
	{
		throw new VirtualMethodException();
	}
	
	public var isWaiting( get, null ) : Bool;
	@:final 
    public function get_isWaiting() : Bool
	{
		return this._acb.isWaiting;
	}
	
	public var isCompleted( get, null ) : Bool;
	@:final 
    public function get_isCompleted() : Bool
	{
		return this._acb.isCompleted;
	}
	
	public var isFailed( get, null ) : Bool;
	@:final 
    public function get_isFailed() : Bool
	{
		return this._acb.isFailed;
	}
	
	public var isCancelled( get, null ) : Bool;
	@:final 
    public function get_isCancelled() : Bool
	{
		return this._acb.isCancelled;
	}
	
	public function onComplete( onComplete : Callback<ResultType> ) : Expect<ResultType>
	{
		return this._acb.onComplete( onComplete );
	}
	
	public function onFail( onFail : Exception->Void ) : Expect<ResultType>
	{
		return this._acb.onFail( onFail );
	}
	
	public function onCancel( onCancel : Void->Void ) : Expect<ResultType>
	{
		return this._acb.onCancel( onCancel );
	}
	
	function _complete( result : ResultType ) : Void
	{
		this._handler( result );
	}
	
	function _fail( error : Exception ) : Void
	{
		this._handler( error );
	}
	
	function _cancel() : Void
	{
		this._handler( Result.CANCELLED );
	}

	public function getLogger() : ILogger 
	{
		return (logger == null) ? this._owner.getLogger() : logger;
	}
	
	public function getOwner() : IContextModule 
	{
		return this._owner;
	}
	
	public function setOwner( owner : IContextModule ) : Void 
	{
		this._owner = owner;
	}
	
	public function getResult() : Array<Dynamic>
	{
		return null;
	}
	
	public function getReturnedExecutionPayload() : Array<ExecutionPayload>
	{
		return null;
	}
}
