package hex.control;

/**
 * ...
 * @author Francis Bourre
 */
class CommandMapping implements ICommandMapping
{
    private var _commandClass               : Class<ICommand>;
    private var _guards                     : Array<Dynamic>;
    private var _fireOnce                   : Bool;
    private var _payloads                   : Array<ExecutionPayload>;
    private var _completeListeners          : Array<AsyncCommandEvent->Void>;
    private var _cancelListeners            : Array<AsyncCommandEvent->Void>;
    private var _failListeners              : Array<AsyncCommandEvent->Void>;

    public function new( commandClass : Class<ICommand> )
    {
        this._commandClass  = commandClass;
        this._fireOnce      = false;
    }

    public function getCommandClass() : Class<ICommand>
    {
        return this._commandClass;
    }

    public function getGuards() : Array<Dynamic>
    {
        return this._guards;
    }

    public function hasGuard() : Bool
    {
        return this._guards != null;
    }

    public function withGuards( guards : Array<Dynamic> ) : ICommandMapping
    {
        if ( this._guards == null )
        {
            this._guards = new Array<Dynamic>();
        }

        this._guards = this._guards.concat( guards );
        return this;
    }

    public function isFiredOnce() : Bool
    {
        return this._fireOnce;
    }

    public function once() : ICommandMapping
    {
        this._fireOnce = true;
        return this;
    }

    public function getPayloads() : Array<ExecutionPayload>
    {
        return this._payloads;
    }

    public function hasPayload() : Bool
    {
        return this._payloads != null;
    }

    public function withPayloads( payloads : Array<ExecutionPayload> ) : ICommandMapping
    {
        if ( this._payloads == null )
        {
            this._payloads = new Array<ExecutionPayload>();
        }

        this._payloads = this._payloads.concat( payloads );
        return this;
    }

    public function getCompleteListeners() : Array<AsyncCommandEvent->Void>
    {
        return this._completeListeners;
    }

    public function hasCompleteListeners() : Bool
    {
        return this._completeListeners != null;
    }

    public function withCompleteListeners( listeners : Array<AsyncCommandEvent->Void> ) : ICommandMapping
    {
        if ( this._completeListeners == null )
        {
            this._completeListeners = new Array<AsyncCommandEvent->Void>();
        }

        this._completeListeners = this._completeListeners.concat( listeners );
        return this;
    }

    public function getFailListeners() : Array<AsyncCommandEvent->Void>
    {
        return this._failListeners;
    }

    public function hasFailListeners() : Bool
    {
        return this._failListeners != null;
    }

    public function withFailListeners( listeners : Array<AsyncCommandEvent->Void> ) : ICommandMapping
    {
        if ( this._failListeners == null )
        {
            this._failListeners = new Array<AsyncCommandEvent->Void>();
        }

        this._failListeners = this._failListeners.concat( listeners );
        return this;
    }

    public function getCancelListeners() : Array<AsyncCommandEvent->Void>
    {
        return this._cancelListeners;
    }

    public function hasCancelListeners() : Bool
    {
        return this._cancelListeners != null;
    }

    public function withCancelListeners( listeners : Array<AsyncCommandEvent->Void> ) : ICommandMapping
    {
        if ( this._cancelListeners == null )
        {
            this._cancelListeners = new Array<AsyncCommandEvent->Void>();
        }

        this._cancelListeners = this._cancelListeners.concat( listeners );
        return this;
    }

    //public function withMappingResults( results : Array<Dynamic> ) : ICommandMapping;
}
