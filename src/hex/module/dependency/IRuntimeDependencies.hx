package hex.module.dependency;

/**
 * @author Francis Bourre
 */
interface IRuntimeDependencies 
{
    function hasServiceDependencies() : Bool;
    function addServiceDependencies( serviceDependencies : Array<Class<Dynamic>> ) : Void;
    function getServiceDependencies() : Array<Class<Dynamic>>;
}