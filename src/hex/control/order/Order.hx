package hex.control.order;

import hex.control.controller.ICompletable;
import hex.error.IllegalStateException;
import hex.log.ILogger;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class Order<ResultType> implements ICompletable<ResultType>
{
	var _owner 				: IModule;
	var _result 			: ResultType;
	var _errorMessage 		: String;
	
	var _hasCompleted 		: Bool = false;
	var _hasFailed 			: Bool = false;
	
	var _completeResponder 	: Array<ResultType->Void>;
	var _failResponder 		: Array<String->Void>;
	
	public var executeMethodName( default, null ) : String = "execute";
	
	public function new() 
	{
		this._completeResponder 	= [];
		this._failResponder 		= [];
		this._hasCompleted 				= false;
	}
	
	public function onComplete( callback : ResultType->Void ) : ICompletable<ResultType>
	{
		if ( !this._hasCompleted )
		{
			this._completeResponder.push( callback );
		}
		else
		{
			callback( this._result );
		}
		
		return this;
	}
	
	public function onFail( callback : String->Void ) : ICompletable<ResultType>
	{
		if ( !this._hasFailed )
		{
			this._failResponder.push( callback );
		}
		else
		{
			callback( this._errorMessage );
		}
		
		return this;
	}
	
	function _complete( result : ResultType ) : Void
	{
		if ( !this._hasCompleted && !this._hasFailed )
		{
			this._result = result;
			for ( responder in this._completeResponder )
			{
				responder( result );
			}
		}
		else
		{
			throw new IllegalStateException( 'this instance has already completed' );
		}
	}
	
	function _fail( errorMessage : String ) : Void
	{
		if ( !this._hasCompleted && !this._hasFailed )
		{
			this._errorMessage = errorMessage;
			this._hasFailed = true;
			for ( responder in this._failResponder )
			{
				responder( errorMessage );
			}
		}
		else
		{
			throw new IllegalStateException( 'this instance has already failed' );
		}
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
}
