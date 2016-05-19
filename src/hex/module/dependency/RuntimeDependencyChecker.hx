package hex.module.dependency;

import hex.di.IDependencyInjector;
import hex.error.PrivateConstructorException;
import hex.log.Stringifier;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class RuntimeDependencyChecker
{
    /** @private */
    function new()
    {
        throw new PrivateConstructorException( "'RuntimeDependecyChecker' class can't be instantiated." );
    }

    static public function check( module : IModule, injector : IDependencyInjector, dependencies : IRuntimeDependencies ) : Void
    {
        if ( dependencies.hasMappedDependencies() )
        {
            var mappedDependencies : Array<Class<Dynamic>> = dependencies.getMappedDependencies();

            for ( dependency in mappedDependencies )
            {
                if ( !injector.hasMapping( dependency ) )
                {
                    throw new RuntimeDependencyException( "'" + dependency + "' class dependency is not available during '" + Stringifier.stringify( module ) + "' initialisation." );
                }
            }
        }
    }
}
