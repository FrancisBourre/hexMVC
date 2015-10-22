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
			payloads = payloads != null ? payloads.concat( (cast e).getExecutionPayloads() ) : (cast e).getExecutionPayloads();
		}

		// Map payloads
        if ( payloads != null )
        {
            this._mapPayload( payloads );
        }

		// Instantiate command
		var command : ICommand = null;
        if  ( !mapping.hasGuard() || CommandExecutor.guardsApprove( mapping.getGuards(), this._injector ) )
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
            this._unmapPayload( payloads );
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
                if ( mapping.hasCompleteListeners() )   this._addListenersToAsyncCommand( mapping.getCompleteListeners(), asynCommand.addCompleteHandler );
                if ( mapping.hasFailListeners() )       this._addListenersToAsyncCommand( mapping.getFailListeners(), asynCommand.addFailHandler );
                if ( mapping.hasCancelListeners() )     this._addListenersToAsyncCommand( mapping.getCancelListeners(), asynCommand.addCancelHandler );
            }

            command.execute( e );
        }
    }

    private function _addListenersToAsyncCommand( listeners : Array<AsyncCommandEvent->Void>, addListener : ( AsyncCommandEvent->Void )->Void ) : Void
    {
        for ( listener in listeners )
        {
            addListener( listener );
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
                if ( Reflect.hasField( guard, "approve" ) )
                {
                    guard = Reflect.field( guard, "approve" );
                }
                else if ( Std.is( guard, Class ) )
                {
                    guard = injector != null ? injector.instantiateUnmapped( guard ) : Type.createInstance( guard, [] );
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
    private function _mapPayload( payloads : Array<ExecutionPayload> ) : Void
    {
        var i : Int = payloads.length;

        while ( --i > -1 )
        {
            var payload : ExecutionPayload = payloads[ i ];
			this._injector.mapToValue( payload.getType(), payload.getData(), payload.getName() );
        }
    }

	/**
	 * Unmap payloads
	 * @param	payloads
	 */
    private function _unmapPayload( payloads : Array<ExecutionPayload> ) : Void
    {
        var i : Int = payloads.length;

        while ( --i > -1 )
        {
            var payload : ExecutionPayload = payloads[ i ];
            this._injector.unmap( payload.getType(), payload.getName()  );
        }
    }
}
