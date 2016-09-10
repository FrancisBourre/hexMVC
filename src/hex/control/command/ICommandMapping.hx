package hex.control.command;

import haxe.Constraints.Function;
import hex.control.command.ICommand;
import hex.control.payload.ExecutionPayload;
import hex.di.IContextOwner;

/**
 * ...
 * @author Francis Bourre
 */
interface ICommandMapping
{
    /**
     * The concrete Command Class for this mapping
     */
    function getCommandClass() : Class<ICommand>;

    /**
     * Returns true if mapping has guard
     */
    var hasGuard( get, null ) : Bool;

    /**
     * A list of Guards to query before execution
     */
    function getGuards() : Array<Dynamic>;

    /**
     * A list of Guards to query before execution
     */
    function withGuard( guard : Dynamic ) : ICommandMapping;

    /**
     * Unmaps a Command after a successful execution
     */
	var isFiredOnce( get, null ) : Bool;

    /**
     * Unmaps a Command after a successful execution
     */
    function once() : ICommandMapping;
	
	/**
     * A list of payloads to be injected during execution
     */
	var hasPayload( get, null ) : Bool;

    /**
     * A list of payloads to be injected during execution
     */
    function getPayloads() : Array<ExecutionPayload>;

    /**
     * A list of payloads to be injected during execution
     */
    function withPayload( payload : ExecutionPayload ) : ICommandMapping;

    /**
     * A list of complete callbacks
     */
    function getCompleteHandlers() : Array<Function>;

    /**
     * Returns true if mapping has complete callbacks
     */
	var hasCompleteHandler( get, null ) : Bool;

    /**
     * A list of complete callbacks
     */
    function withCompleteHandler( handler : Function ) : ICommandMapping;

    /**
     * A list of fail callbacks
     */
    function getFailHandlers() : Array<Function>;

    /**
     * Returns true if mapping has fail callbacks
     */
	var hasFailHandler( get, null ) : Bool;

    /**
     * A list of fail callbacks
     */
    function withFailHandler( handler : Function ) : ICommandMapping;

    /**
     * A list of cancel callbacks
     */
    function getCancelHandlers() : Array<Function>;

    /**
     * Returns true if mapping has cancel callbacks
     */
	var hasCancelHandler( get, null ) : Bool;

    /**
     * A list of cancel callbacks
     */
    function withCancelHandler( handler : Function ) : ICommandMapping;
	
	
	function setContextOwner( contextOwner : IContextOwner ) : Void;
	
	function getContextOwner() : IContextOwner;
	
	/**
     * A list of mapping results
     */
	var hasMappingResult( get, null ) : Bool;

    /**
     * A list of mapping results
     */
	function withMappingResults( mappingResults : Array<ICommandMapping> ) : ICommandMapping;
	
	/**
     * A list of payloads taken from mapping results
     */
	function getPayloadResult() : Array<ExecutionPayload>;
	
	/**
     * Last command executed from this mapping
     */
	function setLastCommandInstance( command : ICommand ) : Void;
}
