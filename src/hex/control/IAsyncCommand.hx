package hex.control;

interface IAsyncCommand extends ICommand
{
    function preExecute() : Void;

    function cancel() : Void;

    /**
     * Event system
     */
    function addAsyncCommandListener( listener : IAsyncCommandListener ) : Void;

    function removeAsyncCommandListener( listener : IAsyncCommandListener ) : Void;

    function addCompleteHandler( handler : AsyncCommandEvent->Void ) : Void;

    function removeCompleteHandler( handler : AsyncCommandEvent->Void ) : Void;

    function addFailHandler( handler : AsyncCommandEvent->Void ) : Void;

    function removeFailHandler( handler : AsyncCommandEvent->Void ) : Void;

    function addCancelHandler( handler : AsyncCommandEvent->Void ) : Void;

    function removeCancelHandler( handler : AsyncCommandEvent->Void ) : Void;


    /**
     * State system
     */
	var wasUsed( get, null ) : Bool;
	
	var isRunning( get, null ) : Bool;

	var hasCompleted( get, null ) : Bool;

	var hasFailed( get, null ) : Bool;

	var isCancelled( get, null ) : Bool;
}
