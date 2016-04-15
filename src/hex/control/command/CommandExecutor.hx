package hex.control.command;

import hex.control.async.AsyncCommandUtil;
import hex.control.async.IAsyncCommand;
import hex.control.command.ICommand;
import hex.control.guard.GuardUtil;
import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadUtil;
import hex.di.IDependencyInjector;
import hex.module.IModule;
import Std;

/**
 * ...
 * @author Francis Bourre
 */
class CommandExecutor
{
    var _injector   : IDependencyInjector;
    var _module     : IModule;

    public function new ( injector : IDependencyInjector, ?module : IModule )
    {
        this._injector  = injector;
        this._module    = module;
    }

    public function executeCommand( mapping : ICommandMapping, ?request : Request, ?mappingRemoval : Void->ICommandMapping ) : Void
    {
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
            PayloadUtil.mapPayload( payloads, this._injector );
        }

		// Instantiate command
		var command : ICommand = null;
        if  ( !mapping.hasGuard || GuardUtil.guardsApprove( mapping.getGuards(), this._injector ) )
        {
            if ( mappingRemoval != null )
            {
                mappingRemoval();
            }

            command = this._injector.getOrCreateNewInstance( mapping.getCommandClass() );
			mapping.setLastCommandInstance( command );
        }

		// Unmap payloads
        if ( payloads != null )
        {
            PayloadUtil.unmapPayload( payloads, this._injector );
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

			Reflect.callMethod( command, Reflect.field( command, command.executeMethodName ), [ request ] );
        }
    }
}
