package hex.view.viewhelper;

import hex.di.IDependencyInjector;
import hex.event.LightweightClosureDispatcher;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class ViewHelperManager
{
	static private var _mInstances 	: Map<IModule, ViewHelperManager> 							= new Map<IModule, ViewHelperManager>();
	static private var _ED 			: LightweightClosureDispatcher<MainViewHelperManagerEvent> 	= new LightweightClosureDispatcher<MainViewHelperManagerEvent>();
	
	private var _owner 				: IModule;
	private var _ed 				: LightweightClosureDispatcher<ViewHelperManagerEvent>;
	private var _viewHelpers 		: Array<IViewHelper>;
	
	public function new ( owner : IModule ) 
	{
		this._owner = owner;
		this._ed = new LightweightClosureDispatcher<ViewHelperManagerEvent>();
		this._viewHelpers = [];
	}
	
	static public function getInstance( owner : IModule ) : ViewHelperManager
	{
		var viewHelperManager : ViewHelperManager = ViewHelperManager._mInstances.get( owner );
		if ( viewHelperManager == null )
		{
			viewHelperManager = new ViewHelperManager( owner );
			ViewHelperManager._mInstances.set( owner, viewHelperManager );
			ViewHelperManager.notifyViewHelperManagerCreation( viewHelperManager );
		}

		return viewHelperManager;
	}
	
	static public function release( owner : IModule ) : Void
	{
		var viewHelperManager : ViewHelperManager = ViewHelperManager._mInstances.get( owner );
		if ( viewHelperManager != null )
		{
			ViewHelperManager.notifyViewHelperManagerRelease( viewHelperManager );
			viewHelperManager.releaseAllViewHelpers();
			ViewHelperManager._mInstances.remove( owner );
		}
	}
	
	public function getOwner() : IModule
	{
		return this._owner;
	}
	
	public function releaseAllViewHelpers() : Void
	{
		var len : UInt = this._viewHelpers.length;

		for ( i in 0...len )
		{
			var viewHelper : IViewHelper = this._viewHelpers[ len-i-1 ];
			this._viewHelpers.splice( len-i-1, 1 );
			viewHelper.removeEventListener( ViewHelperEvent.RELEASE, this._onViewHelperRelease );
			viewHelper.release();
			this._notifyViewHelperRelease( viewHelper );
		}
	}
	
	public function buildViewHelper( injector : IDependencyInjector, clazz : Class<IViewHelper>, view : Dynamic ) : IViewHelper
	{
		var viewHelper : IViewHelper = injector.instantiateUnmapped( clazz );

		if ( viewHelper != null )
		{
			this._notifyViewHelperCreation( viewHelper );

			injector.mapToValue( clazz,  viewHelper );
			viewHelper.setOwner( this._owner );
			viewHelper.view = view;
			viewHelper.addEventListener( ViewHelperEvent.RELEASE, this._onViewHelperRelease );
			this._viewHelpers.push( viewHelper );
		}

		return viewHelper;
	}
	
	public function size() : Int
	{
		return this._viewHelpers.length;
	}
	
	private function _onViewHelperRelease( event : ViewHelperEvent ) : Void
	{
		var viewHelper : IViewHelper = event.getViewHelper();
		this._notifyViewHelperRelease( viewHelper );

		var index : Int = this._viewHelpers.indexOf( viewHelper );
		if ( index != -1 )
		{
			this._viewHelpers.splice( index, 1 );
		}
	}
	
	/**
	 * Event System
	 */
	public function addListener( listener : IViewHelperManagerListener ) : Void
	{
		this._ed.addEventListener( ViewHelperManagerEvent.VIEW_HELPER_CREATION, listener.onViewHelperCreation );
		this._ed.addEventListener( ViewHelperManagerEvent.VIEW_HELPER_RELEASE, listener.onViewHelperRelease );
	}

	public function removeListener( listener : IViewHelperManagerListener ) : Void
	{
		this._ed.removeEventListener( ViewHelperManagerEvent.VIEW_HELPER_CREATION, listener.onViewHelperCreation );
		this._ed.removeEventListener( ViewHelperManagerEvent.VIEW_HELPER_RELEASE, listener.onViewHelperRelease );
	}

	private function _notifyViewHelperCreation( viewHelper : IViewHelper ) : Void
	{
		this._ed.dispatchEvent( new ViewHelperManagerEvent( ViewHelperManagerEvent.VIEW_HELPER_CREATION, this, viewHelper ) );
	}

	private function _notifyViewHelperRelease( viewHelper : IViewHelper ) : Void
	{
		this._ed.dispatchEvent( new ViewHelperManagerEvent( ViewHelperManagerEvent.VIEW_HELPER_RELEASE, this, viewHelper ) );
	}
	
	/**
	 * Main Event System
	 */
	static public function addGlobalListener( listener : IMainViewHelperManagerListener ) : Void
	{
		ViewHelperManager._ED.addEventListener( MainViewHelperManagerEvent.VIEW_HELPER_MANAGER_CREATION, listener.onViewHelperManagerCreation );
		ViewHelperManager._ED.addEventListener( MainViewHelperManagerEvent.VIEW_HELPER_MANAGER_RELEASE, listener.onViewHelperManagerRelease );
	}

	static public function removeGlobalListener( listener : IMainViewHelperManagerListener ) : Void
	{
		ViewHelperManager._ED.removeEventListener( MainViewHelperManagerEvent.VIEW_HELPER_MANAGER_CREATION, listener.onViewHelperManagerCreation );
		ViewHelperManager._ED.removeEventListener( MainViewHelperManagerEvent.VIEW_HELPER_MANAGER_RELEASE, listener.onViewHelperManagerRelease );
	}

	private static function notifyViewHelperManagerCreation( viewHelperManager : ViewHelperManager ) : Void
	{
		ViewHelperManager._ED.dispatchEvent( new MainViewHelperManagerEvent( MainViewHelperManagerEvent.VIEW_HELPER_MANAGER_CREATION, ViewHelperManager._ED, viewHelperManager ) );
	}

	private static function notifyViewHelperManagerRelease( viewHelperManager : ViewHelperManager ) : Void
	{
		ViewHelperManager._ED.dispatchEvent( new MainViewHelperManagerEvent( MainViewHelperManagerEvent.VIEW_HELPER_MANAGER_RELEASE, ViewHelperManager._ED, viewHelperManager ) );
	}
}