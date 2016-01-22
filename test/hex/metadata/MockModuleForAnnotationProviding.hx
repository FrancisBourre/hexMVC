package hex.metadata;

import hex.module.dependency.IRuntimeDependencies;
import hex.module.dependency.RuntimeDependencies;
import hex.module.Module;

/**
 * ...
 * @author Francis Bourre
 */
class MockModuleForAnnotationProviding extends Module
{
	public var mockObjectWithMetaData 			: MockObjectWithAnnotation;
	public var anotherMockObjectWithMetaData 	: MockWithoutIAnnotationParsableImplementation;
		
	public function new() 
	{
		super();
		
		this._getDependencyInjector().mapToType( MockObjectWithAnnotation, MockObjectWithAnnotation );
		this._getDependencyInjector().mapToType( MockWithoutIAnnotationParsableImplementation, MockWithoutIAnnotationParsableImplementation );
	}
	
	override private function _getRuntimeDependencies() : IRuntimeDependencies 
	{
		return return new RuntimeDependencies();
	}
	
	override private function _onInitialisation() : Void 
	{
		this.mockObjectWithMetaData 		= this._getDependencyInjector().getInstance( MockObjectWithAnnotation );
		this.anotherMockObjectWithMetaData 	= this._getDependencyInjector().getInstance( MockWithoutIAnnotationParsableImplementation );
	}
}