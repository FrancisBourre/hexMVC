package hex.module.dependency;

import hex.di.mapping.Mapping;

/**
 * @author Francis Bourre
 */
interface IRuntimeDependencies
{
    function hasMappedDependencies() : Bool;
    function addMappedDependencies( serviceDependencies : Array<Mapping> ) : Void;
    function getMappedDependencies() : Array<Mapping>;
}