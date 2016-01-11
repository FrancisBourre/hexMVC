package hex.control.command;

import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
interface ICommand
{
    function execute( ?e : Request ) : Void;

    function getPayload() : Array<Dynamic>;

    function getOwner() : IModule;

    function setOwner( owner : IModule ) : Void;
}
