package hex.control;

import hex.error.IllegalStateException;
import hex.error.VirtualMethodException;
import hex.event.IEvent;
import hex.module.IModule;
import hex.event.LightweightClosureDispatcher;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncCommand implements IAsyncCommand
{
    public static inline var WAS_NEVER_USED     : String = "WAS_NEVER_USED";
    public static inline var IS_RUNNING         : String = "IS_RUNNING";
    public static inline var IS_COMPLETED       : String = "IS_COMPLETED";
    public static inline var IS_FAILED          : String = "IS_FAILED";
    public static inline var IS_CANCELLED       : String = "IS_CANCELLED";

    private var _status                         : String;
    private var _ed                             : LightweightClosureDispatcher<AsyncCommandEvent>;
    private var _owner                          : IModule;

    public function new()
    {
        this._status    = AsyncCommand.WAS_NEVER_USED;
        this._ed        = new LightweightClosureDispatcher<AsyncCommandEvent>();
    }

    public function preExecute() :  Void
    {
        this.wasUsed() && this._throwExecutionIllegalStateError();
        this._status = AsyncCommand.IS_RUNNING;
        AsyncCommand.detain( this );
    }

    public function cancel() : Void
    {
        this.wasUsed() && _status != AsyncCommand.IS_RUNNING && this._throwCancellationIllegalStateError();
        this._status = AsyncCommand.IS_CANCELLED;
        this.handleCancel();
    }

    public function addAsyncCommandListener( listener : IAsyncCommandListener ) : Void
    {
        this.addCompleteHandler( listener.onAsyncCommandComplete );
        this.addFailHandler( listener.onAsyncCommandFail );
        this.addCancelHandler( listener.onAsyncCommandCancel );
    }

    public function removeAsyncCommandListener( listener : IAsyncCommandListener ) : Void
    {
        this.removeCompleteHandler( listener.onAsyncCommandComplete );
        this.removeFailHandler( listener.onAsyncCommandFail );
        this.removeCancelHandler( listener.onAsyncCommandCancel );
    }

    public function addCompleteHandler( handler : AsyncCommandEvent->Void ) : Void
    {
        if ( this.hasCompleted() )
        {
            handler( new AsyncCommandEvent( AsyncCommandEvent.COMPLETE, this ) );
        }
        else
        {
            this._ed.addEventListener( AsyncCommandEvent.COMPLETE, handler );
        }
    }

    public function removeCompleteHandler( handler : AsyncCommandEvent->Void ) : Void
    {
        this._ed.removeEventListener( AsyncCommandEvent.COMPLETE, handler );
    }

    public function addFailHandler( handler : AsyncCommandEvent->Void ) : Void
    {
        if ( this.hasFailed() )
        {
            handler( new AsyncCommandEvent( AsyncCommandEvent.FAIL, this ) );
        }
        else
        {
            this._ed.addEventListener( AsyncCommandEvent.FAIL, handler );
        }
    }

    public function removeFailHandler( handler : AsyncCommandEvent->Void ) : Void
    {
        this._ed.removeEventListener( AsyncCommandEvent.FAIL, handler );
    }

    public function addCancelHandler( handler : AsyncCommandEvent->Void ) : Void
    {
        if ( this.isCancelled() )
        {
            handler( new AsyncCommandEvent( AsyncCommandEvent.CANCEL, this ) );
        }
        else
        {
            this._ed.addEventListener( AsyncCommandEvent.CANCEL, handler );
        }
    }

    public function removeCancelHandler( handler : AsyncCommandEvent->Void ) : Void
    {
        this._ed.removeEventListener( AsyncCommandEvent.CANCEL, handler );
    }

    public function handleComplete() : Void
    {
        this._status = AsyncCommand.IS_COMPLETED;
        this._ed.dispatchEvent( new AsyncCommandEvent( AsyncCommandEvent.COMPLETE, this ) );
        this._release();
    }

    public function handleFail() : Void
    {
        this._status = AsyncCommand.IS_FAILED;
        this._ed.dispatchEvent( new AsyncCommandEvent( AsyncCommandEvent.FAIL, this ) );
        this._release();
    }

    public function handleCancel() : Void
    {
        this._status = AsyncCommand.IS_CANCELLED;
        this._ed.dispatchEvent( new AsyncCommandEvent( AsyncCommandEvent.CANCEL, this ) );
        this._release();
    }

    public function wasUsed() : Bool
    {
        return this._status != AsyncCommand.WAS_NEVER_USED;
    }

    public function isRunning() : Bool
    {
        return this._status == AsyncCommand.IS_RUNNING;
    }

    public function hasCompleted() : Bool
    {
        return this._status == AsyncCommand.IS_COMPLETED;
    }

    public function hasFailed() : Bool
    {
        return this._status == AsyncCommand.IS_FAILED;
    }

    public function isCancelled() : Bool
    {
        return this._status == AsyncCommand.IS_CANCELLED;
    }

    public function execute( ?e : IEvent ) : Void
    {
        throw new VirtualMethodException( this + ".execute must be overridden" );
    }

	public function getPayload() : Array<Dynamic>
    {
        return null;
    }

    public function getOwner() : IModule
    {
        return this._owner;
    }

    public function setOwner( owner : IModule ) : Void
    {
        if ( this._owner == null )
        {
            this._owner = owner;
        }
    }

    /**
     * Private
     */
    private function _removeAllListeners() : Void
    {
        this._ed.removeAllListeners();
    }

    private function _throwExecutionIllegalStateError() : Bool
    {
        var msg : String = "";

        if ( this.isRunning() )
        {
            msg = "execute() failed. This command is already processing.";
        }
        else if ( this.isCancelled() )
        {
            msg = "execute() failed. This command is cancelled.";
        }
        else if ( this.hasCompleted() )
        {
            msg = "execute() failed. This command is completed and can't be executed twice.";
        }
        else if ( this.hasFailed() )
        {
            msg = "execute() failed. This command has failed and can't be executed twice.";
        }

        this._release();
        throw new IllegalStateException( msg );
    }

    private function _throwCancellationIllegalStateError() : Bool
    {
        var msg : String = "";

        if ( isCancelled() )
        {
            msg = "cancel() failed. This command was already cancelled.";
        }
        else if ( hasCompleted() )
        {
            msg = "cancel() failed. This command was already completed.";
        }
        else if ( hasFailed() )
        {
            msg = "cancel() failed. This command has already failed.";
        }

        this._release();
        throw new IllegalStateException( msg );
    }

    private function _release() : Void
    {
        this._removeAllListeners();
        AsyncCommand.release( this );
    }

    /**
     * Memory handling
     */
    static private var _POOL : Map<AsyncCommand, Bool> = new Map<AsyncCommand, Bool>();

    static private function isDetained( aSynCommand : AsyncCommand ) : Bool
    {
        return AsyncCommand._POOL.exists( aSynCommand );
    }

    static private function detain( aSynCommand : AsyncCommand ) : Void
    {
        AsyncCommand._POOL.set( aSynCommand, true );
    }

    static private function release( aSynCommand : AsyncCommand ) : Void
    {
        if ( AsyncCommand._POOL.exists( aSynCommand ) )
        {
            AsyncCommand._POOL.remove( aSynCommand );
        }
    }
}
