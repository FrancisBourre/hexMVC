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
	
	public function getAnnotationProvider() : AnnotationProvider
	{
		return cast this._annotationProvider;
	}
	
	override function _getRuntimeDependencies() : IRuntimeDependencies 
	{
		return return new RuntimeDependencies();
	}
	
	override function _onInitialisation() : Void 
	{
		rebuildComponents();
	}
	
	public function rebuildComponents() : Void 
	{
		this.mockObjectWithMetaData 		= this._getDependencyInjector().getInstance( MockObjectWithAnnotation );
		this.anotherMockObjectWithMetaData 	= this._getDependencyInjector().getInstance( MockWithoutIAnnotationParsableImplementation );
	}
}