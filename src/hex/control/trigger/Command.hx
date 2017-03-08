package hex.control.trigger;

import hex.control.Callback;
import hex.control.async.AsyncCallback;
import hex.control.async.Handler;
import hex.control.async.IAsyncCallback;
import hex.control.command.ICommand;
import hex.control.payload.ExecutionPayload;
import hex.di.IInjectorContainer;
import hex.error.Exception;
import hex.error.VirtualMethodException;
import hex.log.ILogger;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class Command<ResultType> implements IAsyncCallback<ResultType> implements ICommand implements IInjectorContainer
{
	var _acb 				: IAsyncCallback<ResultType>;
	var _handler 			: Handler<ResultType>;
	var _owner 				: IModule;
	
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
	
	public function onComplete( onComplete : Callback<ResultType> ) : IAsyncCallback<ResultType>
	{
		return this._acb.onComplete( onComplete );
	}
	
	public function onFail( onFail : Exception->Void ) : IAsyncCallback<ResultType>
	{
		return this._acb.onFail( onFail );
	}
	
	function _complete( result : ResultType ) : Void
	{
		this._handler( result );
	}
	
	function _fail( error : Exception ) : Void
	{
		this._handler( error );
	}

	public function getLogger() : ILogger 
	{
		return this._owner.getLogger();
	}
	
	public function getOwner() : IModule 
	{
		return this._owner;
	}
	
	public function setOwner( owner : IModule ) : Void 
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
