package hex.control;

import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
interface IFrontController
{
    function map( messageType : MessageType, commandClass : Class<ICommand> ) : ICommandMapping;
    function unmap( messageType : MessageType ) : ICommandMapping;
}
