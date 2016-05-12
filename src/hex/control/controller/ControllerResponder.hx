package hex.control.controller;

import hex.control.async.AsyncCommand;
import hex.control.async.IAsyncCommand;

/**
 * ...
 * @author Francis Bourre
 */
class ControllerResponder implements ICompletable
{
	var _asyncCommand : IAsyncCommand;

	public function new( ?asyncCommand : IAsyncCommand ) 
	{
		this._asyncCommand = asyncCommand;
	}
	
	/*public function addCompleteHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
	{
		if ( this._asyncCommand.hasCompleted )
        {
            callback( this._asyncCommand );
        }
        else
        {
            this._asyncCommand.addCompleteHandler( scope, callback );
        }
	}
	
	public function removeCompleteHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
    {
        this._asyncCommand.removeCompleteHandler( scope, callback );
    }
	
	public function addFailHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
    {
		if ( this._asyncCommand.hasFailed )
        {
            callback( this._asyncCommand );
        }
        else
        {
            this._asyncCommand.addFailHandler( scope, callback );
        }
	}
	
	public function removeFailHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
    {
        this._asyncCommand.removeFailHandler( scope, callback );
    }
	
	public function addCancelHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
    {
		if ( this._asyncCommand.isCancelled )
        {
            callback( this._asyncCommand );
        }
        else
        {
            this._asyncCommand.addCancelHandler( scope, callback );
        }
	}
	
	public function removeCancelHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
    {
        this._asyncCommand.removeCancelHandler( scope, callback );
    }
	
	public function getResult() : Dynamic 
	{
		return null;
	}*/
}