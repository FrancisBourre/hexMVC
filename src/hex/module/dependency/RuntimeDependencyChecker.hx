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
        throw new PrivateConstructorException();
    }

    static public function check( module : IModule, injector : IDependencyInjector, dependencies : IRuntimeDependencies ) : Void
    {
        if ( dependencies.hasMappedDependencies() )
        {
            var mappedDependencies = dependencies.getMappedDependencies();

            for ( dependency in mappedDependencies )
            {
                if ( !injector.hasMapping( dependency.type, dependency.name ) )
                {
                    throw new RuntimeDependencyException( "'" + dependency + "' dependency is not available during '" + Stringifier.stringify( module ) + "' initialisation." );
                }
            }
        }
    }
}
