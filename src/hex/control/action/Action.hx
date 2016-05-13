package hex.control.action;

import hex.control.controller.ICompletable;
import hex.error.IllegalStateException;
import hex.log.ILogger;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class Action<ResultType> implements ICompletable<ResultType>
{
	var _owner 			: IModule;
	var _result 		: ResultType;
	var _responders 	: Array<ResultType->Void>;
	
	public var executeMethodName( default, null ) : String = "execute";
	
	public function new() 
	{
		this._responders 	= [];
	}
	
	public function onComplete( callback : ResultType->Void ) : ICompletable<ResultType>
	{
		if ( this._result == null )
		{
			this._responders.push( callback );
		}
		else
		{
			callback( this._result );
		}
		
		return this;
	}
	
	private function _complete( result : ResultType ) : Void
	{
		if ( this._result == null )
		{
			this._result = result;
			for ( responder in this._responders )
			{
				responder( result );
			}
		}
		else
		{
			throw new IllegalStateException( 'this instance has already completed' );
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