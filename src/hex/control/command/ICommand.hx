package hex.control.command;

import hex.control.payload.ExecutionPayload;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
interface ICommand
{
    function execute( ?e : Request ) : Void;

    function getResult() : Array<Dynamic>;
	
	function getReturnedExecutionPayload() : Array<ExecutionPayload>;

    function getOwner() : IModule;

    function setOwner( owner : IModule ) : Void;
}
