package hex.control;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;

/**
 * ...
 * @author Francis Bourre
 */
interface IFrontController
{
    function map( eventType : String, commandClass : Class<ICommand> ) : ICommandMapping;
    function unmap( eventType : String ) : ICommandMapping;
}
