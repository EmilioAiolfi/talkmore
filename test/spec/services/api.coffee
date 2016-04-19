'use strict'

describe 'Services', ->

  beforeEach module('talkmoreApp')
  apiFactory = undefined
  Restangular = undefined
  $httpBackend = undefined
  baseUrl = undefined
  mockPlans = undefined
  mockPricing = undefined
  mockDetails = undefined

  beforeEach inject((_$httpBackend_, _Restangular_, _apiFactory_) ->
    $httpBackend = _$httpBackend_
    Restangular = _Restangular_
    baseUrl = Restangular.configuration.baseUrl
    apiFactory = _apiFactory_
    $httpBackend.whenGET(/\.html$/).respond ''

    mockPlans = [
      {
        plan: 'FaleMais 30'
        time: '30'
      }
    ]

    mockPricing = [
      {
        origin: '011'
        destiny: '016'
        price: '1.90'
      }
    ]

    mockDetails = [
      {
        ddd: '011'
        city: 'São Paulo'
      }
    ]


    $httpBackend.whenGET(baseUrl + '/plans').respond(mockPlans);
    $httpBackend.whenGET(baseUrl + '/ddd/pricing').respond(mockPricing);
    $httpBackend.whenGET(baseUrl + '/ddd/details').respond(mockDetails);

  )

  afterEach inject(($httpBackend, $rootScope) ->
    $httpBackend.flush()
    $rootScope.$digest()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    return
  )


  describe 'apiFactory', ->

    describe 'getPlans', ->

      it 'should return an array of items', ->
        expect(apiFactory.getPlans()).toBeDefined()

      it 'can fetch the list of Plans from the API', ->
        $httpBackend.expectGET(baseUrl + '/plans')

        apiFactory.getPlans().then ((plans) ->
          expect(plans.length).toEqual 1
        )

      it 'Error Status 500', ->
        result = undefined
        $httpBackend.expectGET(baseUrl + '/plans').respond 500

        apiFactory.getPlans().then ((plans) ->
          expect(plans.status).toEqual 500
        )


    describe 'getPricing', ->

      it 'should return an array of items', ->
        expect(apiFactory.getPricing()).toBeDefined()

      it 'can fetch the list of Plans from the API', ->
        $httpBackend.expectGET(baseUrl + '/ddd/pricing')

        apiFactory.getPricing().then ((pricing) ->
          expect(pricing.length).toEqual 1
        )

      it 'Error Status 500', ->
        result = undefined
        $httpBackend.expectGET(baseUrl + '/ddd/pricing').respond 500

        apiFactory.getPricing().then ((pricing) ->
          expect(pricing.status).toEqual 500
        )


    describe 'getDetails', ->

      it 'should return an array of items', ->
        expect(apiFactory.getDetails()).toBeDefined()

      it 'can fetch the list of Plans from the API', ->
        $httpBackend.expectGET(baseUrl + '/ddd/details')

        apiFactory.getDetails().then ((details) ->
          expect(details.length).toEqual 1
        )

      it 'Error Status 500', ->
        result = undefined
        $httpBackend.expectGET(baseUrl + '/ddd/details').respond 500

        apiFactory.getDetails().then ((details) ->
          expect(details.status).toEqual 500
        )
