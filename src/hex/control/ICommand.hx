package hex.control;

import hex.event.IEvent;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
interface ICommand
{
    function execute( ?e : IEvent ) : Void;

    function getPayload() : Array<Dynamic>;

    function getOwner() : IModule;

    function setOwner( owner : IModule ) : Void;
}
