package hex.control;

import hex.control.CommandExecutor;
import hex.di.IDependencyInjector;
import hex.event.IEvent;
import hex.module.IModule;
import Reflect;
import Std;
import Type;

/**
 * ...
 * @author Francis Bourre
 */
class CommandExecutor
{
    private var _injector   : IDependencyInjector;
    private var _module     : IModule;

    public function new ( injector : IDependencyInjector, ?module : IModule )
    {
        this._injector  = injector;
        this._module    = module;
        //MetaDataProvider.getInstance().registerInjector( this._injector );
    }

    public function executeCommand( e : IEvent, mapping : ICommandMapping, ?mappingRemoval : Void->ICommandMapping ) : Void
    {
		// Build payloads collection
		var payloads : Array<ExecutionPayload> = mapping.getPayloads();
		if ( Std.is( e, PayloadEvent ) )
		{
			payloads = payloads != null ? payloads.concat( ( cast e ).getExecutionPayloads() ) : ( cast e ).getExecutionPayloads();
		}

		// Map payloads
        if ( payloads != null )
        {
            CommandExecutor.mapPayload( payloads, this._injector );
        }

		// Instantiate command
		var command : ICommand = null;
        if  ( !mapping.hasGuard || CommandExecutor.guardsApprove( mapping.getGuards(), this._injector ) )
        {
            if ( mappingRemoval != null )
            {
                mappingRemoval();
            }

            command = this._injector.getOrCreateNewInstance( mapping.getCommandClass() );
        }

		// Unmap payloads
        if ( payloads != null )
        {
            CommandExecutor.unmapPayload( payloads, this._injector );
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
                if ( mapping.hasCompleteHandler )   CommandExecutor.addListenersToAsyncCommand( mapping.getCompleteHandlers(), asynCommand.addCompleteHandler );
                if ( mapping.hasFailHandler )       CommandExecutor.addListenersToAsyncCommand( mapping.getFailHandlers(), asynCommand.addFailHandler );
                if ( mapping.hasCancelHandler )     CommandExecutor.addListenersToAsyncCommand( mapping.getCancelHandlers(), asynCommand.addCancelHandler );
            }

            command.execute( e );
        }
    }

    static public function addListenersToAsyncCommand( listeners : Array<AsyncCommandEvent->Void>, methodToAddListener : ( AsyncCommandEvent->Void )->Void ) : Void
    {
        for ( listener in listeners )
        {
            methodToAddListener( listener );
        }
    }

	/**
	 * Approve guards
	 * @param	guards
	 * @param	injector
	 * @return
	 */
    static public function guardsApprove( ?guards : Array<Dynamic>, ?injector : IDependencyInjector ) : Bool
    {
        if ( guards != null )
        {
            for ( guard in guards )
            {
                if ( Reflect.hasField( guard, "approve" ) ){
                    guard = Reflect.field( guard, "approve" );
                }
                else if ( Std.is( guard, Class ) )
                {
                    guard = injector != null ? injector.instantiateUnmapped( guard ) : Type.createInstance( guard, [] );
					guard = guard.approve;
                }

                if ( Reflect.isFunction( guard ) )
                {
                    var scope : Dynamic = Reflect.field( guard, "scope" );
                    var b : Bool = Reflect.callMethod( scope, guard, [] );

                    if ( !b )
                    {
                        return false;
                    }
                }
            }
        }

        return true;
    }

	/**
	 * Map payloads
	 * @param	payload
	 */
    static public function mapPayload( payloads : Array<ExecutionPayload>, injector : IDependencyInjector ) : Void
    {
        for ( payload in payloads ) 
		{
			injector.mapToValue( payload.getType(), payload.getData(), payload.getName() );
		}
    }

	/**
	 * Unmap payloads
	 * @param	payloads
	 */
    static public function unmapPayload( payloads : Array<ExecutionPayload>, injector : IDependencyInjector ) : Void
    {
        for ( payload in payloads ) 
		{
			injector.unmap( payload.getType(), payload.getName() );
		}
    }
}
