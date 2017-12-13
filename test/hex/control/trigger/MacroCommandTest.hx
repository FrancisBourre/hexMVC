package hex.control.trigger;

import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadUtil;
import hex.control.trigger.mock.*;
import hex.di.IDependencyInjector;
import hex.di.Injector;
import hex.error.IllegalStateException;
import hex.module.ContextModule;
import hex.module.IContextModule;
import hex.unittest.assertion.Assert;
import hex.unittest.runner.MethodRunner;

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
		
		MockMacroCommand.executionCount = 0;
		MockCommand.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
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
		Assert.equals( 1, MockMacroCommand.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommand.command;
		Assert.equals( 1, MockCommand.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 1, AnotherMockCommand.executionCount );
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
		Assert.equals( vos[ 9 ], acmd.pEnum );
	}
	
	@Test( "test MacroCommand failure" )
	public function testMacroCommandFailure() : Void
	{
		MockMacroCommandFailing.command 	= null;
		MockCommandFailing.command 			= null;
		AnotherMockCommand.command 			= null;
		
		MockMacroCommandFailing.executionCount = 0;
		MockCommandFailing.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
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
		Assert.equals( 1, MockMacroCommandFailing.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommandFailing.command;
		Assert.equals( 1, MockCommandFailing.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 0, AnotherMockCommand.executionCount );
		Assert.isNull( acmd );
	}
	
	@Test( "test MacroCommand cancel" )
	public function testMacroCommandCancel() : Void
	{
		MockMacroCommandCancel.command 		= null;
		MockCommandCancel.command 			= null;
		AnotherMockCommand.command 			= null;
		
		MockMacroCommandCancel.executionCount = 0;
		MockCommandCancel.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
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
		Assert.equals( 1, MockMacroCommandCancel.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommandCancel.command;
		Assert.equals( 1, MockCommandCancel.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 0, AnotherMockCommand.executionCount );
		Assert.isNull( acmd );
	}
	
	@Test( "test non atomic MacroCommand failure" )
	public function testNonAtomicMacroCommandFailure() : Void
	{
		MockNonAtomicMacroCommandFailing.command 	= null;
		MockCommandFailing.command 					= null;
		AnotherMockCommand.command 					= null;
		
		MockNonAtomicMacroCommandFailing.executionCount = 0;
		MockCommandFailing.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
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
		Assert.equals( 1, MockNonAtomicMacroCommandFailing.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommandFailing.command;
		Assert.equals( 1, MockCommandFailing.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 1, AnotherMockCommand.executionCount );
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
		
		MockNonAtomicMacroCommandCancel.executionCount = 0;
		MockCommandCancel.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
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
		Assert.equals( 1, MockNonAtomicMacroCommandCancel.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommandCancel.command;
		Assert.equals( 1, MockCommandCancel.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 1, AnotherMockCommand.executionCount );
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
		MockCommand.command 				= null;
		AnotherMockCommand.command 			= null;
		
		MockParallelMacroCommand.executionCount = 0;
		MockCommand.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
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
		Assert.equals( 1, MockParallelMacroCommand.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommand.command;
		Assert.equals( 1, MockCommand.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 1, AnotherMockCommand.executionCount );
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
		
		MockParallelMacroCommandFailing.executionCount = 0;
		MockCommandFailing.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
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
		Assert.equals( 1, MockParallelMacroCommandFailing.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommandFailing.command;
		Assert.equals( 1, MockCommandFailing.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 1, AnotherMockCommand.executionCount );
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
		
		MockParallelMacroCommandCancel.executionCount = 0;
		MockCommandCancel.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
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
		Assert.equals( 1, MockParallelMacroCommandCancel.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommandCancel.command;
		Assert.equals( 1, MockCommandCancel.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 1, AnotherMockCommand.executionCount );
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
		
		MockParallelNonAtomicMacroCommandFailing.executionCount = 0;
		MockCommandFailing.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
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
		Assert.equals( 1, MockParallelNonAtomicMacroCommandFailing.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommandFailing.command;
		Assert.equals( 1, MockCommandFailing.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );

		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 1, AnotherMockCommand.executionCount );
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
		
		MockNonAtomicMacroCommandWithCompleteHandler.executionCount = 0;
		MockCommandCancel.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
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
		Assert.equals( 1, MockParallelNonAtomicMacroCommandCancel.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommandCancel.command;
		Assert.equals( 1, MockCommandCancel.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 1, AnotherMockCommand.executionCount );
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
	
	@Test( "test MacroCommand with guard refused" )
	public function testMacroCommandWithGuardRefused() : Void
	{
		MockMacroCommandWithGuardRefused.command 	= null;
		MockCommand.command 						= null;
		AnotherMockCommand.command 					= null;
		
		MockMacroCommandWithGuardRefused.executionCount = 0;
		MockCommand.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = false;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockMacroCommandWithGuardRefused );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockMacroCommandWithGuardRefused.command;
		Assert.equals( 1, MockMacroCommandWithGuardRefused.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommand.command;
		Assert.equals( 0, MockCommand.executionCount );
		Assert.isNull( cmd );
	}
	
	@Test( "test MacroCommand with guard accepted" )
	public function testMacroCommandWithGuardAccepted() : Void
	{
		MockMacroCommandWithGuardRefused.command 	= null;
		MockCommand.command 						= null;
		AnotherMockCommand.command 					= null;
		
		MockMacroCommandWithGuardRefused.executionCount = 0;
		MockCommand.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockMacroCommandWithGuardRefused );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockMacroCommandWithGuardRefused.command;
		Assert.equals( 1, MockMacroCommandWithGuardRefused.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommand.command;
		Assert.equals( 1, MockCommand.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 1, AnotherMockCommand.executionCount );
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
	
	@Test( "test non atomic MacroCommand with guard refused" )
	public function testNonAtomicMacroCommandWithGuardRefused() : Void
	{
		MockNonAtomicMacroCommandWithGuardRefused.command 	= null;
		MockCommand.command 								= null;
		AnotherMockCommand.command 							= null;
		
		MockNonAtomicMacroCommandWithGuardRefused.executionCount = 0;
		MockCommand.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = false;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockNonAtomicMacroCommandWithGuardRefused );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockNonAtomicMacroCommandWithGuardRefused.command;
		Assert.equals( 1, MockNonAtomicMacroCommandWithGuardRefused.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommand.command;
		Assert.equals( 0, MockCommand.executionCount );
		Assert.isNull( cmd );

		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 1, AnotherMockCommand.executionCount );
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
	
	//
	@Test( "test MacroCommand execution with payload overriding" )
	public function testMacroCommandExecutionWithPayloadOverriding() : Void
	{
		MockMacroCommandWithPayloadOverriding.command 	= null;
		MockCommand.command 							= null;
		AnotherMockCommand.command 						= null;
		
		MockMacroCommandWithPayloadOverriding.executionCount = 0;
		MockCommand.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockMacroCommandWithPayloadOverriding );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockMacroCommandWithPayloadOverriding.command;
		Assert.equals( 1, MockMacroCommandWithPayloadOverriding.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommand.command;
		Assert.equals( 1, MockCommand.executionCount );
		Assert.isTrue( cmd.isCompleted );
		Assert.isFalse( cmd.isFailed );
		Assert.isFalse( cmd.isCancelled );
		
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( 'override', cmd.pString2 );
		Assert.equals( 13, cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 1, AnotherMockCommand.executionCount );
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
	
	@Test( "test MacroCommand execution with complete handler" )
	public function testMacroCommandExecutionWithCompleteHandler() : Void
	{
		MockMacroCommandWithCompleteHandler.command 	= null;
		MockCommand.command 							= null;
		AnotherMockCommand.command 						= null;
		
		MockMacroCommandWithCompleteHandler.executionCount = 0;
		MockCommand.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockMacroCommandWithCompleteHandler );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockMacroCommandWithCompleteHandler.command;
		Assert.equals( 1, MockMacroCommandWithCompleteHandler.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommand.command;
		Assert.equals( 1, MockCommand.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 1, AnotherMockCommand.executionCount );
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
		
		Assert.equals( 2, MockMacroCommandWithCompleteHandler.completeCallCount );
		Assert.equals( 0, MockMacroCommandWithCompleteHandler.failCallCount );
		Assert.equals( 0, MockMacroCommandWithCompleteHandler.cancelCallCount );
	}
	
	@Test( "test MacroCommand execution with cancel handler" )
	public function testMacroCommandExecutionWithCancelHandler() : Void
	{
		MockMacroCommandWithCancelHandler.command 	= null;
		MockCommandCancel.command 					= null;
		AnotherMockCommand.command 					= null;
		
		MockMacroCommandWithCancelHandler.executionCount = 0;
		MockCommandCancel.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockMacroCommandWithCancelHandler );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockMacroCommandWithCancelHandler.command;
		Assert.equals( 1, MockMacroCommandWithCancelHandler.executionCount );
		Assert.isTrue( mo.isAtomic );
		Assert.isFalse( mo.isInParallelMode );
		Assert.isTrue( mo.isCancelled );
		Assert.isFalse( mo.isFailed );
		Assert.isFalse( mo.isCompleted );
		
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommandCancel.command;
		Assert.equals( 1, MockCommandCancel.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 0, AnotherMockCommand.executionCount );
		Assert.isNull( acmd );
		
		Assert.equals( 0, MockMacroCommandWithCancelHandler.completeCallCount );
		Assert.equals( 0, MockMacroCommandWithCancelHandler.failCallCount );
		Assert.equals( 1, MockMacroCommandWithCancelHandler.cancelCallCount );
	}
	
	@Test( "test MacroCommand execution with fail handler" )
	public function testMacroCommandExecutionWithFailHandler() : Void
	{
		MockMacroCommandWithFailHandler.command 	= null;
		MockCommandFailing.command 					= null;
		AnotherMockCommand.command 					= null;
		
		MockMacroCommandWithFailHandler.executionCount = 0;
		MockCommandFailing.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockMacroCommandWithFailHandler );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockMacroCommandWithFailHandler.command;
		Assert.equals( 1, MockMacroCommandWithFailHandler.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommandFailing.command;
		Assert.equals( 1, MockCommandFailing.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 0, AnotherMockCommand.executionCount );
		Assert.isNull( acmd );
		
		Assert.equals( 0, MockMacroCommandWithFailHandler.completeCallCount );
		Assert.equals( 1, MockMacroCommandWithFailHandler.failCallCount );
		Assert.equals( 0, MockMacroCommandWithFailHandler.cancelCallCount );
	}
	
	@Test( "test non atomic MacroCommand execution with complete handler" )
	public function testNonAtomicMacroCommandExecutionWithCompleteHandler() : Void
	{
		MockNonAtomicMacroCommandWithCompleteHandler.command 	= null;
		MockCommand.command 									= null;
		AnotherMockCommand.command 								= null;
		
		MockNonAtomicMacroCommandWithCompleteHandler.executionCount = 0;
		MockCommand.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockNonAtomicMacroCommandWithCompleteHandler );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockNonAtomicMacroCommandWithCompleteHandler.command;
		Assert.equals( 1, MockNonAtomicMacroCommandWithCompleteHandler.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommand.command;
		Assert.equals( 1, MockCommand.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 3, AnotherMockCommand.executionCount );
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
		
		Assert.equals( 2, MockNonAtomicMacroCommandWithCompleteHandler.completeCallCount );
		Assert.equals( 0, MockNonAtomicMacroCommandWithCompleteHandler.failCallCount );
		Assert.equals( 0, MockNonAtomicMacroCommandWithCompleteHandler.cancelCallCount );
	}
	
	@Test( "test non atomic MacroCommand execution with cancel handler" )
	public function testNonAtomicMacroCommandExecutionWithCancelHandler() : Void
	{
		MockNonAtomicMacroCommandWithCancelHandler.command 	= null;
		MockCommandCancel.command 							= null;
		AnotherMockCommand.command 							= null;
		
		MockNonAtomicMacroCommandWithCancelHandler.executionCount = 0;
		MockCommandCancel.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockNonAtomicMacroCommandWithCancelHandler );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockNonAtomicMacroCommandWithCancelHandler.command;
		Assert.equals( 1, MockNonAtomicMacroCommandWithCancelHandler.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommandCancel.command;
		Assert.equals( 2, MockCommandCancel.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 2, AnotherMockCommand.executionCount );
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
		
		Assert.equals( 2, MockNonAtomicMacroCommandWithCancelHandler.completeCallCount );
		Assert.equals( 0, MockNonAtomicMacroCommandWithCancelHandler.failCallCount );
		Assert.equals( 2, MockNonAtomicMacroCommandWithCancelHandler.cancelCallCount );
	}
	
	@Test( "test non atomic MacroCommand execution with fail handler" )
	public function testNonAtomicMacroCommandExecutionWithFailHandler() : Void
	{
		MockNonAtomicMacroCommandWithFailHandler.command 	= null;
		MockCommandFailing.command 							= null;
		AnotherMockCommand.command 							= null;
		
		MockNonAtomicMacroCommandWithFailHandler.executionCount = 0;
		MockCommandFailing.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockNonAtomicMacroCommandWithFailHandler );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		//
		var mo = MockNonAtomicMacroCommandWithFailHandler.command;
		Assert.equals( 1, MockNonAtomicMacroCommandWithFailHandler.executionCount );
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
		Assert.equals( vos[ 9 ], mo.pEnum );
		
		//
		var cmd = MockCommandFailing.command;
		Assert.equals( 2, MockCommandFailing.executionCount );
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
		Assert.equals( vos[ 9 ], cmd.pEnum );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( 2, AnotherMockCommand.executionCount );
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
		
		Assert.equals( 2, MockNonAtomicMacroCommandWithFailHandler.completeCallCount );
		Assert.equals( 2, MockNonAtomicMacroCommandWithFailHandler.failCallCount );
		Assert.equals( 0, MockNonAtomicMacroCommandWithFailHandler.cancelCallCount );
	}
	
	@Test( "test MacroCommand state consistency" )
	public function testMacroCommandStateConsistency() : Void
	{
		MockMacroCommand.command 	= null;
		MockCommand.command 		= null;
		AnotherMockCommand.command 	= null;
		
		MockMacroCommand.executionCount = 0;
		MockCommand.executionCount = 0;
		AnotherMockCommand.executionCount = 0;
		
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
		vos[ 9 ] = MockEnum.TEST;
		
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
			new ExecutionPayload( vos[ 8 ], Date ),
			new ExecutionPayload( vos[ 9 ] ).withClassName( 'hex.control.MockEnum' )
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
		Assert.equals( 1, MockMacroCommand.executionCount );
		Assert.isTrue( mo.isAtomic );
		Assert.isFalse( mo.isInParallelMode );
		Assert.isTrue( mo.isCompleted );
		Assert.isFalse( mo.isFailed );
		Assert.isFalse( mo.isCancelled );
		
		Assert.methodCallThrows( IllegalStateException, mo, mo.add, [ AnotherMockCommand ] );
	}
	
	@Async( "test MacroCommand user case" )
	public function testMacroCommandUserCase() : Void
	{
		var payloads =
		[
			new ExecutionPayload( function() return 46 ).withClassName( 'Void->UInt' )
		];
		
		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( GetUserVOMacro );
		PayloadUtil.unmapPayload( payloads, injector );
		macroCommand.execute();
		
		var userOutcome : MockUserVO;
		macroCommand.onComplete( function( result ) userOutcome = result );
		macroCommand.onComplete( MethodRunner.asyncHandler( this._onUserCaseComplete ) );
	}
	
	function _onUserCaseComplete( userVO : MockUserVO ) : Void
	{
		Assert.equals( 'John Doe', userVO.username );
		Assert.equals( 46, userVO.age );
		Assert.equals( true, userVO.isAdmin );
	}
	
	@Test("Test macro command has owner")
	public function testMacroCommandHasOwner()
	{
		var owner = new ContextModule();
		
		owner.getInjector().mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', [] );
		var macroCommand = owner.getInjector().getOrCreateNewInstance(MockMacroCommandWithChildCommand);
		macroCommand.setOwner(owner);
		
		Assert.isNotNull(macroCommand.getOwner());
		Assert.equals(owner, macroCommand.getOwner());
	}
	
	@Test("Test child command of macro command has owner")
	public function testChildCommandOfMacroCommandHasOwner()
	{
		var owner = new ContextModule();
		
		owner.getInjector().mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', [] );
		var macroCommand = owner.getInjector().getOrCreateNewInstance(MockMacroCommandWithChildCommand);
		macroCommand.setOwner(owner);
		
		macroCommand.execute();
		
		Assert.isNotNull(macroCommand.commandSelfReturn.getOwner());
		Assert.equals(owner, macroCommand.commandSelfReturn.getOwner());
	}
	
}