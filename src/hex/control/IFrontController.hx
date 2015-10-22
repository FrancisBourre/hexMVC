package hex.control;

/**
 * ...
 * @author Francis Bourre
 */
interface IFrontController
{
    function map( eventType : String, commandClass : Class<ICommand> ) : ICommandMapping;
    function unmap( eventType : String ) : ICommandMapping;
}
