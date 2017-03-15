package hex.control.trigger;

import hex.control.guard.GuardUtil;
import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadUtil;
import hex.di.IDependencyInjector;
import hex.error.Exception;
import hex.error.VirtualMethodException;
import hex.util.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class MacroCommand<ResultType> extends Command<ResultType>
{
	var _injector 			: IDependencyInjector;
	var _payloads 			: Array<ExecutionPayload>;
	var _mappings 			: Array<ExecutionMapping<ResultType>> = [];
	var _parallelExecution	: Int;
	
	public function new() 
	{
		super();
		
		this.isAtomic 			= true;
		this.isInSequenceMode 	= true;
	}
	
	@Inject
	public function preExecute( injector : IDependencyInjector, payloads : Array<ExecutionPayload> ) : Void
	{
		this._injector = injector;
		this._payloads = payloads;
		this._prepare();
	}
	
	function _prepare() : Void
	{
		throw new VirtualMethodException();
	}

	@:final 
	override public function execute() : Void
	{
		this._parallelExecution = this._mappings.length;
		this._executeNextCommand( null );
	}

	public function add( commandClass : Class<Command<ResultType>> ) : ExecutionMapping<ResultType>
	{
		var mapping = new ExecutionMapping( commandClass );
		this._mappings.push( mapping );
		return mapping;
	}
	
	function _executeNextCommand( r : ResultType = null ) : Void
	{
		if ( this._mappings.length > 0 )
		{
			var command = MacroCommand.getCommand( this._injector, this._mappings.shift(), this._payloads );
			
			if ( command != null )
			{
				command.execute();
				
				if ( this.isInSequenceMode )
				{
					command
						.onComplete( this._onComplete )
							.onFail( this._onFail )
								.onCancel( this._onCancel );
				}
				else
				{
					command
						.onComplete( this._onParallelComplete )
							.onFail( this._onParallelFail )
								.onCancel( this._onParallelCancel );
								
					this._executeNextCommand();
				}
			}
			else
			{
				//command fails
				if ( this.isAtomic )
				{
					this._fail( new Exception( 'MacroCommand fails' ) );
				}
				else
				{
					this._executeNextCommand();
				}
			}
			
		}
		else if ( this.isInSequenceMode )
		{
			this._complete( r );
		}
	}
	
	function _onComplete( result : ResultType ) : Void
	{
		this._executeNextCommand( result );
	}
	
	function _onFail( e : Exception ) : Void
	{
		if ( this.isAtomic )
		{
			this._fail( e );
		}
		else
		{
			this._executeNextCommand();
		}
	}
	
	function _onCancel() : Void
	{
		if ( this.isAtomic )
		{
			this._cancel();
		}
		else
		{
			this._executeNextCommand();
		}
	}
	
	function _onParallelComplete( result : ResultType ) : Void
	{
		this._parallelExecution--;
		if ( this._parallelExecution == 0 )
		{
			this._parallelExecution = -1;
			this._complete( result );
		}
	}
	
	function _onParallelFail( e : Exception ) : Void
	{
		this._parallelExecution--;
		
		if ( this.isAtomic && this._parallelExecution > -1 )
		{
			this._parallelExecution = -1;
			this._fail( e );
		}
		else if( this._parallelExecution == 0 )
		{
			this._complete( null );
		}
	}
	
	function _onParallelCancel() : Void
	{
		this._parallelExecution--;
		
		if ( this.isAtomic && this._parallelExecution > -1 )
		{
			this._parallelExecution = -1;
			this._cancel();
		}
		else if( this._parallelExecution == 0 )
		{
			this._complete( null );
		}
	}
	
	@:isVar public var isAtomic( get, set ) : Bool;
	function get_isAtomic() : Bool
	{
		return this.isAtomic;
	}
	
	function set_isAtomic( value : Bool ) : Bool
	{
		this.isAtomic = value;
		return value;
	}
	
	@:isVar public var isInSequenceMode( get, set ) : Bool;
	function get_isInSequenceMode() : Bool
	{
		return this.isInSequenceMode;
	}
	
	function set_isInSequenceMode( value : Bool ) : Bool
	{
		this.isInSequenceMode = value;
		return value;
	}
	
	@:isVar
	public var isInParallelMode( get, set ) : Bool;
	function get_isInParallelMode() : Bool
	{
		return !this.isInSequenceMode;
	}
	
	function set_isInParallelMode( value : Bool ) : Bool
	{
		this.isInSequenceMode = !value;
		return this.isInSequenceMode;
	}
	
	public function toString() : String
	{
		return Stringifier.stringify( this );
	}
	
	//
	static public function getCommand<ResultType>( injector : IDependencyInjector, mapping : ExecutionMapping<ResultType>, payloads : Array<ExecutionPayload> ) : Command<ResultType>
    {
		// Build payloads collection
		var mappedPayloads : Array<ExecutionPayload> = mapping.getPayloads();
		if ( mappedPayloads != null )
		{
			payloads = payloads.concat( mappedPayloads );
		}
		
		// Map payloads
        if ( payloads != null )
        {
            PayloadUtil.mapPayload( payloads, injector );
        }
		
		// Instantiate command
		var command : Command<ResultType> = null;
		if ( !mapping.hasGuard || GuardUtil.guardsApprove( mapping.getGuards(), injector ) )
        {
			command = injector.getOrCreateNewInstance( mapping.getCommandClass() );
		}

		// Unmap payloads
        if ( payloads != null )
        {
            PayloadUtil.unmapPayload( payloads, injector );
        }
		
		if ( mapping.hasCompleteHandler )   for ( handler in mapping.getCompleteHandlers() ) 	command.onComplete( handler );
		if ( mapping.hasFailHandler )       for ( handler in mapping.getFailHandlers() ) 		command.onFail( handler );
		if ( mapping.hasCancelHandler )     for ( handler in mapping.getCancelHandlers() ) 		command.onCancel( handler );

		return command;
    }
}

