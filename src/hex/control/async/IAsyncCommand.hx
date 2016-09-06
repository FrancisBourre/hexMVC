package hex.control.async;

import hex.control.Request;
import hex.control.command.ICommand;

interface IAsyncCommand extends ICommand
{
    function preExecute( ?request : Request ) : Void;

    function cancel() : Void;

    /**
     * Event system
     */
    function addAsyncCommandListener( listener : IAsyncCommandListener ) : Void;

    function removeAsyncCommandListener( listener : IAsyncCommandListener ) : Void;

    function addCompleteHandler( callback : IAsyncCommand->Void ) : Void;

    function removeCompleteHandler( callback : IAsyncCommand->Void ) : Void;

    function addFailHandler( callback : IAsyncCommand->Void ) : Void;

    function removeFailHandler( callback : IAsyncCommand->Void ) : Void;

    function addCancelHandler( callback : IAsyncCommand->Void ) : Void;

    function removeCancelHandler( callback : IAsyncCommand->Void ) : Void;


    /**
     * State system
     */
	var wasUsed( get, null ) : Bool;
	
	var isRunning( get, null ) : Bool;

	var hasCompleted( get, null ) : Bool;

	var hasFailed( get, null ) : Bool;

	var isCancelled( get, null ) : Bool;
}
