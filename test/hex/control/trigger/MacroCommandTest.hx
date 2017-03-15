package hex.control.trigger;

import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadUtil;
import hex.control.trigger.mock.AnotherMockCommand;
import hex.control.trigger.mock.MockCommand;
import hex.control.trigger.mock.MockCommandCancel;
import hex.control.trigger.mock.MockCommandFailing;
import hex.control.trigger.mock.MockMacroCommand;
import hex.control.trigger.mock.MockMacroCommandCancel;
import hex.control.trigger.mock.MockMacroCommandFailing;
import hex.control.trigger.mock.MockNonAtomicMacroCommandCancel;
import hex.control.trigger.mock.MockNonAtomicMacroCommandFailing;
import hex.control.trigger.mock.MockParallelMacroCommand;
import hex.control.trigger.mock.MockParallelMacroCommandCancel;
import hex.control.trigger.mock.MockParallelMacroCommandFailing;
import hex.control.trigger.mock.MockParallelNonAtomicMacroCommandCancel;
import hex.control.trigger.mock.MockParallelNonAtomicMacroCommandFailing;
import hex.di.IDependencyInjector;
import hex.di.Injector;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class MacroCommandTest 
{
	@Test( "test MacroCommand execution" )
	public function testMacroCommandExecution() : Void
	{
		MockMacroCommand.command 	= null;
		MockCommand.command 		= null;
		AnotherMockCommand.command 	= null;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		
		var payloads =
		[
			new ExecutionPayload( vos[ 0 ], String, 'name1' ),
			new ExecutionPayload( vos[ 1 ] ).withClassName( 'String' ).withName( 'name2' ),
			new ExecutionPayload( vos[ 2 ] ).withClassName( 'Int' ),
			new ExecutionPayload( vos[ 3 ] ).withClassName( 'UInt' ),
			new ExecutionPayload( vos[ 4 ] ).withClassName( 'Float' ),
			new ExecutionPayload( vos[ 5 ] ).withClassName( 'Bool' ),
			new ExecutionPayload( vos[ 6 ] ).withClassName( 'Array<String>' ),
			new ExecutionPayload( vos[ 7 ] ).withClassName( 'Map<String, String>' ),
			new ExecutionPayload( vos[ 8 ], Date )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockMacroCommand );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockMacroCommand.command;
		Assert.isTrue( mo.isAtomic );
		Assert.isFalse( mo.isInParallelMode );
		Assert.isTrue( mo.isCompleted );
		Assert.isFalse( mo.isFailed );
		Assert.isFalse( mo.isCancelled );
		
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		
		//
		var cmd = MockCommand.command;
		Assert.isTrue( cmd.isCompleted );
		Assert.isFalse( cmd.isFailed );
		Assert.isFalse( cmd.isCancelled );
		
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.isTrue( acmd.isCompleted );
		Assert.isFalse( acmd.isFailed );
		Assert.isFalse( acmd.isCancelled );
		
		Assert.equals( vos[ 0 ], acmd.pString1 );
		Assert.equals( vos[ 1 ], acmd.pString2 );
		Assert.equals( vos[ 2 ], acmd.pInt );
		Assert.equals( vos[ 3 ], acmd.pUInt );
		Assert.equals( vos[ 4 ], acmd.pFloat );
		Assert.equals( vos[ 5 ], acmd.pBool );
		Assert.equals( vos[ 6 ], acmd.pArray );
		Assert.equals( vos[ 7 ], acmd.pStringMap );
		Assert.equals( vos[ 8 ], acmd.pDate );
	}
	
	@Test( "test MacroCommand failure" )
	public function testMacroCommandFailure() : Void
	{
		MockMacroCommandFailing.command 	= null;
		MockCommandFailing.command 			= null;
		AnotherMockCommand.command 			= null;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		
		var payloads =
		[
			new ExecutionPayload( vos[ 0 ], String, 'name1' ),
			new ExecutionPayload( vos[ 1 ] ).withClassName( 'String' ).withName( 'name2' ),
			new ExecutionPayload( vos[ 2 ] ).withClassName( 'Int' ),
			new ExecutionPayload( vos[ 3 ] ).withClassName( 'UInt' ),
			new ExecutionPayload( vos[ 4 ] ).withClassName( 'Float' ),
			new ExecutionPayload( vos[ 5 ] ).withClassName( 'Bool' ),
			new ExecutionPayload( vos[ 6 ] ).withClassName( 'Array<String>' ),
			new ExecutionPayload( vos[ 7 ] ).withClassName( 'Map<String, String>' ),
			new ExecutionPayload( vos[ 8 ], Date )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockMacroCommandFailing );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockMacroCommandFailing.command;
		Assert.isTrue( mo.isAtomic );
		Assert.isFalse( mo.isInParallelMode );
		Assert.isTrue( mo.isFailed );
		Assert.isFalse( mo.isCompleted );
		Assert.isFalse( mo.isCancelled );
		
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		
		//
		var cmd = MockCommandFailing.command;
		Assert.isTrue( cmd.isFailed );
		Assert.isFalse( cmd.isCompleted );
		Assert.isFalse( cmd.isCancelled );
		
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.isNull( acmd );
	}
	
	@Test( "test MacroCommand cancel" )
	public function testMacroCommandCancel() : Void
	{
		MockMacroCommandCancel.command 		= null;
		MockCommandCancel.command 			= null;
		AnotherMockCommand.command 			= null;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		
		var payloads =
		[
			new ExecutionPayload( vos[ 0 ], String, 'name1' ),
			new ExecutionPayload( vos[ 1 ] ).withClassName( 'String' ).withName( 'name2' ),
			new ExecutionPayload( vos[ 2 ] ).withClassName( 'Int' ),
			new ExecutionPayload( vos[ 3 ] ).withClassName( 'UInt' ),
			new ExecutionPayload( vos[ 4 ] ).withClassName( 'Float' ),
			new ExecutionPayload( vos[ 5 ] ).withClassName( 'Bool' ),
			new ExecutionPayload( vos[ 6 ] ).withClassName( 'Array<String>' ),
			new ExecutionPayload( vos[ 7 ] ).withClassName( 'Map<String, String>' ),
			new ExecutionPayload( vos[ 8 ], Date )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockMacroCommandCancel );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockMacroCommandCancel.command;
		Assert.isTrue( mo.isAtomic );
		Assert.isFalse( mo.isInParallelMode );
		Assert.isTrue( mo.isCancelled );
		Assert.isFalse( mo.isCompleted );
		Assert.isFalse( mo.isFailed );
		
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		
		//
		var cmd = MockCommandCancel.command;
		Assert.isTrue( cmd.isCancelled );
		Assert.isFalse( cmd.isCompleted );
		Assert.isFalse( cmd.isFailed );
		
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.isNull( acmd );
	}
	
	@Test( "test non atomic MacroCommand failure" )
	public function testNonAtomicMacroCommandFailure() : Void
	{
		MockNonAtomicMacroCommandFailing.command 	= null;
		MockCommandFailing.command 					= null;
		AnotherMockCommand.command 					= null;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		
		var payloads =
		[
			new ExecutionPayload( vos[ 0 ], String, 'name1' ),
			new ExecutionPayload( vos[ 1 ] ).withClassName( 'String' ).withName( 'name2' ),
			new ExecutionPayload( vos[ 2 ] ).withClassName( 'Int' ),
			new ExecutionPayload( vos[ 3 ] ).withClassName( 'UInt' ),
			new ExecutionPayload( vos[ 4 ] ).withClassName( 'Float' ),
			new ExecutionPayload( vos[ 5 ] ).withClassName( 'Bool' ),
			new ExecutionPayload( vos[ 6 ] ).withClassName( 'Array<String>' ),
			new ExecutionPayload( vos[ 7 ] ).withClassName( 'Map<String, String>' ),
			new ExecutionPayload( vos[ 8 ], Date )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockNonAtomicMacroCommandFailing );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockNonAtomicMacroCommandFailing.command;
		Assert.isFalse( mo.isAtomic );
		Assert.isFalse( mo.isInParallelMode );
		Assert.isTrue( mo.isCompleted );
		Assert.isFalse( mo.isFailed );
		Assert.isFalse( mo.isCancelled );
		
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		
		//
		var cmd = MockCommandFailing.command;
		Assert.isTrue( cmd.isFailed );
		Assert.isFalse( cmd.isCompleted );
		Assert.isFalse( cmd.isCancelled );
		
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		
		//
		//
		var acmd = AnotherMockCommand.command;
		Assert.isTrue( acmd.isCompleted );
		Assert.isFalse( acmd.isFailed );
		Assert.isFalse( acmd.isCancelled );
		
		Assert.equals( vos[ 0 ], acmd.pString1 );
		Assert.equals( vos[ 1 ], acmd.pString2 );
		Assert.equals( vos[ 2 ], acmd.pInt );
		Assert.equals( vos[ 3 ], acmd.pUInt );
		Assert.equals( vos[ 4 ], acmd.pFloat );
		Assert.equals( vos[ 5 ], acmd.pBool );
		Assert.equals( vos[ 6 ], acmd.pArray );
		Assert.equals( vos[ 7 ], acmd.pStringMap );
		Assert.equals( vos[ 8 ], acmd.pDate );
	}
	
	@Test( "test non atomic MacroCommand cancel" )
	public function testNonAtomicMacroCommandCancel() : Void
	{
		MockNonAtomicMacroCommandCancel.command 	= null;
		MockCommandCancel.command 					= null;
		AnotherMockCommand.command 					= null;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		
		var payloads =
		[
			new ExecutionPayload( vos[ 0 ], String, 'name1' ),
			new ExecutionPayload( vos[ 1 ] ).withClassName( 'String' ).withName( 'name2' ),
			new ExecutionPayload( vos[ 2 ] ).withClassName( 'Int' ),
			new ExecutionPayload( vos[ 3 ] ).withClassName( 'UInt' ),
			new ExecutionPayload( vos[ 4 ] ).withClassName( 'Float' ),
			new ExecutionPayload( vos[ 5 ] ).withClassName( 'Bool' ),
			new ExecutionPayload( vos[ 6 ] ).withClassName( 'Array<String>' ),
			new ExecutionPayload( vos[ 7 ] ).withClassName( 'Map<String, String>' ),
			new ExecutionPayload( vos[ 8 ], Date )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockNonAtomicMacroCommandCancel );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockNonAtomicMacroCommandCancel.command;
		Assert.isFalse( mo.isAtomic );
		Assert.isFalse( mo.isInParallelMode );
		Assert.isTrue( mo.isCompleted );
		Assert.isFalse( mo.isFailed );
		Assert.isFalse( mo.isCancelled );
		
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		
		//
		var cmd = MockCommandCancel.command;
		Assert.isTrue( cmd.isCancelled );
		Assert.isFalse( cmd.isCompleted );
		Assert.isFalse( cmd.isFailed );
		
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.isTrue( acmd.isCompleted );
		Assert.isFalse( acmd.isFailed );
		Assert.isFalse( acmd.isCancelled );
		
		Assert.equals( vos[ 0 ], acmd.pString1 );
		Assert.equals( vos[ 1 ], acmd.pString2 );
		Assert.equals( vos[ 2 ], acmd.pInt );
		Assert.equals( vos[ 3 ], acmd.pUInt );
		Assert.equals( vos[ 4 ], acmd.pFloat );
		Assert.equals( vos[ 5 ], acmd.pBool );
		Assert.equals( vos[ 6 ], acmd.pArray );
		Assert.equals( vos[ 7 ], acmd.pStringMap );
		Assert.equals( vos[ 8 ], acmd.pDate );
	}
	
	@Test( "test MacroCommand parallel execution" )
	public function testMacroCommandParallelExecution() : Void
	{
		MockParallelMacroCommand.command 	= null;
		MockCommand.command 		= null;
		AnotherMockCommand.command 	= null;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		
		var payloads =
		[
			new ExecutionPayload( vos[ 0 ], String, 'name1' ),
			new ExecutionPayload( vos[ 1 ] ).withClassName( 'String' ).withName( 'name2' ),
			new ExecutionPayload( vos[ 2 ] ).withClassName( 'Int' ),
			new ExecutionPayload( vos[ 3 ] ).withClassName( 'UInt' ),
			new ExecutionPayload( vos[ 4 ] ).withClassName( 'Float' ),
			new ExecutionPayload( vos[ 5 ] ).withClassName( 'Bool' ),
			new ExecutionPayload( vos[ 6 ] ).withClassName( 'Array<String>' ),
			new ExecutionPayload( vos[ 7 ] ).withClassName( 'Map<String, String>' ),
			new ExecutionPayload( vos[ 8 ], Date )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockParallelMacroCommand );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockParallelMacroCommand.command;
		Assert.isTrue( mo.isInParallelMode );
		Assert.isTrue( mo.isCompleted );
		Assert.isFalse( mo.isFailed );
		Assert.isFalse( mo.isCancelled );
		
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		
		//
		var cmd = MockCommand.command;
		Assert.isTrue( cmd.isCompleted );
		Assert.isFalse( cmd.isFailed );
		Assert.isFalse( cmd.isCancelled );
		
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.isTrue( acmd.isCompleted );
		Assert.isFalse( acmd.isFailed );
		Assert.isFalse( acmd.isCancelled );
		
		Assert.equals( vos[ 0 ], acmd.pString1 );
		Assert.equals( vos[ 1 ], acmd.pString2 );
		Assert.equals( vos[ 2 ], acmd.pInt );
		Assert.equals( vos[ 3 ], acmd.pUInt );
		Assert.equals( vos[ 4 ], acmd.pFloat );
		Assert.equals( vos[ 5 ], acmd.pBool );
		Assert.equals( vos[ 6 ], acmd.pArray );
		Assert.equals( vos[ 7 ], acmd.pStringMap );
		Assert.equals( vos[ 8 ], acmd.pDate );
	}
	
	@Test( "test MacroCommand parallel failure" )
	public function testMacroCommandParallelFailure() : Void
	{
		MockParallelMacroCommandFailing.command 	= null;
		MockCommandFailing.command 					= null;
		AnotherMockCommand.command 					= null;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		
		var payloads =
		[
			new ExecutionPayload( vos[ 0 ], String, 'name1' ),
			new ExecutionPayload( vos[ 1 ] ).withClassName( 'String' ).withName( 'name2' ),
			new ExecutionPayload( vos[ 2 ] ).withClassName( 'Int' ),
			new ExecutionPayload( vos[ 3 ] ).withClassName( 'UInt' ),
			new ExecutionPayload( vos[ 4 ] ).withClassName( 'Float' ),
			new ExecutionPayload( vos[ 5 ] ).withClassName( 'Bool' ),
			new ExecutionPayload( vos[ 6 ] ).withClassName( 'Array<String>' ),
			new ExecutionPayload( vos[ 7 ] ).withClassName( 'Map<String, String>' ),
			new ExecutionPayload( vos[ 8 ], Date )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockParallelMacroCommandFailing );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockParallelMacroCommandFailing.command;
		Assert.isTrue( mo.isInParallelMode );
		Assert.isTrue( mo.isFailed );
		Assert.isFalse( mo.isCompleted );
		Assert.isFalse( mo.isCancelled );
		
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		
		//
		var cmd = MockCommandFailing.command;
		Assert.isTrue( cmd.isFailed );
		Assert.isFalse( cmd.isCompleted );
		Assert.isFalse( cmd.isCancelled );
		
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.isTrue( acmd.isCompleted );
		Assert.isFalse( acmd.isFailed );
		Assert.isFalse( acmd.isCancelled );
		
		Assert.equals( vos[ 0 ], acmd.pString1 );
		Assert.equals( vos[ 1 ], acmd.pString2 );
		Assert.equals( vos[ 2 ], acmd.pInt );
		Assert.equals( vos[ 3 ], acmd.pUInt );
		Assert.equals( vos[ 4 ], acmd.pFloat );
		Assert.equals( vos[ 5 ], acmd.pBool );
		Assert.equals( vos[ 6 ], acmd.pArray );
		Assert.equals( vos[ 7 ], acmd.pStringMap );
		Assert.equals( vos[ 8 ], acmd.pDate );
	}
	
	@Test( "test MacroCommand parallel cancel" )
	public function testMacroCommandParallelCancel() : Void
	{
		MockParallelMacroCommandCancel.command 	= null;
		MockCommandCancel.command 				= null;
		AnotherMockCommand.command 				= null;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		
		var payloads =
		[
			new ExecutionPayload( vos[ 0 ], String, 'name1' ),
			new ExecutionPayload( vos[ 1 ] ).withClassName( 'String' ).withName( 'name2' ),
			new ExecutionPayload( vos[ 2 ] ).withClassName( 'Int' ),
			new ExecutionPayload( vos[ 3 ] ).withClassName( 'UInt' ),
			new ExecutionPayload( vos[ 4 ] ).withClassName( 'Float' ),
			new ExecutionPayload( vos[ 5 ] ).withClassName( 'Bool' ),
			new ExecutionPayload( vos[ 6 ] ).withClassName( 'Array<String>' ),
			new ExecutionPayload( vos[ 7 ] ).withClassName( 'Map<String, String>' ),
			new ExecutionPayload( vos[ 8 ], Date )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockParallelMacroCommandCancel );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockParallelMacroCommandCancel.command;
		Assert.isTrue( mo.isAtomic );
		Assert.isTrue( mo.isInParallelMode );
		Assert.isTrue( mo.isCancelled );
		Assert.isFalse( mo.isCompleted );
		Assert.isFalse( mo.isFailed );
		
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		
		//
		var cmd = MockCommandCancel.command;
		Assert.isTrue( cmd.isCancelled );
		Assert.isFalse( cmd.isCompleted );
		Assert.isFalse( cmd.isFailed );
		
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.isTrue( acmd.isCompleted );
		Assert.isFalse( acmd.isFailed );
		Assert.isFalse( acmd.isCancelled );
		
		Assert.equals( vos[ 0 ], acmd.pString1 );
		Assert.equals( vos[ 1 ], acmd.pString2 );
		Assert.equals( vos[ 2 ], acmd.pInt );
		Assert.equals( vos[ 3 ], acmd.pUInt );
		Assert.equals( vos[ 4 ], acmd.pFloat );
		Assert.equals( vos[ 5 ], acmd.pBool );
		Assert.equals( vos[ 6 ], acmd.pArray );
		Assert.equals( vos[ 7 ], acmd.pStringMap );
		Assert.equals( vos[ 8 ], acmd.pDate );
	}
	
	@Test( "test parallel non atomic MacroCommand failure" )
	public function testParallelNonAtomicMacroCommandFailure() : Void
	{
		MockParallelNonAtomicMacroCommandFailing.command 	= null;
		MockCommandFailing.command 							= null;
		AnotherMockCommand.command 							= null;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		
		var payloads =
		[
			new ExecutionPayload( vos[ 0 ], String, 'name1' ),
			new ExecutionPayload( vos[ 1 ] ).withClassName( 'String' ).withName( 'name2' ),
			new ExecutionPayload( vos[ 2 ] ).withClassName( 'Int' ),
			new ExecutionPayload( vos[ 3 ] ).withClassName( 'UInt' ),
			new ExecutionPayload( vos[ 4 ] ).withClassName( 'Float' ),
			new ExecutionPayload( vos[ 5 ] ).withClassName( 'Bool' ),
			new ExecutionPayload( vos[ 6 ] ).withClassName( 'Array<String>' ),
			new ExecutionPayload( vos[ 7 ] ).withClassName( 'Map<String, String>' ),
			new ExecutionPayload( vos[ 8 ], Date )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockParallelNonAtomicMacroCommandFailing );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockParallelNonAtomicMacroCommandFailing.command;
		Assert.isFalse( mo.isAtomic );
		Assert.isTrue( mo.isInParallelMode );
		Assert.isTrue( mo.isCompleted );
		Assert.isFalse( mo.isFailed );
		Assert.isFalse( mo.isCancelled );
		
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		
		//
		var cmd = MockCommandFailing.command;
		Assert.isTrue( cmd.isFailed );
		Assert.isFalse( cmd.isCompleted );
		Assert.isFalse( cmd.isCancelled );
		
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		
		//
		//
		var acmd = AnotherMockCommand.command;
		Assert.isTrue( acmd.isCompleted );
		Assert.isFalse( acmd.isFailed );
		Assert.isFalse( acmd.isCancelled );
		
		Assert.equals( vos[ 0 ], acmd.pString1 );
		Assert.equals( vos[ 1 ], acmd.pString2 );
		Assert.equals( vos[ 2 ], acmd.pInt );
		Assert.equals( vos[ 3 ], acmd.pUInt );
		Assert.equals( vos[ 4 ], acmd.pFloat );
		Assert.equals( vos[ 5 ], acmd.pBool );
		Assert.equals( vos[ 6 ], acmd.pArray );
		Assert.equals( vos[ 7 ], acmd.pStringMap );
		Assert.equals( vos[ 8 ], acmd.pDate );
	}
	
	@Test( "test parallel non atomic MacroCommand cancel" )
	public function testParallelNonAtomicMacroCommandCancel() : Void
	{
		MockParallelNonAtomicMacroCommandCancel.command 	= null;
		MockCommandCancel.command 							= null;
		AnotherMockCommand.command 							= null;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		
		var payloads =
		[
			new ExecutionPayload( vos[ 0 ], String, 'name1' ),
			new ExecutionPayload( vos[ 1 ] ).withClassName( 'String' ).withName( 'name2' ),
			new ExecutionPayload( vos[ 2 ] ).withClassName( 'Int' ),
			new ExecutionPayload( vos[ 3 ] ).withClassName( 'UInt' ),
			new ExecutionPayload( vos[ 4 ] ).withClassName( 'Float' ),
			new ExecutionPayload( vos[ 5 ] ).withClassName( 'Bool' ),
			new ExecutionPayload( vos[ 6 ] ).withClassName( 'Array<String>' ),
			new ExecutionPayload( vos[ 7 ] ).withClassName( 'Map<String, String>' ),
			new ExecutionPayload( vos[ 8 ], Date )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockParallelNonAtomicMacroCommandCancel );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockParallelNonAtomicMacroCommandCancel.command;
		Assert.isFalse( mo.isAtomic );
		Assert.isTrue( mo.isInParallelMode );
		Assert.isTrue( mo.isCompleted );
		Assert.isFalse( mo.isFailed );
		Assert.isFalse( mo.isCancelled );
		
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		
		//
		var cmd = MockCommandCancel.command;
		Assert.isTrue( cmd.isCancelled );
		Assert.isFalse( cmd.isCompleted );
		Assert.isFalse( cmd.isFailed );
		
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.isTrue( acmd.isCompleted );
		Assert.isFalse( acmd.isFailed );
		Assert.isFalse( acmd.isCancelled );
		
		Assert.equals( vos[ 0 ], acmd.pString1 );
		Assert.equals( vos[ 1 ], acmd.pString2 );
		Assert.equals( vos[ 2 ], acmd.pInt );
		Assert.equals( vos[ 3 ], acmd.pUInt );
		Assert.equals( vos[ 4 ], acmd.pFloat );
		Assert.equals( vos[ 5 ], acmd.pBool );
		Assert.equals( vos[ 6 ], acmd.pArray );
		Assert.equals( vos[ 7 ], acmd.pStringMap );
		Assert.equals( vos[ 8 ], acmd.pDate );
	}
}