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
     * Add a guards to query before execution
     */
    function withGuard( guard : Dynamic ) : ICommandMapping;

    /**
     * Returns true if command mapped should be fired once
     */
	var isFiredOnce( get, null ) : Bool;

    /**
     * Unmaps a Command after first successful execution
     */
    function once() : ICommandMapping;
	
	/**
     * AReturns true if mapping has payloads to be injected during execution
     */
	var hasPayload( get, null ) : Bool;

    /**
     * A list of payloads to be injected during execution
     */
    function getPayloads() : Array<ExecutionPayload>;

    /**
     * Add a payload to be injected during execution
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
     * Add a complete callback
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
     * Add a fail callback
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
     * Add a cancel callback
     */
    function withCancelHandler( handler : Function ) : ICommandMapping;
	
	
	function setContextOwner( contextOwner : IContextOwner ) : Void;
	
	function getContextOwner() : IContextOwner;
	
	/**
     * Returns true if mapping has mapping results
     */
	var hasMappingResult( get, null ) : Bool;

    /**
     * Add a mapping result
     */
	function withMappingResult( mappingResult : ICommandMapping ) : ICommandMapping;
	
	/**
     * A list of payloads taken from mapping results
     */
	function getPayloadResult() : Array<ExecutionPayload>;
	
	/**
     * Store last command instance executed from this mapping
     */
	function setLastCommandInstance( command : ICommand ) : Void;
}
