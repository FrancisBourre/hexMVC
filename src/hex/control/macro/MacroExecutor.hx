package hex.control.macro;

import hex.control.async.AsyncCommandEvent;
import hex.control.async.AsyncCommandUtil;
import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
import hex.control.command.CommandMapping;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.control.guard.GuardUtil;
import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadEvent;
import hex.control.payload.PayloadUtil;
import hex.di.IDependencyInjector;
import hex.error.IllegalStateException;
import hex.event.IEvent;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class MacroExecutor implements IMacroExecutor
{
	@inject
	public var injector   					: IDependencyInjector;
	
	@inject
    public var module     					: IModule;

	private var _commandIndex 				: Int;
	private var _commandCalledCount 		: Int;
	private var _asyncCommandListener 		: IAsyncCommandListener;
	private var _runningAsyncCommandList 	: Array<IAsyncCommand>;
	
	private var _commandMappingCollection  	: Array<ICommandMapping> = [];
	
	public function new()
	{
		this._runningAsyncCommandList 	= [];
		this._commandIndex				= 0;
		this._commandCalledCount 		= 0;
	}
	
	public function executeCommand( mapping : ICommandMapping, ?e : IEvent ) : ICommand
    {
		// Build payloads collection
		var payloads : Array<ExecutionPayload> = mapping.getPayloads();
		if ( e != null && Std.is( e, PayloadEvent ) )
		{
			payloads = payloads != null ? payloads.concat( ( cast e ).getExecutionPayloads() ) : ( cast e ).getExecutionPayloads();
		}

		// Map payloads
        if ( payloads != null )
        {
            PayloadUtil.mapPayload( payloads, this.injector );
        }

		// Instantiate command
		var command : ICommand = null;
        if  ( !mapping.hasGuard || GuardUtil.guardsApprove( mapping.getGuards(), this.injector ) )
        {
            command = this.injector.getOrCreateNewInstance( mapping.getCommandClass() );
        }
		else
		{
			this._commandCalledCount++;
			this._asyncCommandListener.onAsyncCommandFail( null );
			return null;
		}

		// Unmap payloads
        if ( payloads != null )
        {
            PayloadUtil.unmapPayload( payloads, this.injector );
        }

		// Execute command
        if ( command != null )
        {
            command.setOwner( this.module );

            var isAsync : Bool = Std.is( command, IAsyncCommand );
            if ( isAsync )
            {
                var aSyncCommand : IAsyncCommand = cast( command, IAsyncCommand );
                aSyncCommand.preExecute();
                if ( mapping.hasCompleteHandler )   AsyncCommandUtil.addListenersToAsyncCommand( mapping.getCompleteHandlers(), aSyncCommand.addCompleteHandler );
                if ( mapping.hasFailHandler )       AsyncCommandUtil.addListenersToAsyncCommand( mapping.getFailHandlers(), aSyncCommand.addFailHandler );
                if ( mapping.hasCancelHandler )     AsyncCommandUtil.addListenersToAsyncCommand( mapping.getCancelHandlers(), aSyncCommand.addCancelHandler );
				
				aSyncCommand.addAsyncCommandListener( this._asyncCommandListener );
                this._runningAsyncCommandList.push( aSyncCommand );
            }

            command.execute( e );
			if ( !isAsync )
			{
				this._commandCalledCount++;
			}
        }
		
		return command;
    }
	
	@:isVar public var subCommandIndex( get, null ) : Int;
	public function get_subCommandIndex() : Int 
	{
		return this._commandIndex;
	}
	
	@:isVar public var hasRunEveryCommand( get, null ) : Bool;
	public function get_hasRunEveryCommand() : Bool
	{
		return this._commandCalledCount == this._commandMappingCollection.length;
	}
	
	public function setAsyncCommandListener( listener : IAsyncCommandListener ) : Void
	{
		this._asyncCommandListener = listener;
	}

	@:isVar public var hasNextCommandMapping( get, null ) : Bool;
	public function get_hasNextCommandMapping() : Bool
	{
		return this._commandMappingCollection != null && this._commandIndex < this._commandMappingCollection.length;
	}

	public function add( commandClass : Class<ICommand> ) : ICommandMapping
	{
		var mapping : ICommandMapping = new CommandMapping( commandClass );
		this._commandMappingCollection.push( mapping );
		return mapping;
	}

	public function addMapping( mapping : ICommandMapping ) : ICommandMapping
	{
		this._commandMappingCollection.push( mapping );
		return mapping;
	}
	
	public function executeNextCommand( ?e : IEvent ) : ICommand
	{
		return this.executeCommand( this._commandMappingCollection[ this._commandIndex++ ], e );
	}
	
	public function asyncCommandCalled( asyncCommand : IAsyncCommand ) : Void
	{
		var index : Int = this._runningAsyncCommandList.indexOf( asyncCommand );
		
		if ( index > -1 )
		{
			this._runningAsyncCommandList.splice( index, 1 );
			this._commandCalledCount++;
		}
		else
		{
			throw new IllegalStateException( "Following command was not running: " + asyncCommand );
		}
	}
	
}