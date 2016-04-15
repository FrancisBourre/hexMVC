package hex.control.macro;

import hex.control.async.AsyncCommandUtil;
import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
import hex.control.command.CommandMapping;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.control.guard.GuardUtil;
import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadUtil;
import hex.di.IBasicInjector;
import hex.di.IContextOwner;
import hex.di.IInjectorContainer;
import hex.error.IllegalStateException;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class MacroExecutor implements IMacroExecutor implements IInjectorContainer
{
	@Inject
	public var injector   			: IBasicInjector;
	
	var _commandIndex 				: Int;
	var _commandCalledCount 		: Int;
	var _asyncCommandListener 		: IAsyncCommandListener;
	var _runningAsyncCommandList 	: Array<IAsyncCommand>;
	
	var _commandMappingCollection  	: Array<ICommandMapping> = [];
	
	public function new()
	{
		this._runningAsyncCommandList 	= [];
		this._commandIndex				= 0;
		this._commandCalledCount 		= 0;
	}
	
	public function executeCommand( mapping : ICommandMapping, ?request : Request ) : ICommand
    {
		// Set injector
		var injector : IBasicInjector = null;
		var contextOwner : IContextOwner = mapping.getContextOwner();

		if ( contextOwner != null )
		{
			injector = contextOwner.getBasicInjector();
		}
		else
		{
			injector = this.injector;
		}

		// Build payloads collection
		var payloads : Array<ExecutionPayload> = mapping.getPayloads();
		if ( request != null )
		{
			payloads = payloads != null ? payloads.concat( request.getExecutionPayloads() ) : request.getExecutionPayloads();
		}
		
		// Get payloads from mapping results
		if ( mapping.hasMappingResult )
		{
			payloads = payloads != null ? payloads.concat( mapping.getPayloadResult() ) : mapping.getPayloadResult();
		}

		// Map payloads
        if ( payloads != null )
        {
            PayloadUtil.mapPayload( payloads, injector );
        }

		// Instantiate command
		var command : ICommand = null;
        if  ( !mapping.hasGuard || GuardUtil.guardsApprove( mapping.getGuards(), injector ) )
        {
            command = injector.getOrCreateNewInstance( mapping.getCommandClass() );
			mapping.setLastCommandInstance( command );
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
            PayloadUtil.unmapPayload( payloads, injector );
        }

		// Execute command
        if ( command != null )
        {
			if ( injector.hasMapping( IModule ) )
			{
				command.setOwner ( injector.getInstance( IModule ) );
			}

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

			Reflect.callMethod( command, Reflect.field( command, command.executeMethodName ), [ request ] );
			
			if ( !isAsync )
			{
				this._commandCalledCount++;
			}
        }
		
		return command;
    }
	
	@:isVar public var commandIndex( get, null ) : Int;
	public function get_commandIndex() : Int 
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
		var mapping = new CommandMapping( commandClass );
		this._commandMappingCollection.push( mapping );
		return mapping;
	}

	public function addMapping( mapping : ICommandMapping ) : ICommandMapping
	{
		this._commandMappingCollection.push( mapping );
		return mapping;
	}
	
	public function executeNextCommand( ?request : Request ) : ICommand
	{
		return this.executeCommand( this._commandMappingCollection[ this._commandIndex++ ], request );
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