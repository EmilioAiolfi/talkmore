'use strict'

###*
 # @ngdoc service
 # @name talkmoreApp.api
 # @description
 # # api
 # Factory in the talkmoreApp.
###

talkmoreAppServices = angular.module 'talkmoreApp.services'

talkmoreAppServices.factory 'apiFactory', (Restangular) ->

  factory = {}

  factory.getPlans = ->
    Restangular.one('plans').get().then ((data) ->
      data
    ), (error) ->
      error


  factory.getPricing = ->
    Restangular.one('ddd', 'prices').get().then ((data) ->
      data
    ), (error) ->
      error


  factory.getDetails = (data) ->
    Restangular.one('ddd', 'details').get().then ((data) ->
      data
    ), (error) ->
      error

  return factory
