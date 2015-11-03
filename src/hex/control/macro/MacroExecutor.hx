package hex.control.macro;

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
	
    private var _module     				: IModule;

	private var _commandIndex 				: Int;
	private var _commandCalledCount 		: Int;
	private var _asyncCommandListener 		: IAsyncCommandListener;
	private var _runningAsyncCommandList 	: Array<IAsyncCommand>;
	
	private var _commandMappingCollection  : Array<ICommandMapping> = [];
	
	public function new()
	{
		
	}

	public function initialize( ?module : IModule ) : Void
	{
		//this._injector  				= injector;
        this._module    				= module;
		this._runningAsyncCommandList 	= [];
		this._commandIndex				= 0;
		
		//this._injector 					= this._injector.createChild();
		//MetaDataProvider.getInstance().registerInjector( this._injector );
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

		// Unmap payloads
        if ( payloads != null )
        {
            PayloadUtil.unmapPayload( payloads, this.injector );
        }

		// Execute command
        if ( command != null )
        {
            command.setOwner( this._module );

            var isAsync : Bool = Std.is( command, IAsyncCommand );
            if ( isAsync )
            {
                var asynCommand : IAsyncCommand = cast( command, IAsyncCommand );
                asynCommand.preExecute();
                if ( mapping.hasCompleteHandler )   AsyncCommandUtil.addListenersToAsyncCommand( mapping.getCompleteHandlers(), asynCommand.addCompleteHandler );
                if ( mapping.hasFailHandler )       AsyncCommandUtil.addListenersToAsyncCommand( mapping.getFailHandlers(), asynCommand.addFailHandler );
                if ( mapping.hasCancelHandler )     AsyncCommandUtil.addListenersToAsyncCommand( mapping.getCancelHandlers(), asynCommand.addCancelHandler );
            }

            command.execute( e );
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
	
	public function setAsyncCommandListener( listener:IAsyncCommandListener ) : Void
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