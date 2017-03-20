package hex.control.trigger;

import hex.control.guard.IGuard;
import hex.control.payload.ExecutionPayload;
import hex.error.Exception;

/**
 * ...
 * @author Francis Bourre
 */
class ExecutionMapping<ResultType> 
{
	var _commandClass 		: Class<Command<ResultType>>;
	var _guards 			: Array<Class<IGuard>>;
	var _payloads 			: Array<ExecutionPayload>;
	
	var _completeHandlers 	: Array<ResultType->Void>;
	var _failHandlers 		: Array<Exception->Void>;
    var _cancelHandlers 	: Array<Void->Void>;

	public function new( commandClass : Class<Command<ResultType>> ) 
	{
		this._commandClass = commandClass;
	}
	
	public function getCommandClass() : Class<Command<ResultType>>
	{
		return this._commandClass;
	}
	
	@:isVar public var hasGuard( get, null ) : Bool;
	function get_hasGuard() : Bool
	{
		return this._guards != null;
	}
	
    public function getGuards() : Array<Class<IGuard>>
    {
        return this._guards;
    }
	
	public function withGuard( guard : Class<IGuard> ) : ExecutionMapping<ResultType> 
    {
        if ( this._guards == null )
        {
            this._guards = new Array<Class<IGuard>>();
        }

        this._guards.push( guard );
        return this;
    }
	
	@:isVar public var hasPayload( get, null ) : Bool;
	function get_hasPayload() : Bool
	{
		return this._payloads != null;
	}

    public function getPayloads() : Array<ExecutionPayload>
    {
        return this._payloads;
    }
	
	public function asPayload( value : Dynamic, type : Class<Dynamic>, name = '', className : String = '' ) : ExecutionMapping<ResultType> 
    {
		return className == '' ? this.withPayload( new ExecutionPayload( value, type, name ) ):
			this.withPayload( new ExecutionPayload( value, type, name ).withClassName( className ) );
	}

    public function withPayload( payload : ExecutionPayload ) : ExecutionMapping<ResultType> 
    {
        if ( this._payloads == null )
        {
            this._payloads = new Array<ExecutionPayload>();
        }

        this._payloads.push( payload );
        return this;
    }

    public function getCompleteHandlers() : Array<ResultType->Void>
    {
        return this._completeHandlers;
    }

	@:isVar public var hasCompleteHandler( get, null ) : Bool;
	function get_hasCompleteHandler() : Bool
	{
		return this._completeHandlers != null;
	}

    public function withCompleteHandler( handler : ResultType->Void ) : ExecutionMapping<ResultType> 
    {
        if ( this._completeHandlers == null )
        {
            this._completeHandlers = [];
        }

        this._completeHandlers.push( handler );
        return this;
    }

    public function getFailHandlers() : Array<Exception->Void>
    {
        return this._failHandlers;
    }
	
	@:isVar public var hasFailHandler( get, null ) : Bool;
	function get_hasFailHandler() : Bool
	{
		return this._failHandlers != null;
	}

    public function withFailHandler( handler : Exception->Void ) : ExecutionMapping<ResultType> 
    {
        if ( this._failHandlers == null )
        {
            this._failHandlers = [];
        }

        this._failHandlers.push( handler );
        return this;
    }

    public function getCancelHandlers() : Array<Void->Void>
    {
        return this._cancelHandlers;
    }
	
	@:isVar public var hasCancelHandler( get, null ) : Bool;
	function get_hasCancelHandler() : Bool
	{
		return this._cancelHandlers != null;
	}

    public function withCancelHandler( handler : Void->Void ) : ExecutionMapping<ResultType> 
    {
        if ( this._cancelHandlers == null )
        {
            this._cancelHandlers = [];
        }

        this._cancelHandlers.push( handler );
        return this;
    }
}