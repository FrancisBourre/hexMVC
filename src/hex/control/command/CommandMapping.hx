package hex.control.command;

import haxe.Constraints.Function;
import hex.control.command.ICommand;
import hex.control.payload.ExecutionPayload;
import hex.di.IContextOwner;
import hex.event.Dispatcher;
import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class CommandMapping implements ICommandMapping
{
    var _commandClass               : Class<ICommand>;
    var _guards                     : Array<Dynamic>;
    var _payloads                   : Array<ExecutionPayload>;
	
    var _contextOwner               : IContextOwner;
	
    var _completeHandlers          	: Array<Function>;
    var _cancelHandlers            	: Array<Function>;
    var _failHandlers              	: Array<Function>;
	
    var _mappingResults             : Array<ICommandMapping>;
	
	var _command 					: ICommand;

    public function new( commandClass : Class<ICommand> )
    {
        this._commandClass  = commandClass;
        this.isFiredOnce    = false;
    }

    public function getCommandClass() : Class<ICommand>
    {
        return this._commandClass;
    }

	@:isVar public var hasGuard( get, null ) : Bool;
	function get_hasGuard() : Bool
	{
		return this._guards != null;
	}
	
    public function getGuards() : Array<Dynamic>
    {
        return this._guards;
    }

    public function withGuard( guard : Dynamic ) : ICommandMapping
    {
        if ( this._guards == null )
        {
            this._guards = new Array<Dynamic>();
        }

        this._guards.push( guard );
        return this;
    }
	
	@:isVar public var isFiredOnce( get, null ) : Bool;
	function get_isFiredOnce() : Bool
	{
		return this.isFiredOnce;
	}

    public function once() : ICommandMapping
    {
        this.isFiredOnce = true;
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

    public function withPayload( payload : ExecutionPayload ) : ICommandMapping
    {
        if ( this._payloads == null )
        {
            this._payloads = new Array<ExecutionPayload>();
        }

        this._payloads.push( payload );
        return this;
    }

    public function getCompleteHandlers() : Array<Function>
    {
        return this._completeHandlers;
    }

	@:isVar public var hasCompleteHandler( get, null ) : Bool;
	function get_hasCompleteHandler() : Bool
	{
		return this._completeHandlers != null;
	}

    public function withCompleteHandler( handler : Function ) : ICommandMapping
    {
        if ( this._completeHandlers == null )
        {
            this._completeHandlers = new Array<Function>();
        }

        this._completeHandlers.push( handler );
        return this;
    }

    public function getFailHandlers() : Array<Function>
    {
        return this._failHandlers;
    }
	
	@:isVar public var hasFailHandler( get, null ) : Bool;
	function get_hasFailHandler() : Bool
	{
		return this._failHandlers != null;
	}

    public function withFailHandler( handler : Function ) : ICommandMapping
    {
        if ( this._failHandlers == null )
        {
            this._failHandlers = [];
        }

        this._failHandlers.push( handler );
        return this;
    }

    public function getCancelHandlers() : Array<Function>
    {
        return this._cancelHandlers;
    }
	
	@:isVar public var hasCancelHandler( get, null ) : Bool;
	function get_hasCancelHandler() : Bool
	{
		return this._cancelHandlers != null;
	}

    public function withCancelHandler( handler : Function ) : ICommandMapping
    {
        if ( this._cancelHandlers == null )
        {
            this._cancelHandlers = [];
        }

        this._cancelHandlers.push( handler );
        return this;
    }
	
	public function setContextOwner( contextOwner : IContextOwner ) : Void
	{
		this._contextOwner = contextOwner;
	}
	
	public function getContextOwner() : IContextOwner
	{
		return this._contextOwner;
	}

	@:isVar public var hasMappingResult( get, null ) : Bool;
	function get_hasMappingResult() : Bool
	{
		return this._mappingResults != null;
	}
	
    public function withMappingResult( mappingResult : ICommandMapping ) : ICommandMapping
	{
		if ( this._mappingResults == null )
        {
            this._mappingResults = [];
        }
		
		this._mappingResults.push( mappingResult );
		return this;
	}
	
	public function setLastCommandInstance( command : ICommand ) : Void
	{
		this._command = command;
	}
	
	public function getPayloadResult() : Array<ExecutionPayload>
    {
		var payload : Array<ExecutionPayload> = [];
		
		if ( this._mappingResults != null )
		{
			for ( mapping in this._mappingResults )
			{
				var command : ICommand = cast ( mapping, CommandMapping )._command;
				if ( command != null  )
				{
					var returnedExecutionPayload : Array<ExecutionPayload> = command.getReturnedExecutionPayload();
					
					if ( returnedExecutionPayload != null )
					{
						payload = payload.concat( command.getReturnedExecutionPayload() );
					}
				}
			}
		}
		
		return payload.length > 0 ? payload : null;
    }
}
