# hexMVC [![TravisCI Build Status](https://travis-ci.org/DoclerLabs/hexMVC.svg?branch=master)](https://travis-ci.org/DoclerLabs/hexMVC)

hexMVC is a powerful MVC+S framework

*Find more information about hexMachina on [hexmachina.org](http://hexmachina.org/)*

## Dependencies

* [hexCore](https://github.com/DoclerLabs/hexCore)
* [hexReflection](https://github.com/DoclerLabs/hexReflection)
* [hexAnnotation](https://github.com/DoclerLabs/hexAnnotation)
* [hexInject](https://github.com/DoclerLabs/hexInject)
	
	
## Module example with service locator
```haxe
private class MModule extends Module
{
	public function new( serviceLocator : IStatefulConfig )
	{
		super();
		this._addStatefulConfigs( [serviceLocator] );
		this._addStatelessConfigClasses( [MStatelessCommandConfig, MStatelessModelConfig] );
	}
	
	override private function _getRuntimeDependencies() : IRuntimeDependencies
	{
		var rt = new RuntimeDependencies();
		rd.addMappedDependencies( [ new MappingDefinition( IGitService ) ]); 
		return rt;
	}
	
	override public function _onInitialisation() : Void 
	{
		this._dispatchPrivateMessage( MessageTypeList.TEST, new Request( [new ExecutionPayload( something, ISomething )] ) );
	}
}
```
	
## Model config
```haxe
private class MStatelessModelConfig extends StatelessModelConfig
{
	override public function configure() : Void 
	{
		this.map( IMModel, MModel  );
	}
}
```


## Stateful command config
```haxe
private class MStatefulCommandConfig extends StatefulCommandConfig
{
	public function new()
	{
		super();
	}
	
	override public function configure( injector : IDependencyInjector ) : Void
	{
		super.configure( injector );
		this.map( MessageTypeList.TEST, TestCommand ).once().withGuard( MyGuardClass ).withCompleteHandler( function( e : AsyncCommandEvent ){ trace( e ); } );
	}
}
```


## Asynchronous command example with injections
```haxe
private class TestCommand extends AsyncCommand implements IAsyncStatelessServiceListener
{
	@Inject
    public var model : IMModel;
	
	@Inject
    public var service : IGitService;

    override public function execute( ?request : Request ) : Void
    {
		this.service.addListener( this );
		this.service.call();
    }
	
	public function onServiceTimeout( service : IAsyncStatelessService ) : Void 
	{
		this._handleFail();
	}
	
	public function onServiceComplete( service : IAsyncStatelessService ) : Void  
	{
		this.model.setValue( service.getResult() );
		this._handleComplete();
	}
	
	public function onServiceFail( service : IAsyncStatelessService ) : Void 
	{
		this._handleFail();
	}
	
	public function onServiceCancel( service : IAsyncStatelessService ) : Void  
	{
		this._handleCancel();
	}
}
```
