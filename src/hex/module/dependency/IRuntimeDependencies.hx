package hex.module.dependency;

/**
 * @author Francis Bourre
 */
interface IRuntimeDependencies
{
    function hasMappedDependencies() : Bool;
    function addMappedDependencies( serviceDependencies : Array<Class<Dynamic>> ) : Void;
    function getMappedDependencies() : Array<Class<Dynamic>>;
}