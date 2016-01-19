package hex.metadata;

import hex.module.dependency.IRuntimeDependencies;
import hex.module.dependency.RuntimeDependencies;
import hex.module.Module;

/**
 * ...
 * @author Francis Bourre
 */
class MockModuleForMetaDataProviding extends Module
{
	public var mockObjectWithMetaData 			: MockObjectWithMetaData;
	public var anotherMockObjectWithMetaData 	: MockWithoutIMetaDataParsableImplementation;
		
	public function new() 
	{
		super();
		
		this._getDependencyInjector().mapToType( MockObjectWithMetaData, MockObjectWithMetaData );
		this._getDependencyInjector().mapToType( MockWithoutIMetaDataParsableImplementation, MockWithoutIMetaDataParsableImplementation );
	}
	
	override private function _getRuntimeDependencies() : IRuntimeDependencies 
	{
		return return new RuntimeDependencies();
	}
	
	override private function _onInitialisation() : Void 
	{
		this.mockObjectWithMetaData 		= this._getDependencyInjector().getInstance( MockObjectWithMetaData );
		this.anotherMockObjectWithMetaData 	= this._getDependencyInjector().getInstance( MockWithoutIMetaDataParsableImplementation );
	}
}