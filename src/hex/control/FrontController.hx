package hex.control;

import hex.collection.Locator;
import hex.control.command.CommandExecutor;
import hex.control.command.CommandMapping;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.di.IDependencyInjector;
import hex.event.IDispatcher;
import hex.event.MessageType;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class FrontController extends Locator<MessageType, ICommandMapping> implements IFrontController
{
    var _module     		: IModule;
    var _injector   		: IDependencyInjector;
    var _facadeDispatcher 	: IDispatcher<{}>;

    public function new( facadeDispatcher : IDispatcher<{}>, injector : IDependencyInjector, ?module : IModule )
    {
        super();

        this._facadeDispatcher 		= facadeDispatcher;
        this._injector 				= injector;
        this._module 				= module;
		
		this._facadeDispatcher.addListener( this );
    }

    public function map( messageType : MessageType, commandClass : Class<ICommand> ) : ICommandMapping
    {
        var commandMapping = new CommandMapping( commandClass );
        this.register( messageType, commandMapping );
        return commandMapping;
    }

    public function unmap( messageType : MessageType ) : ICommandMapping
    {
        var commandMapping : ICommandMapping = this.locate( messageType );
        this.unregister( messageType );
        return commandMapping;
    }

    public function handleMessage( messageType : MessageType, ?request : Request ) : Void
    {
        if ( this.isRegisteredWithKey( messageType ) )
        {
            var commandMapping : ICommandMapping    = this.locate( messageType );
            var commandExecutor = new CommandExecutor( this._injector, this._module );

            var mappingRemoval : Void->ICommandMapping  = null;
            if ( commandMapping.isFiredOnce )
            {
                mappingRemoval = this.unmap.bind( messageType );
            }

            commandExecutor.executeCommand( commandMapping, request, mappingRemoval );
        }
    }
}
