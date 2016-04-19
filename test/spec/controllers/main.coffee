'use strict'

describe 'Tests for Controllers', ->
  # load the controller's module
  MainCtrl = {}
  ModalCtrl = {}
  scope = {}
  $httpBackend = undefined
  Restangular = undefined
  baseUrl = undefined
  apiPlans = undefined
  apiPricing = undefined
  apiDetails = undefined
  listPlans = undefined
  modalInstance = undefined
  form = undefined
  templateHtml = undefined
  template = undefined

  # Mocks
  apiPlansMock = [{ plan: 'FaleMais 30', time: '30' }]
  apiPricingMock = { origin: '011', destiny: '016', price: '1.90' }
  apiDetailsMock = { ddd: '011', city: 'São Paulo'}


  beforeEach  ->
    module 'talkmoreApp', ($provide) ->
      $provide.value('apiPlans', apiPlansMock )
      $provide.value('apiPricing', apiPricingMock )
      $provide.value('apiDetails', apiDetailsMock )
      null

    inject ($controller, $rootScope, _$httpBackend_, $compile, $templateCache, _$uibModal_, _Restangular_, _apiFactory_, _apiPlans_, _apiPricing_, _apiDetails_) ->
      # Don't bother injecting a 'real' modal
      $httpBackend = _$httpBackend_
      scope = $rootScope.$new()
      $uibModal = _$uibModal_
      Restangular = _Restangular_
      baseUrl = Restangular.configuration.baseUrl
      apiFactory = _apiFactory_
      apiPlans = _apiPlans_
      apiPricing = _apiPricing_
      apiDetails = _apiDetails_

      modalInstance =
        close: jasmine.createSpy('modalInstance.close')
        dismiss: jasmine.createSpy('modalInstance.dismiss')
        result: then: jasmine.createSpy('modalInstance.result.then')


      spyOn($uibModal, 'open').and.returnValue(modalInstance)

      MainCtrl = $controller('MainCtrl',
        $httpBackend: $httpBackend
        $scope: scope
      )

      ModalCtrl = $controller('ModalInstanceCtrl',
        $scope: scope
        $uibModalInstance: modalInstance
        details: apiDetails
      )

      scope.APIplans = apiPlans
      scope.APIpricing = apiPricing
      scope.APIdetails = apiDetails
      scope.listPlans = scope.APIplans
      scope.APIplans.push
        plan: 'Normal'
        price: '0'


      templateHtml = $templateCache.get 'app/views/main.html'
      template = angular.element('<div>' + templateHtml + '</div>')
      $compile(template)(scope)

      form = scope.frmPlan
      scope.$digest()

  describe 'Controller: MainCtrl', ->

    it 'should have a MainCtrl controller', ->
      expect(MainCtrl).toBeDefined()


    it 'should have resolve apiPlans values', ->
      expect(apiPlans).toBeDefined()


    it 'should have resolve apiPricing values', ->
      expect(apiPricing).toBeDefined()


    it 'should have resolve apiDetails values', ->
      expect(apiDetails).toBeDefined()


    describe 'Tests functions to calculates price', ->

      it 'should have function calculate the minute price of FaleMais 30 with increased 10% on the amount', ->
        expect(scope.calcIncreasePrice).toBeDefined()
        expect(scope.calcIncreasePrice(scope.APIplans[0].time, scope.APIpricing.price, '100')).toBe('146,30')


      it 'should have function calculate normal price per minute', ->
        expect(scope.calcNormalPrice).toBeDefined()
        expect(scope.calcNormalPrice(scope.APIpricing.price, '100')).toBe('190,00')


      it 'should have function changeMinutes ', ->
        expect(scope.changeMinutes).toBeDefined()


    describe 'Tests form frmPlan', ->

      it 'should have pattern to onlyNumbers', ->
        expect(scope.onlyNumbers).toBeDefined()
        expect(scope.onlyNumbers.test("100")).toBeTruthy()
        expect(scope.onlyNumbers.test("100aa")).toBeFalsy()


      it 'should have fields require', ->
        expect(form['txt-ddd-origin'].$valid).toBeFalsy()
        expect(form['txt-ddd-destiny'].$valid).toBeFalsy()
        expect(form['txt-time'].$valid).toBeFalsy()
        expect(form.$valid).toBeFalsy();


      it 'should be invalid when given bad input', ->
        form['txt-time'] = 'Not a number'
        expect(form['txt-time'].$valid).toBeFalsy();
        expect(form.$valid).toBeFalsy();


  describe 'Tests for modal', ->

    it 'should have Animation Enabled for modal', ->
      expect(scope.animationsEnabled).toBeDefined()
      expect(scope.animationsEnabled).toBeTruthy()


    it 'should instantiate the controller ModalInstanceCtrl', ->
      expect(ModalCtrl).toBeDefined()


    it 'should have scopes for controller modal', ->
      expect(scope.modalDetails).toBeDefined()
      expect(scope.getInfoDetails).toBeDefined()
      expect(scope.cancel).toBeDefined()

    it 'should have called the modal dismiss function', ->
        scope.cancel()
        expect(modalInstance.dismiss).toHaveBeenCalled()


    it 'should have called the modal result function', ->
      name = 'txt-ddd-origin'
      event = target:
        name: name

      scope.open(event)
      expect(modalInstance.result.then).toHaveBeenCalled()
