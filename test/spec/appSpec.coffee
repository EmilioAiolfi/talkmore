'use strict'

describe 'Testing Modules', ->
  describe 'App Module:', ->

    module = undefined

    beforeEach ->
      module = angular.module('talkmoreApp')

    it 'should be registered', ->
      expect(module).not.toBe null

    describe 'Dependencies:', ->
      deps = undefined
      hasModule = (m) ->
        deps.indexOf(m) >= 0

      beforeEach ->
        deps = module.value('appName').requires

      #you can also test the module's dependencies

      it 'should have ngAnimate as a dependency', ->
        expect(hasModule('ngAnimate')).toBe true

      it 'should have ngAria as a dependency', ->
        expect(hasModule('ngAria')).toBe true

      it 'should have ngCookies as a dependency', ->
        expect(hasModule('ngCookies')).toBe true

      it 'should have ngResource as a dependency', ->
        expect(hasModule('ngResource')).toBe true

      it 'should have ngSanitize as a dependency', ->
        expect(hasModule('ngSanitize')).toBe true

      it 'should have ngTouch as a dependency', ->
        expect(hasModule('ngTouch')).toBe true

      it 'should have ui.bootstrap as a dependency', ->
        expect(hasModule('ui.bootstrap')).toBe true

      it 'should have ui.router as a dependency', ->
        expect(hasModule('ui.router')).toBe true

      it 'should have angular-loading-bar as a dependency', ->
        expect(hasModule('angular-loading-bar')).toBe true

      it 'should have restangular as a dependency', ->
        expect(hasModule('restangular')).toBe true

      it "should have talkmoreApp.services as a dependency", ->
        expect(hasModule('talkmoreApp.services')).toBe true

      it 'should have talkmoreApp.controllers as a dependency', ->
        expect(hasModule('talkmoreApp.controllers')).toBe true



describe 'App Config Phase:', ->

  describe 'html5Mode', ->
    $locationProvider = undefined

    beforeEach ->
      angular.module('locationProviderConfig', []).config (_$locationProvider_) ->
        $locationProvider = _$locationProvider_
        spyOn $locationProvider, 'html5Mode'

      module 'locationProviderConfig'
      module 'talkmoreApp'
      inject()

    it 'should set html5 mode', ->
      expect($locationProvider.html5Mode).toHaveBeenCalledWith true

  describe 'Restangular:', ->
    describe 'Test if setBaseUrl was called', ->
      RestangularProvider = undefined
      spy = undefined

      beforeEach ->
        module 'restangular', (_RestangularProvider_) ->
          RestangularProvider = _RestangularProvider_
          spyOn(RestangularProvider, 'setBaseUrl').and.callThrough()

        module 'talkmoreApp'
        inject()

      it 'should call setBaseUrl.', ->
        expect(RestangularProvider.setBaseUrl).toHaveBeenCalledWith 'http://private-36747-talkmore.apiary-mock.com/'


  describe 'Testing States', ->

    describe 'states', ->
      rootScope = undefined
      state = undefined
      location = undefined
      beforeEach angular.mock.module('ui.router')
      beforeEach angular.mock.module('talkmoreApp')

      beforeEach inject(($rootScope, $state, $location, $templateCache) ->
        rootScope = $rootScope
        state = $state
        location = $location
        $templateCache.put('views/404.html', '404 - Not Found')
      )

      it 'should respond home state', ->
        expect(state.href('home')).toEqual '/'

      it 'init path is correct', ->
        rootScope.$emit '$locationChangeSuccess'
        expect(location.path()).toBe '/'

      it 'redirects to otherwise page after locationChangeSuccess', ->
        location.path '/nonExistentPath'
        rootScope.$digest()
        expect(location.path()).toBe '/404'


    describe 'Routes test with resolves', ->
      $httpBackend = undefined
      $rootScope = undefined
      $state = undefined
      $injector = undefined
      apiPlansMock = undefined
      Restangular = undefined
      baseUrl = undefined
      state = 'home'
      spy = undefined

      beforeEach angular.mock.module('ui.router')

      beforeEach module('talkmoreApp', ($provide) ->
        $provide.value('apiPlans', apiPlansMock = {})
        $provide.value('apiPricing', apiPricingMock = {})
        $provide.value('apiDetails', apiDetailsMock = {})
        null
      )


      beforeEach inject((_$state_, _$injector_, _$httpBackend_, _Restangular_, $templateCache) ->
        $httpBackend = _$httpBackend_
        Restangular = _Restangular_
        baseUrl = Restangular.configuration.baseUrl
        $state = _$state_
        $injector = _$injector_

        $templateCache.put 'views/main.html', 'HTML Home'

        $httpBackend.whenGET(baseUrl + '/plans').respond({ plan: 'Talkmore 30', time: '30' })
        $httpBackend.whenGET(baseUrl + '/ddd/prices').respond({ origin: '011', destiny: '016', price: '1.90' })
        $httpBackend.whenGET(baseUrl + '/ddd/details').respond({ ddd: '011', city: 'São Paulo' })

      )


      it 'should respond to URL', ->
        expect($state.href(state)).toEqual '/'

      it 'should load the index page on successful load of /', ->

        $state.go state
        $httpBackend.flush()

        expect($state.current.name).toBe state

        $injector.invoke($state.current.resolve.apiPlans).then((res) ->
          expect(res.plan).toEqual 'Talkmore 30'
          expect(res.time).toEqual '30'
        )

        $injector.invoke($state.current.resolve.apiPricing).then((res) ->
          expect(res.origin).toEqual '011'
          expect(res.destiny).toEqual '016'
          expect(res.price).toEqual '1.90'
        )

        $injector.invoke($state.current.resolve.apiDetails).then((res) ->
          expect(res.ddd).toEqual '011'
          expect(res.city).toEqual 'São Paulo'
        )

        $httpBackend.flush()
