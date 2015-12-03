package hex.config.stateful;

import hex.di.IDependencyInjector;
import hex.event.IEvent;
import hex.event.IEventDispatcher;
import hex.event.IEventListener;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
interface IStatefulConfig
{
    function configure( injector : IDependencyInjector, dispatcher : IEventDispatcher<IEventListener, IEvent>, module : IModule ) : Void;
}
